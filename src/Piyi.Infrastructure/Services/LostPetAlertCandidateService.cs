using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Alerts;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class LostPetAlertCandidateService : ILostPetAlertCandidateService
{
    private readonly PiyiDbContext _dbContext;

    public LostPetAlertCandidateService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<AlertCandidateResponse>>> GetCandidatesAsync(
        Guid lostPetId,
        CancellationToken cancellationToken = default)
    {
        var lostPet = await _dbContext.LostPets
            .AsNoTracking()
            .FirstOrDefaultAsync(x =>
                x.Id == lostPetId &&
                !x.IsDeleted &&
                x.Status == LostPetStatus.Active,
                cancellationToken);

        if (lostPet is null)
            return Result<IReadOnlyList<AlertCandidateResponse>>.Failure("Reporte no encontrado o no está activo.");

        if (!lostPet.LastSeenLatitude.HasValue || !lostPet.LastSeenLongitude.HasValue)
            return Result<IReadOnlyList<AlertCandidateResponse>>.Success(Array.Empty<AlertCandidateResponse>());

        var lat = lostPet.LastSeenLatitude.Value;
        var lon = lostPet.LastSeenLongitude.Value;

        var settings = await _dbContext.UserAlertSettings
            .AsNoTracking()
            .Include(x => x.User)
            .Where(x =>
                !x.IsDeleted &&
                x.LostPetAlertsEnabled &&
                x.Latitude.HasValue &&
                x.Longitude.HasValue &&
                !x.User.IsDeleted &&
                x.User.IsActive)
            .ToListAsync(cancellationToken);

        var candidates = settings
            .Select(x =>
            {
                var distance = CalculateApproxDistanceKm(lat, lon, x.Latitude!.Value, x.Longitude!.Value);

                return new
                {
                    Setting = x,
                    Distance = distance
                };
            })
            .Where(x => x.Distance <= x.Setting.RadiusKm)
            .OrderBy(x => x.Distance)
            .Select(x => new AlertCandidateResponse
            {
                UserId = x.Setting.UserId,
                Email = x.Setting.User.Email,
                FirstName = x.Setting.User.FirstName,
                Latitude = x.Setting.Latitude,
                Longitude = x.Setting.Longitude,
                RadiusKm = x.Setting.RadiusKm,
                City = x.Setting.City,
                Region = x.Setting.Region,
                ApproxDistanceKm = Math.Round(x.Distance, 2)
            })
            .ToList();

        return Result<IReadOnlyList<AlertCandidateResponse>>.Success(candidates);
    }

    private static decimal CalculateApproxDistanceKm(decimal lat1, decimal lon1, decimal lat2, decimal lon2)
    {
        const double earthRadiusKm = 6371;

        var dLat = ToRadians((double)(lat2 - lat1));
        var dLon = ToRadians((double)(lon2 - lon1));

        var a =
            Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
            Math.Cos(ToRadians((double)lat1)) *
            Math.Cos(ToRadians((double)lat2)) *
            Math.Sin(dLon / 2) *
            Math.Sin(dLon / 2);

        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

        return (decimal)(earthRadiusKm * c);
    }

    private static double ToRadians(double degrees) => degrees * Math.PI / 180;
}
