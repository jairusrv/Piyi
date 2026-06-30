namespace Piyi.Contracts.Pets;

public sealed class CreatePetRequest
{
    public string Name { get; set; } = string.Empty;

    public Guid SpeciesId { get; set; }

    public Guid? BreedId { get; set; }

    public string? Color { get; set; }

    public DateOnly? BirthDate { get; set; }

    public string Sex { get; set; } = "Unknown";

    public decimal? WeightKg { get; set; }

    public bool IsSterilized { get; set; }

    public string? MicrochipNumber { get; set; }

    public string? PhotoUrl { get; set; }
}
