using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class Breed : BaseEntity
{
    public Guid SpeciesId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Size { get; set; }
    public bool IsActive { get; set; } = true;

    public Species Species { get; set; } = null!;
    public ICollection<Pet> Pets { get; set; } = new List<Pet>();
}
