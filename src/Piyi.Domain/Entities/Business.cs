using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class Business : BaseEntity
{
    public Guid? OwnerUserId { get; set; }

    public Guid? BusinessTypeId { get; set; }

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

    public bool IsVerified { get; set; }

    public bool IsActive { get; set; } = true;

    public BusinessStatus Status { get; set; } = BusinessStatus.Active;

    public User? OwnerUser { get; set; }

    public BusinessType? BusinessType { get; set; }

    public ICollection<BusinessPhoto> Photos { get; set; } = new List<BusinessPhoto>();

    public ICollection<BusinessService> Services { get; set; } = new List<BusinessService>();

    public ICollection<BusinessSchedule> Schedules { get; set; } = new List<BusinessSchedule>();

    public ICollection<Review> Reviews { get; set; } = new List<Review>();
}
