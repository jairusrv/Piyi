using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Contracts.ZoneNotifications;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class ZoneNotificationService : IZoneNotificationService
{
    private readonly PiyiDbContext _db;

    public ZoneNotificationService(PiyiDbContext db)
    {
        _db = db;
    }

    public async Task<UserSafeZoneDto?> GetSafeZoneAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var zone = await _db.Set<UserSafeZone>()
            .AsNoTracking()
            .Where(x => x.UserId == userId && !x.IsDeleted && x.IsActive)
            .OrderByDescending(x => x.UpdatedAt ?? x.CreatedAt)
            .FirstOrDefaultAsync(cancellationToken);

        return zone is null ? null : ToDto(zone);
    }

    public async Task<UserSafeZoneDto> UpsertSafeZoneAsync(
        Guid userId,
        UpsertUserSafeZoneRequest request,
        CancellationToken cancellationToken = default)
    {
        var zone = await _db.Set<UserSafeZone>()
            .FirstOrDefaultAsync(x => x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (zone is null)
        {
            zone = new UserSafeZone { UserId = userId, CreatedAt = DateTimeOffset.UtcNow };
            _db.Set<UserSafeZone>().Add(zone);
        }

        zone.Name = string.IsNullOrWhiteSpace(request.Name) ? "Mi zona segura" : request.Name.Trim();
        zone.Latitude = request.Latitude;
        zone.Longitude = request.Longitude;
        zone.RadiusKm = request.RadiusKm <= 0 ? 5 : request.RadiusKm;
        zone.Address = Clean(request.Address);
        zone.District = Clean(request.District);
        zone.City = Clean(request.City);
        zone.Region = Clean(request.Region);
        zone.Country = Clean(request.Country);
        zone.IsActive = true;
        zone.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(zone);
    }

    public async Task<IReadOnlyList<NearbyLostPetAlertDto>> GetNearbyLostPetsAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        var zone = await _db.Set<UserSafeZone>()
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.UserId == userId && !x.IsDeleted && x.IsActive, cancellationToken);

        if (zone is null)
        {
            return Array.Empty<NearbyLostPetAlertDto>();
        }

        var lostPets = await _db.LostPets
            .AsNoTracking()
            .Include(x => x.Pet)
            .Where(x =>
                !x.IsDeleted &&
                x.Status == LostPetStatus.Active &&
                x.LastSeenLatitude != null &&
                x.LastSeenLongitude != null)
            .OrderByDescending(x => x.CreatedAt)
            .Take(200)
            .ToListAsync(cancellationToken);

        var result = new List<NearbyLostPetAlertDto>();

        foreach (var item in lostPets)
        {
            var distance = CalculateDistanceKm(
                (double)zone.Latitude,
                (double)zone.Longitude,
                (double)item.LastSeenLatitude!.Value,
                (double)item.LastSeenLongitude!.Value);

            if ((decimal)distance <= zone.RadiusKm)
            {
                result.Add(new NearbyLostPetAlertDto(
                    item.Id,
                    item.PetId,
                    item.Pet.Name,
                    item.Title,
                    item.Pet.PhotoUrl,
                    item.LastSeenAddress,
                    item.LastSeenLatitude,
                    item.LastSeenLongitude,
                    Math.Round((decimal)distance, 2),
                    item.RewardAmount));
            }
        }

        return result.OrderBy(x => x.DistanceKm).ToList();
    }

    private static UserSafeZoneDto ToDto(UserSafeZone zone)
    {
        return new UserSafeZoneDto(
            zone.Id,
            zone.UserId,
            zone.Name,
            zone.Latitude,
            zone.Longitude,
            zone.RadiusKm,
            zone.Address,
            zone.District,
            zone.City,
            zone.Region,
            zone.Country,
            zone.IsActive);
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static double CalculateDistanceKm(double lat1, double lon1, double lat2, double lon2)
    {
        const double radius = 6371;
        var dLat = ToRadians(lat2 - lat1);
        var dLon = ToRadians(lon2 - lon1);
        var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                Math.Cos(ToRadians(lat1)) * Math.Cos(ToRadians(lat2)) *
                Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        return radius * c;
    }

    private static double ToRadians(double degrees) => degrees * Math.PI / 180;
}
