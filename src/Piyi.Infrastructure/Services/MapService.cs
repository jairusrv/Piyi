using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Maps;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class MapService : IMapService
{
    private readonly PiyiDbContext _db;

    public MapService(PiyiDbContext db)
    {
        _db = db;
    }

    public async Task<IReadOnlyList<LostPetMapMarkerDto>> GetLostPetsAsync(CancellationToken cancellationToken = default)
    {
        return await _db.LostPets
            .AsNoTracking()
            .Where(x => !x.IsDeleted && x.Status == LostPetStatus.Active && x.LastSeenLatitude != null && x.LastSeenLongitude != null)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new LostPetMapMarkerDto(
                x.Id,
                x.Pet.Name,
                x.Title,
                x.LastSeenLatitude,
                x.LastSeenLongitude,
                x.Pet.PhotoUrl,
                x.RewardAmount,
                x.LastSeenAddress))
            .ToListAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<BusinessMapMarkerDto>> GetBusinessesAsync(CancellationToken cancellationToken = default)
    {
        return await _db.Businesses
            .AsNoTracking()
            .Where(x => !x.IsDeleted && x.IsActive && x.Latitude != null && x.Longitude != null)
            .OrderByDescending(x => x.IsVerified)
            .ThenBy(x => x.Name)
            .Select(x => new BusinessMapMarkerDto(
                x.Id,
                x.Name,
                x.BusinessType == null ? null : x.BusinessType.Name,
                x.Latitude,
                x.Longitude,
                x.LogoUrl,
                x.IsVerified,
                x.Address))
            .ToListAsync(cancellationToken);
    }
}
