using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Pets;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class PetService : IPetService
{
    private readonly PiyiDbContext _dbContext;

    public PetService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<PetResponse>>> GetMyPetsAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        var pets = await _dbContext.Pets
            .AsNoTracking()
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .Where(x => x.UserId == userId && !x.IsDeleted)
            .OrderBy(x => x.Name)
            .Select(x => ToResponse(x))
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<PetResponse>>.Success(pets);
    }

    public async Task<Result<PetResponse>> GetPetByIdAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var pet = await _dbContext.Pets
            .AsNoTracking()
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .FirstOrDefaultAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (pet is null)
            return Result<PetResponse>.Failure("Mascota no encontrada.");

        return Result<PetResponse>.Success(ToResponse(pet));
    }

    public async Task<Result<PetResponse>> CreatePetAsync(
        Guid userId,
        CreatePetRequest request,
        CancellationToken cancellationToken = default)
    {
        var validation = await ValidateCatalogsAsync(request.SpeciesId, request.BreedId, cancellationToken);
        if (validation.IsFailure)
            return Result<PetResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<PetResponse>.Failure("El nombre de la mascota es requerido.");

        var pet = new Pet
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Name = request.Name.Trim(),
            SpeciesId = request.SpeciesId,
            BreedId = request.BreedId,
            Color = Clean(request.Color),
            BirthDate = request.BirthDate,
            Sex = ParsePetSex(request.Sex),
            WeightKg = request.WeightKg,
            IsSterilized = request.IsSterilized,
            MicrochipNumber = Clean(request.MicrochipNumber),
            PhotoUrl = Clean(request.PhotoUrl),
            Status = PetStatus.Active,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.Pets.Add(pet);
        await _dbContext.SaveChangesAsync(cancellationToken);

        var created = await _dbContext.Pets
            .AsNoTracking()
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .FirstAsync(x => x.Id == pet.Id, cancellationToken);

        return Result<PetResponse>.Success(ToResponse(created));
    }

    public async Task<Result<PetResponse>> UpdatePetAsync(
        Guid userId,
        Guid petId,
        UpdatePetRequest request,
        CancellationToken cancellationToken = default)
    {
        var pet = await _dbContext.Pets
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .FirstOrDefaultAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (pet is null)
            return Result<PetResponse>.Failure("Mascota no encontrada.");

        var validation = await ValidateCatalogsAsync(request.SpeciesId, request.BreedId, cancellationToken);
        if (validation.IsFailure)
            return Result<PetResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<PetResponse>.Failure("El nombre de la mascota es requerido.");

        pet.Name = request.Name.Trim();
        pet.SpeciesId = request.SpeciesId;
        pet.BreedId = request.BreedId;
        pet.Color = Clean(request.Color);
        pet.BirthDate = request.BirthDate;
        pet.Sex = ParsePetSex(request.Sex);
        pet.WeightKg = request.WeightKg;
        pet.IsSterilized = request.IsSterilized;
        pet.MicrochipNumber = Clean(request.MicrochipNumber);
        pet.PhotoUrl = Clean(request.PhotoUrl);
        pet.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        var updated = await _dbContext.Pets
            .AsNoTracking()
            .Include(x => x.Species)
            .Include(x => x.Breed)
            .FirstAsync(x => x.Id == pet.Id, cancellationToken);

        return Result<PetResponse>.Success(ToResponse(updated));
    }

    public async Task<Result> DeletePetAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var pet = await _dbContext.Pets
            .FirstOrDefaultAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (pet is null)
            return Result.Failure("Mascota no encontrada.");

        pet.IsDeleted = true;
        pet.DeletedAt = DateTimeOffset.UtcNow;
        pet.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }

    private async Task<Result> ValidateCatalogsAsync(Guid speciesId, Guid? breedId, CancellationToken cancellationToken)
    {
        var speciesExists = await _dbContext.Species
            .AnyAsync(x => x.Id == speciesId && !x.IsDeleted, cancellationToken);

        if (!speciesExists)
            return Result.Failure("La especie seleccionada no existe.");

        if (breedId.HasValue)
        {
            var breedExists = await _dbContext.Breeds
                .AnyAsync(x => x.Id == breedId.Value && x.SpeciesId == speciesId && !x.IsDeleted, cancellationToken);

            if (!breedExists)
                return Result.Failure("La raza seleccionada no existe para esa especie.");
        }

        return Result.Success();
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static PetSex ParsePetSex(string? value)
    {
        if (Enum.TryParse<PetSex>(value, ignoreCase: true, out var sex))
            return sex;

        return PetSex.Unknown;
    }

    private static PetResponse ToResponse(Pet pet)
    {
        return new PetResponse
        {
            Id = pet.Id,
            Name = pet.Name,
            SpeciesId = pet.SpeciesId,
            SpeciesName = pet.Species?.Name ?? string.Empty,
            BreedId = pet.BreedId,
            BreedName = pet.Breed?.Name,
            Color = pet.Color,
            BirthDate = pet.BirthDate,
            Sex = pet.Sex.ToString(),
            WeightKg = pet.WeightKg,
            IsSterilized = pet.IsSterilized,
            MicrochipNumber = pet.MicrochipNumber,
            PhotoUrl = pet.PhotoUrl,
            Status = pet.Status.ToString(),
            CreatedAt = pet.CreatedAt
        };
    }
}
