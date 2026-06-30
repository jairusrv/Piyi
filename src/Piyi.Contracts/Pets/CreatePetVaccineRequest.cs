namespace Piyi.Contracts.Pets;

public sealed class CreatePetVaccineRequest
{
    public string Name { get; set; } = string.Empty;

    public DateOnly? AppliedDate { get; set; }

    public DateOnly? NextDueDate { get; set; }

    public string? Notes { get; set; }
}
