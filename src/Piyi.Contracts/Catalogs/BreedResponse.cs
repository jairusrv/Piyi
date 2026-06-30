namespace Piyi.Contracts.Catalogs;

public sealed class BreedResponse
{
    public Guid Id { get; set; }

    public Guid SpeciesId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string? Size { get; set; }

    public int SortOrder { get; set; }
}
