using Piyi.Application.Common;
using Piyi.Contracts.Devices;

namespace Piyi.Application.Abstractions;

public interface IUserDeviceService
{
    Task<Result<IReadOnlyList<UserDeviceResponse>>> GetMyDevicesAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<Result<UserDeviceResponse>> RegisterOrUpdateAsync(Guid userId, RegisterDeviceRequest request, CancellationToken cancellationToken = default);

    Task<Result<UserDeviceResponse>> UpdateAsync(Guid userId, Guid deviceId, UpdateDeviceRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeactivateAsync(Guid userId, Guid deviceId, CancellationToken cancellationToken = default);
}
