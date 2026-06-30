namespace Piyi.Contracts.Pets;

public sealed class PetQrCodeResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public string Code { get; set; } = string.Empty;

    public string PublicUrl { get; set; } = string.Empty;

    public bool IsActive { get; set; }

    public int ScanCount { get; set; }

    public DateTimeOffset? LastScannedAt { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
