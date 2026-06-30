namespace Piyi.Contracts.Alerts;

public sealed class AlertCandidateResponse
{
    public Guid UserId { get; set; }

    public string Email { get; set; } = string.Empty;

    public string? FirstName { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal RadiusKm { get; set; }

    public string? City { get; set; }

    public string? Region { get; set; }

    public decimal? ApproxDistanceKm { get; set; }
}
