namespace Piyi.Contracts.Pets;

public sealed class PetResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public Guid SpeciesId { get; set; }

    public string SpeciesName { get; set; } = string.Empty;

    public Guid? BreedId { get; set; }

    public string? BreedName { get; set; }

    public string? Color { get; set; }

    public DateOnly? BirthDate { get; set; }

    public string Sex { get; set; } = string.Empty;

    public decimal? WeightKg { get; set; }

    public bool IsSterilized { get; set; }

    public string? MicrochipNumber { get; set; }

    public string? PhotoUrl { get; set; }

    public string Status { get; set; } = string.Empty;

    public DateTimeOffset CreatedAt { get; set; }
}
