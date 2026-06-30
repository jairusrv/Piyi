using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class PushNotificationQueue : BaseEntity
{
    public Guid UserId { get; set; }

    public Guid? UserDeviceId { get; set; }

    public Guid? UserNotificationId { get; set; }

    public string PushToken { get; set; } = string.Empty;

    public string Title { get; set; } = string.Empty;

    public string Body { get; set; } = string.Empty;

    public string? DataJson { get; set; }

    public PushNotificationStatus Status { get; set; } = PushNotificationStatus.Pending;

    public int AttemptCount { get; set; }

    public string? LastError { get; set; }

    public DateTimeOffset? SentAt { get; set; }

    public DateTimeOffset? NextAttemptAt { get; set; }

    public User User { get; set; } = default!;

    public UserDevice? UserDevice { get; set; }

    public UserNotification? UserNotification { get; set; }
}
