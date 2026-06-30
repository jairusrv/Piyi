using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class LostPetSighting : BaseEntity
{
    public Guid LostPetId { get; set; }

    public Guid? UserId { get; set; }

    public decimal Latitude { get; set; }

    public decimal Longitude { get; set; }

    public string? Address { get; set; }

    public string? Observation { get; set; }

    public string? PhotoUrl { get; set; }

    public LostPetSightingStatus Status { get; set; } = LostPetSightingStatus.Pending;

    public LostPet LostPet { get; set; } = default!;

    public User? User { get; set; }
}
