namespace Piyi.Contracts.Notifications;

public sealed class ProcessPushQueueResponse
{
    public int Processed { get; set; }

    public int Sent { get; set; }

    public int Failed { get; set; }
}
