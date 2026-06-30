namespace Piyi.Contracts.Businesses;

public sealed class BusinessListItemResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public Guid? BusinessTypeId { get; set; }

    public string? BusinessTypeName { get; set; }

    public string? Description { get; set; }

    public string? Phone { get; set; }

    public string? WhatsApp { get; set; }

    public string? Address { get; set; }

    public string? City { get; set; }

    public string? Region { get; set; }

    public string? Country { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? LogoUrl { get; set; }

    public bool IsVerified { get; set; }
}
