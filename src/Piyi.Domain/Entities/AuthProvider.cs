using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public class AuthProvider : BaseEntity
{
    public Guid UserId { get; set; }
    public AuthProviderType ProviderType { get; set; } = AuthProviderType.Email;
    public string ProviderUserId { get; set; } = string.Empty;
    public User User { get; set; } = null!;
}
