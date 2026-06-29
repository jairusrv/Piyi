using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class BusinessPhoto : BaseEntity
{
    public Guid BusinessId { get; set; }
    public string PhotoUrl { get; set; } = string.Empty;
    public int SortOrder { get; set; }

    public Business Business { get; set; } = null!;
}
