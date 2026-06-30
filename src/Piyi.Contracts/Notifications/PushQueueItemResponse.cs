namespace Piyi.Contracts.Notifications;

public sealed class PushQueueItemResponse
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public Guid? UserDeviceId { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Body { get; set; } = string.Empty;

    public string Status { get; set; } = string.Empty;

    public int AttemptCount { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
