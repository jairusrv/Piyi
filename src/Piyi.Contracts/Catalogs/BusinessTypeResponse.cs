namespace Piyi.Contracts.Catalogs;

public sealed class BusinessTypeResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Code { get; set; } = string.Empty;

    public string? Icon { get; set; }
}
