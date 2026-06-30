namespace Piyi.Contracts.Notifications;

public sealed class GenerateLostPetAlertsResponse
{
    public Guid LostPetId { get; set; }

    public int CandidateUsers { get; set; }

    public int InternalNotificationsCreated { get; set; }

    public int PushQueueItemsCreated { get; set; }
}
