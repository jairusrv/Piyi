using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class BusinessService : BaseEntity
{
    public Guid BusinessId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal? PriceFrom { get; set; }
    public decimal? PriceTo { get; set; }
    public bool IsActive { get; set; } = true;

    public Business Business { get; set; } = null!;
}
