using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class UserNotification : BaseEntity
{
    public Guid UserId { get; set; }

    public NotificationType Type { get; set; } = NotificationType.General;

    public string Title { get; set; } = string.Empty;

    public string Body { get; set; } = string.Empty;

    public string? DataJson { get; set; }

    public bool IsRead { get; set; }

    public DateTimeOffset? ReadAt { get; set; }

    public User User { get; set; } = default!;
}
