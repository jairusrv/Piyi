namespace Piyi.Contracts.Businesses;

public sealed class CreateBusinessServiceRequest
{
    public string Name { get; set; } = string.Empty;

    public string? Description { get; set; }

    public decimal? PriceFrom { get; set; }

    public decimal? PriceTo { get; set; }
}
