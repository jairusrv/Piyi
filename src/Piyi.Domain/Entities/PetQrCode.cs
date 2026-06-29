using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class PetQrCode : BaseEntity
{
    public Guid PetId { get; set; }
    public string Code { get; set; } = string.Empty;
    public string PublicUrl { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public int ScanCount { get; set; }
    public DateTimeOffset? LastScannedAt { get; set; }

    public Pet Pet { get; set; } = null!;
}
