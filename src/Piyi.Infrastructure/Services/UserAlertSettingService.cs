using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Alerts;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class UserAlertSettingService : IUserAlertSettingService
{
    private readonly PiyiDbContext _dbContext;

    public UserAlertSettingService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<UserAlertSettingResponse>> GetOrCreateAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var setting = await _dbContext.UserAlertSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (setting is not null)
            return Result<UserAlertSettingResponse>.Success(ToResponse(setting));

        var created = new UserAlertSetting
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            LostPetAlertsEnabled = true,
            RadiusKm = 10,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.UserAlertSettings.Add(created);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<UserAlertSettingResponse>.Success(ToResponse(created));
    }

    public async Task<Result<UserAlertSettingResponse>> UpdateAsync(
        Guid userId,
        UpdateUserAlertSettingRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.RadiusKm <= 0 || request.RadiusKm > 100)
            return Result<UserAlertSettingResponse>.Failure("El radio debe estar entre 1 y 100 km.");

        var setting = await _dbContext.UserAlertSettings
            .FirstOrDefaultAsync(x => x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (setting is null)
        {
            setting = new UserAlertSetting
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                CreatedAt = DateTimeOffset.UtcNow
            };
            _dbContext.UserAlertSettings.Add(setting);
        }

        setting.LostPetAlertsEnabled = request.LostPetAlertsEnabled;
        setting.Latitude = request.Latitude;
        setting.Longitude = request.Longitude;
        setting.RadiusKm = request.RadiusKm;
        setting.Country = Clean(request.Country);
        setting.Region = Clean(request.Region);
        setting.City = Clean(request.City);
        setting.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<UserAlertSettingResponse>.Success(ToResponse(setting));
    }

    private static UserAlertSettingResponse ToResponse(UserAlertSetting setting)
    {
        return new UserAlertSettingResponse
        {
            Id = setting.Id,
            LostPetAlertsEnabled = setting.LostPetAlertsEnabled,
            Latitude = setting.Latitude,
            Longitude = setting.Longitude,
            RadiusKm = setting.RadiusKm,
            Country = setting.Country,
            Region = setting.Region,
            City = setting.City
        };
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}
