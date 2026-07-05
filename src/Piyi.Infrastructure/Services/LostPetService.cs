#nullable enable
#pragma warning disable CS8601
using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.LostPets;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class LostPetService : ILostPetService
{
    private readonly PiyiDbContext _dbContext;

    public LostPetService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<LostPetListItemResponse>>> GetActiveAsync(
        string? city,
        string? region,
        decimal? latitude,
        decimal? longitude,
        decimal? radiusKm,
        CancellationToken cancellationToken = default)
    {
        var query = _dbContext.LostPets
            .AsNoTracking()
            .Include(x => x.Pet)
                .ThenInclude(x => x.Species)
            .Where(x => !x.IsDeleted && x.Status == LostPetStatus.Active);

        if (!string.IsNullOrWhiteSpace(city))
        {
            var term = city.Trim().ToLower();
            query = query.Where(x => x.LastSeenAddress != null && x.LastSeenAddress.ToLower().Contains(term));
        }

        if (!string.IsNullOrWhiteSpace(region))
        {
            var term = region.Trim().ToLower();
            query = query.Where(x => x.LastSeenAddress != null && x.LastSeenAddress.ToLower().Contains(term));
        }

        if (latitude.HasValue && longitude.HasValue && radiusKm.HasValue && radiusKm.Value > 0)
        {
            var latDelta = radiusKm.Value / 111m;
            var lonDelta = radiusKm.Value / 111m;

            var minLat = latitude.Value - latDelta;
            var maxLat = latitude.Value + latDelta;
            var minLon = longitude.Value - lonDelta;
            var maxLon = longitude.Value + lonDelta;

            query = query.Where(x =>
                x.LastSeenLatitude.HasValue &&
                x.LastSeenLongitude.HasValue &&
                x.LastSeenLatitude.Value >= minLat &&
                x.LastSeenLatitude.Value <= maxLat &&
                x.LastSeenLongitude.Value >= minLon &&
                x.LastSeenLongitude.Value <= maxLon);
        }

        var items = await query
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new LostPetListItemResponse
            {
                Id = x.Id,
                PetId = x.PetId,
                PetName = x.Pet.Name,
                PetPhotoUrl = x.Pet.PhotoUrl,
                SpeciesName = x.Pet.Species != null ? x.Pet.Species.Name : string.Empty,
                Title = x.Title,
                LastSeenAddress = x.LastSeenAddress,
                LastSeenLatitude = x.LastSeenLatitude,
                LastSeenLongitude = x.LastSeenLongitude,
                LostDate = x.LostDate,
                Status = x.Status.ToString()
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<LostPetListItemResponse>>.Success(items);
    }

    public async Task<Result<LostPetDetailResponse>> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var lostPet = await _dbContext.LostPets
            .AsNoTracking()
            .Include(x => x.Pet)
                .ThenInclude(x => x.Species)
            .Include(x => x.Pet)
                .ThenInclude(x => x.Breed)
            .Include(x => x.Photos)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

        if (lostPet is null)
            return Result<LostPetDetailResponse>.Failure("Reporte no encontrado.");

        return Result<LostPetDetailResponse>.Success(ToDetail(lostPet));
    }

    public async Task<Result<LostPetDetailResponse>> CreateAsync(
        Guid userId,
        Guid petId,
        CreateLostPetRequest request,
        CancellationToken cancellationToken = default)
    {
        var pet = await _dbContext.Pets
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .FirstOrDefaultAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (pet is null)
            return Result<LostPetDetailResponse>.Failure("Mascota no encontrada.");

        if (string.IsNullOrWhiteSpace(request.Title))
            return Result<LostPetDetailResponse>.Failure("El tÃ­tulo es requerido.");

        if (string.IsNullOrWhiteSpace(request.Description))
            return Result<LostPetDetailResponse>.Failure("La descripciÃ³n es requerida.");

        var activeExists = await _dbContext.LostPets
            .AnyAsync(x => x.PetId == petId && x.Status == LostPetStatus.Active && !x.IsDeleted, cancellationToken);

        if (activeExists)
            return Result<LostPetDetailResponse>.Failure("Esta mascota ya tiene un reporte activo.");

        var lostPet = new LostPet
        {
            Id = Guid.NewGuid(),
            PetId = petId,
            UserId = userId,
            Title = request.Title.Trim(),
            Description = request.Description.Trim(),
            LastSeenAddress = Clean(request.LastSeenAddress),
            LastSeenLatitude = request.LastSeenLatitude,
            LastSeenLongitude = request.LastSeenLongitude,
            LostDate = request.LostDate,
            Status = LostPetStatus.Active,
            ContactPhone = Clean(request.ContactPhone),
            RewardAmount = request.RewardAmount,
            CreatedAt = DateTimeOffset.UtcNow
        };

        pet.Status = PetStatus.Lost;
        pet.UpdatedAt = DateTimeOffset.UtcNow;

        _dbContext.LostPets.Add(lostPet);
        await _dbContext.SaveChangesAsync(cancellationToken);

        lostPet.Pet = pet;
        lostPet.Photos = new List<LostPetPhoto>();

        return Result<LostPetDetailResponse>.Success(ToDetail(lostPet));
    }

    public async Task<Result<LostPetPhotoResponse>> AddPhotoAsync(
        Guid userId,
        Guid lostPetId,
        AddLostPetPhotoRequest request,
        CancellationToken cancellationToken = default)
    {
        var lostPetExists = await _dbContext.LostPets
            .AnyAsync(x => x.Id == lostPetId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (!lostPetExists)
            return Result<LostPetPhotoResponse>.Failure("Reporte no encontrado.");

        if (string.IsNullOrWhiteSpace(request.PhotoUrl))
            return Result<LostPetPhotoResponse>.Failure("La URL de la foto es requerida.");

        var photo = new LostPetPhoto
        {
            Id = Guid.NewGuid(),
            LostPetId = lostPetId,
            PhotoUrl = request.PhotoUrl.Trim(),
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.LostPetPhotos.Add(photo);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<LostPetPhotoResponse>.Success(new LostPetPhotoResponse
        {
            Id = photo.Id,
            PhotoUrl = photo.PhotoUrl,
            CreatedAt = photo.CreatedAt
        });
    }

    public async Task<Result> DeletePhotoAsync(
        Guid userId,
        Guid lostPetId,
        Guid photoId,
        CancellationToken cancellationToken = default)
    {
        var ownsReport = await _dbContext.LostPets
            .AnyAsync(x => x.Id == lostPetId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (!ownsReport)
            return Result.Failure("Reporte no encontrado.");

        var photo = await _dbContext.LostPetPhotos
            .FirstOrDefaultAsync(x => x.Id == photoId && x.LostPetId == lostPetId && !x.IsDeleted, cancellationToken);

        if (photo is null)
            return Result.Failure("Foto no encontrada.");

        photo.IsDeleted = true;
        photo.DeletedAt = DateTimeOffset.UtcNow;
        photo.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }

    public async Task<Result> MarkAsFoundAsync(Guid userId, Guid id, CancellationToken cancellationToken = default)
    {
        var lostPet = await _dbContext.LostPets
            .Include(x => x.Pet)
            .FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (lostPet is null)
            return Result.Failure("Reporte no encontrado.");

        lostPet.Status = LostPetStatus.Found;
        lostPet.UpdatedAt = DateTimeOffset.UtcNow;

        lostPet.Pet.Status = PetStatus.Active;
        lostPet.Pet.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> CloseAsync(Guid userId, Guid id, CancellationToken cancellationToken = default)
    {
        var lostPet = await _dbContext.LostPets
            .Include(x => x.Pet)
            .FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (lostPet is null)
            return Result.Failure("Reporte no encontrado.");

        lostPet.Status = LostPetStatus.Closed;
        lostPet.UpdatedAt = DateTimeOffset.UtcNow;

        if (lostPet.Pet.Status == PetStatus.Lost)
        {
            lostPet.Pet.Status = PetStatus.Active;
            lostPet.Pet.UpdatedAt = DateTimeOffset.UtcNow;
        }

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private static LostPetDetailResponse ToDetail(LostPet lostPet)
    {
        return new LostPetDetailResponse
        {
            Id = lostPet.Id,
            PetId = lostPet.PetId,
            PetName = lostPet.Pet.Name,
            PetPhotoUrl = lostPet.Pet.PhotoUrl,
            SpeciesName = lostPet.Pet.Species?.Name ?? string.Empty,
            BreedName = lostPet.Pet.Breed?.Name,
            Color = lostPet.Pet.Color,
            Title = lostPet.Title,
            Description = lostPet.Description,
            LastSeenAddress = lostPet.LastSeenAddress,
            LastSeenLatitude = lostPet.LastSeenLatitude,
            LastSeenLongitude = lostPet.LastSeenLongitude,
            LostDate = lostPet.LostDate,
            Status = lostPet.Status.ToString(),
            ContactPhone = lostPet.ContactPhone,
            RewardAmount = lostPet.RewardAmount,
            Photos = lostPet.Photos
                .Where(x => !x.IsDeleted)
                .OrderBy(x => x.CreatedAt)
                .Select(x => new LostPetPhotoResponse
                {
                    Id = x.Id,
                    PhotoUrl = x.PhotoUrl,
                    CreatedAt = x.CreatedAt
                })
                .ToList(),
            CreatedAt = lostPet.CreatedAt
        };
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}


