namespace Piyi.Domain.Entities;

public sealed class BusinessReview
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid BusinessId { get; set; }
    public Business Business { get; set; } = null!;

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public int Rating { get; set; }

    public string? Comment { get; set; }
    public string? PhotosJson { get; set; }

    public string? BusinessReply { get; set; }
    public DateTimeOffset? BusinessRepliedAt { get; set; }

    public bool IsReported { get; set; } = false;
    public string? ReportReason { get; set; }

    public bool IsApproved { get; set; } = true;

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? UpdatedAt { get; set; }

    public bool IsDeleted { get; set; } = false;
}
