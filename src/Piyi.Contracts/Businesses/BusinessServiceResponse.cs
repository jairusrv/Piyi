namespace Piyi.Contracts.Businesses;

public sealed class BusinessServiceResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string? Description { get; set; }

    public decimal? PriceFrom { get; set; }

    public decimal? PriceTo { get; set; }

    public bool IsActive { get; set; }
}
