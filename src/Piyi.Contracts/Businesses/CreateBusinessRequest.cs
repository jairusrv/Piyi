namespace Piyi.Contracts.Businesses;

public sealed class CreateBusinessRequest
{
    public Guid BusinessTypeId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string? Description { get; set; }

    public string? Phone { get; set; }

    public string? WhatsApp { get; set; }

    public string? Email { get; set; }

    public string? Website { get; set; }

    public string? FacebookUrl { get; set; }

    public string? InstagramUrl { get; set; }

    public string? TikTokUrl { get; set; }

    public string? Address { get; set; }

    public string? Country { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? LogoUrl { get; set; }
}
