namespace Piyi.Domain.Entities;

public sealed class BusinessProfile
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid BusinessId { get; set; }
    public Business Business { get; set; } = null!;

    public string? BannerUrl { get; set; }
    public string? ShortDescription { get; set; }
    public string? LongDescription { get; set; }

    public string? Story { get; set; }
    public string? Mission { get; set; }
    public string? Specialties { get; set; }
    public string? Languages { get; set; }

    public bool AcceptsSinpe { get; set; } = false;
    public bool AcceptsCard { get; set; } = false;
    public bool HasParking { get; set; } = false;
    public bool IsAccessible { get; set; } = false;
    public bool HasEmergency24h { get; set; } = false;
    public bool HasHomeService { get; set; } = false;
    public bool HasOwnDelivery { get; set; } = false;

    public string? WebsiteUrl { get; set; }
    public string? FacebookUrl { get; set; }
    public string? InstagramUrl { get; set; }
    public string? TikTokUrl { get; set; }
    public string? YouTubeUrl { get; set; }

    public string? GalleryJson { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? UpdatedAt { get; set; }

    public bool IsDeleted { get; set; } = false;
}
