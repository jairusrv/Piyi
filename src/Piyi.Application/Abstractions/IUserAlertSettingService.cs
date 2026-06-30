using Piyi.Application.Common;
using Piyi.Contracts.Alerts;

namespace Piyi.Application.Abstractions;

public interface IUserAlertSettingService
{
    Task<Result<UserAlertSettingResponse>> GetOrCreateAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<Result<UserAlertSettingResponse>> UpdateAsync(Guid userId, UpdateUserAlertSettingRequest request, CancellationToken cancellationToken = default);
}
