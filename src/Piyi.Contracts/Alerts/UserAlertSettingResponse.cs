namespace Piyi.Contracts.Alerts;

public sealed class UserAlertSettingResponse
{
    public Guid Id { get; set; }

    public bool LostPetAlertsEnabled { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal RadiusKm { get; set; }

    public string? Country { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }
}
