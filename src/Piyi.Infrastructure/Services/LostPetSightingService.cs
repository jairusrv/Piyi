using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.LostPets;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class LostPetSightingService : ILostPetSightingService
{
    private readonly PiyiDbContext _dbContext;

    public LostPetSightingService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<LostPetSightingResponse>> CreateAsync(
        Guid? userId,
        Guid lostPetId,
        CreateLostPetSightingRequest request,
        CancellationToken cancellationToken = default)
    {
        var lostPetExists = await _dbContext.LostPets
            .AnyAsync(x => x.Id == lostPetId && !x.IsDeleted && x.Status == LostPetStatus.Active, cancellationToken);

        if (!lostPetExists)
            return Result<LostPetSightingResponse>.Failure("Reporte no encontrado o no está activo.");

        if (request.Latitude == 0 || request.Longitude == 0)
            return Result<LostPetSightingResponse>.Failure("Debe indicar una ubicación válida.");

        var sighting = new LostPetSighting
        {
            Id = Guid.NewGuid(),
            LostPetId = lostPetId,
            UserId = userId,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            Address = Clean(request.Address),
            Observation = Clean(request.Observation),
            PhotoUrl = Clean(request.PhotoUrl),
            Status = LostPetSightingStatus.Pending,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.LostPetSightings.Add(sighting);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<LostPetSightingResponse>.Success(ToResponse(sighting));
    }

    public async Task<Result<IReadOnlyList<LostPetSightingResponse>>> GetByLostPetAsync(
        Guid lostPetId,
        CancellationToken cancellationToken = default)
    {
        var exists = await _dbContext.LostPets
            .AnyAsync(x => x.Id == lostPetId && !x.IsDeleted, cancellationToken);

        if (!exists)
            return Result<IReadOnlyList<LostPetSightingResponse>>.Failure("Reporte no encontrado.");

        var sightings = await _dbContext.LostPetSightings
            .AsNoTracking()
            .Where(x => x.LostPetId == lostPetId && !x.IsDeleted)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => ToResponse(x))
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<LostPetSightingResponse>>.Success(sightings);
    }

    public async Task<Result> ConfirmAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default)
    {
        var sighting = await GetOwnedSightingAsync(userId, lostPetId, sightingId, cancellationToken);
        if (sighting is null)
            return Result.Failure("Avistamiento no encontrado.");

        sighting.Status = LostPetSightingStatus.Confirmed;
        sighting.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> DiscardAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default)
    {
        var sighting = await GetOwnedSightingAsync(userId, lostPetId, sightingId, cancellationToken);
        if (sighting is null)
            return Result.Failure("Avistamiento no encontrado.");

        sighting.Status = LostPetSightingStatus.Discarded;
        sighting.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> DeleteAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default)
    {
        var sighting = await GetOwnedSightingAsync(userId, lostPetId, sightingId, cancellationToken);
        if (sighting is null)
            return Result.Failure("Avistamiento no encontrado.");

        sighting.IsDeleted = true;
        sighting.DeletedAt = DateTimeOffset.UtcNow;
        sighting.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private async Task<LostPetSighting?> GetOwnedSightingAsync(
        Guid userId,
        Guid lostPetId,
        Guid sightingId,
        CancellationToken cancellationToken)
    {
        var ownsReport = await _dbContext.LostPets
            .AnyAsync(x => x.Id == lostPetId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (!ownsReport)
            return null;

        return await _dbContext.LostPetSightings
            .FirstOrDefaultAsync(x => x.Id == sightingId && x.LostPetId == lostPetId && !x.IsDeleted, cancellationToken);
    }

    private static LostPetSightingResponse ToResponse(LostPetSighting sighting)
    {
        return new LostPetSightingResponse
        {
            Id = sighting.Id,
            LostPetId = sighting.LostPetId,
            UserId = sighting.UserId,
            Latitude = sighting.Latitude,
            Longitude = sighting.Longitude,
            Address = sighting.Address,
            Observation = sighting.Observation,
            PhotoUrl = sighting.PhotoUrl,
            Status = sighting.Status.ToString(),
            CreatedAt = sighting.CreatedAt
        };
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}
