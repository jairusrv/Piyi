namespace Piyi.Contracts.Auth;

public sealed class AuthResponse
{
    public string Token { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
    public UserAuthResponse User { get; set; } = new();
}

public sealed class UserAuthResponse
{
    public Guid Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string FullName => $"{FirstName} {LastName}".Trim();
    public string Email { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
}
