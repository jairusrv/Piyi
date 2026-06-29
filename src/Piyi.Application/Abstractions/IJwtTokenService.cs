using Piyi.Domain.Entities;

namespace Piyi.Application.Abstractions;

public interface IJwtTokenService
{
    string GenerateToken(User user, DateTime expiresAt);
}
