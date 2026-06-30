using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Devices;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class UserDeviceService : IUserDeviceService
{
    private readonly PiyiDbContext _dbContext;

    public UserDeviceService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<UserDeviceResponse>>> GetMyDevicesAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        var devices = await _dbContext.UserDevices
            .AsNoTracking()
            .Where(x => x.UserId == userId && !x.IsDeleted)
            .OrderByDescending(x => x.LastSeenAt ?? x.CreatedAt)
            .Select(x => ToResponse(x))
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<UserDeviceResponse>>.Success(devices);
    }

    public async Task<Result<UserDeviceResponse>> RegisterOrUpdateAsync(
        Guid userId,
        RegisterDeviceRequest request,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(request.DeviceIdentifier))
            return Result<UserDeviceResponse>.Failure("DeviceIdentifier es requerido.");

        if (string.IsNullOrWhiteSpace(request.PushToken))
            return Result<UserDeviceResponse>.Failure("PushToken es requerido.");

        var deviceIdentifier = request.DeviceIdentifier.Trim();

        var device = await _dbContext.UserDevices
            .FirstOrDefaultAsync(x =>
                x.UserId == userId &&
                x.DeviceIdentifier == deviceIdentifier &&
                !x.IsDeleted,
                cancellationToken);

        if (device is null)
        {
            device = new UserDevice
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                DeviceIdentifier = deviceIdentifier,
                CreatedAt = DateTimeOffset.UtcNow
            };

            _dbContext.UserDevices.Add(device);
        }

        device.Platform = ParsePlatform(request.Platform);
        device.PushToken = request.PushToken.Trim();
        device.DeviceName = Clean(request.DeviceName);
        device.AppVersion = Clean(request.AppVersion);
        device.IsActive = true;
        device.LastSeenAt = DateTimeOffset.UtcNow;
        device.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<UserDeviceResponse>.Success(ToResponse(device));
    }

    public async Task<Result<UserDeviceResponse>> UpdateAsync(
        Guid userId,
        Guid deviceId,
        UpdateDeviceRequest request,
        CancellationToken cancellationToken = default)
    {
        var device = await _dbContext.UserDevices
            .FirstOrDefaultAsync(x => x.Id == deviceId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (device is null)
            return Result<UserDeviceResponse>.Failure("Dispositivo no encontrado.");

        if (string.IsNullOrWhiteSpace(request.PushToken))
            return Result<UserDeviceResponse>.Failure("PushToken es requerido.");

        device.PushToken = request.PushToken.Trim();
        device.DeviceName = Clean(request.DeviceName);
        device.AppVersion = Clean(request.AppVersion);
        device.IsActive = request.IsActive;
        device.LastSeenAt = DateTimeOffset.UtcNow;
        device.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<UserDeviceResponse>.Success(ToResponse(device));
    }

    public async Task<Result> DeactivateAsync(
        Guid userId,
        Guid deviceId,
        CancellationToken cancellationToken = default)
    {
        var device = await _dbContext.UserDevices
            .FirstOrDefaultAsync(x => x.Id == deviceId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (device is null)
            return Result.Failure("Dispositivo no encontrado.");

        device.IsActive = false;
        device.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }

    private static UserDeviceResponse ToResponse(UserDevice device)
    {
        return new UserDeviceResponse
        {
            Id = device.Id,
            DeviceIdentifier = device.DeviceIdentifier,
            Platform = device.Platform.ToString(),
            DeviceName = device.DeviceName,
            AppVersion = device.AppVersion,
            IsActive = device.IsActive,
            LastSeenAt = device.LastSeenAt,
            CreatedAt = device.CreatedAt
        };
    }

    private static DevicePlatform ParsePlatform(string? value)
    {
        return !string.IsNullOrWhiteSpace(value) &&
               Enum.TryParse<DevicePlatform>(value, true, out var platform)
            ? platform
            : DevicePlatform.Unknown;
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}
