using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class LostPetPhoto : BaseEntity
{
    public Guid LostPetId { get; set; }
    public string PhotoUrl { get; set; } = string.Empty;

    public LostPet LostPet { get; set; } = null!;
}
