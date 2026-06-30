namespace Piyi.Contracts.Pets;

public sealed class PetVaccineResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public string Name { get; set; } = string.Empty;

    public DateOnly? AppliedDate { get; set; }

    public DateOnly? NextDueDate { get; set; }

    public string? Notes { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
