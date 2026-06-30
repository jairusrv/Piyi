using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public sealed class UserAlertSetting : BaseEntity
{
    public Guid UserId { get; set; }

    public bool LostPetAlertsEnabled { get; set; } = true;

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal RadiusKm { get; set; } = 10;

    public string? Country { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }

    public User User { get; set; } = default!;
}
