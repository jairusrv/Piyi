using Piyi.Contracts.Auth;
using Piyi.Application.Common;

namespace Piyi.Application.Abstractions;

public interface IAuthService
{
    Task<Result<AuthResponse>> RegisterAsync(RegisterRequest request, CancellationToken cancellationToken = default);
    Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);
}
