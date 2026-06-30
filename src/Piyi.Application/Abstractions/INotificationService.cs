using Piyi.Application.Common;
using Piyi.Contracts.Notifications;

namespace Piyi.Application.Abstractions;

public interface INotificationService
{
    Task<Result<IReadOnlyList<UserNotificationResponse>>> GetMyNotificationsAsync(
        Guid userId,
        bool unreadOnly = false,
        CancellationToken cancellationToken = default);

    Task<Result> MarkAsReadAsync(Guid userId, Guid notificationId, CancellationToken cancellationToken = default);

    Task<Result<GenerateLostPetAlertsResponse>> GenerateLostPetAlertsAsync(Guid lostPetId, CancellationToken cancellationToken = default);

    Task<Result<IReadOnlyList<PushQueueItemResponse>>> GetPendingPushQueueAsync(CancellationToken cancellationToken = default);
}
