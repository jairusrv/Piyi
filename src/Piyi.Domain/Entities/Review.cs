using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class Review : BaseEntity
{
    public Guid BusinessId { get; set; }
    public Guid UserId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public bool IsApproved { get; set; }

    public Business Business { get; set; } = null!;
    public User User { get; set; } = null!;
}
