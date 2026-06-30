namespace Piyi.Contracts.Businesses;

public sealed class CreateBusinessPhotoRequest
{
    public string PhotoUrl { get; set; } = string.Empty;

    public int SortOrder { get; set; }
}
