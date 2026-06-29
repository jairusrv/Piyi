using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class BusinessType : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public string? Icon { get; set; }
    public int SortOrder { get; set; }
    public bool IsActive { get; set; } = true;

    public ICollection<Business> Businesses { get; set; } = new List<Business>();
}
