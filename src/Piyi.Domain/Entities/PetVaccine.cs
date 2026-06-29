using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class PetVaccine : BaseEntity
{
    public Guid PetId { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateOnly? AppliedDate { get; set; }
    public DateOnly? NextDueDate { get; set; }
    public string? Notes { get; set; }

    public Pet Pet { get; set; } = null!;
}
