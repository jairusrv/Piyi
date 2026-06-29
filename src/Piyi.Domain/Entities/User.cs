using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class User : BaseEntity
{
    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public string PasswordHash { get; set; } = string.Empty;

    public string? PhotoUrl { get; set; }

    public string? Language { get; set; }

    public string? Country { get; set; }

    public string? TimeZone { get; set; }

    public UserRole Role { get; set; } = UserRole.User;

    public bool IsActive { get; set; } = true;

    public bool EmailVerified { get; set; }

    public bool PhoneVerified { get; set; }

    public DateTimeOffset? LastLoginAt { get; set; }

    public ICollection<AuthProvider> AuthProviders { get; set; } = new List<AuthProvider>();

    public ICollection<Pet> Pets { get; set; } = new List<Pet>();

    public ICollection<Business> Businesses { get; set; } = new List<Business>();

    public ICollection<Review> Reviews { get; set; } = new List<Review>();

    public ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
}
