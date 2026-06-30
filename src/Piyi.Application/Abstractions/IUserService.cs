using Piyi.Application.Common;
using Piyi.Contracts.Users;

namespace Piyi.Application.Abstractions;

public interface IUserService
{
    Task<Result<UserProfileResponse>> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<Result<UserProfileResponse>> UpdateCurrentUserAsync(
        Guid userId,
        UpdateUserProfileRequest request,
        CancellationToken cancellationToken = default);

    Task<Result> ChangePasswordAsync(
        Guid userId,
        ChangePasswordRequest request,
        CancellationToken cancellationToken = default);
}
