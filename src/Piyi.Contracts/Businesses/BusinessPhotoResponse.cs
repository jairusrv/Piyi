namespace Piyi.Contracts.Businesses;

public sealed class BusinessPhotoResponse
{
    public Guid Id { get; set; }

    public string PhotoUrl { get; set; } = string.Empty;

    public int SortOrder { get; set; }
}
