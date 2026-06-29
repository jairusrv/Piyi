using Piyi.Contracts.Users;
using Piyi.Application.Common;

namespace Piyi.Application.Abstractions;

public interface IUserService
{
    Task<Result<UserProfileResponse>> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default);
}
