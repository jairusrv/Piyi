namespace Piyi.Contracts.Businesses;

public sealed class BusinessDetailResponse
{
    public Guid Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public Guid? BusinessTypeId { get; set; }

    public string? BusinessTypeName { get; set; }
}
