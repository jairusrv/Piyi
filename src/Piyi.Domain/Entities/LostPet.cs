using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public class LostPet : BaseEntity
{
    public Guid PetId { get; set; }
    public Guid UserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? LastSeenAddress { get; set; }
    public decimal? LastSeenLatitude { get; set; }
    public decimal? LastSeenLongitude { get; set; }
    public DateTimeOffset LostDate { get; set; }
    public LostPetStatus Status { get; set; } = LostPetStatus.Active;
    public string? ContactPhone { get; set; }
    public decimal? RewardAmount { get; set; }

    public Pet Pet { get; set; } = null!;
    public User User { get; set; } = null!;
    public ICollection<LostPetPhoto> Photos { get; set; } = new List<LostPetPhoto>();
}
