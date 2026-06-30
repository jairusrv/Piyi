namespace Piyi.Contracts.Users;

public sealed class UpdateUserProfileRequest
{
    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public string? PhotoUrl { get; set; }

    public string? Language { get; set; }

    public string? Country { get; set; }

    public string? TimeZone { get; set; }
}
