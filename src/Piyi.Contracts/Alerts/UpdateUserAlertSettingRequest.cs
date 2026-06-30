namespace Piyi.Contracts.Alerts;

public sealed class UpdateUserAlertSettingRequest
{
    public bool LostPetAlertsEnabled { get; set; } = true;

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal RadiusKm { get; set; } = 10;

    public string? Country { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }
}
