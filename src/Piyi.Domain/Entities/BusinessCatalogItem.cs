using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class BusinessCatalogItem
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid BusinessId { get; set; }
    public Business Business { get; set; } = null!;

    public BusinessCatalogItemType Type { get; set; } = BusinessCatalogItemType.Product;

    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }

    public string? Category { get; set; }
    public string? Brand { get; set; }
    public string? Barcode { get; set; }
    public string? Sku { get; set; }

    public decimal? ReferencePrice { get; set; }
    public string Currency { get; set; } = "CRC";

    public string? PhotoUrl { get; set; }

    public bool IsAvailable { get; set; } = true;
    public bool IsFeatured { get; set; } = false;

    public string? PetSpecies { get; set; }
    public string? BreedTarget { get; set; }
    public string? AgeTarget { get; set; }
    public string? WeightTarget { get; set; }

    public string? Tags { get; set; }

    public string? Notes { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? UpdatedAt { get; set; }

    public bool IsDeleted { get; set; } = false;
}
