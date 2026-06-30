namespace Piyi.Contracts.Catalogs;

public sealed class SpeciesResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Code { get; set; } = string.Empty;

    public string? Icon { get; set; }

    public int SortOrder { get; set; }
}
