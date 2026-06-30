using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Notifications;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class NotificationService : INotificationService
{
    private readonly PiyiDbContext _dbContext;
    private readonly ILostPetAlertCandidateService _candidateService;

    public NotificationService(PiyiDbContext dbContext, ILostPetAlertCandidateService candidateService)
    {
        _dbContext = dbContext;
        _candidateService = candidateService;
    }

    public async Task<Result<IReadOnlyList<UserNotificationResponse>>> GetMyNotificationsAsync(
        Guid userId,
        bool unreadOnly = false,
        CancellationToken cancellationToken = default)
    {
        var query = _dbContext.UserNotifications
            .AsNoTracking()
            .Where(x => x.UserId == userId && !x.IsDeleted);

        if (unreadOnly)
            query = query.Where(x => !x.IsRead);

        var items = await query
            .OrderByDescending(x => x.CreatedAt)
            .Take(100)
            .Select(x => new UserNotificationResponse
            {
                Id = x.Id,
                Type = x.Type.ToString(),
                Title = x.Title,
                Body = x.Body,
                DataJson = x.DataJson,
                IsRead = x.IsRead,
                ReadAt = x.ReadAt,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<UserNotificationResponse>>.Success(items);
    }

    public async Task<Result> MarkAsReadAsync(Guid userId, Guid notificationId, CancellationToken cancellationToken = default)
    {
        var notification = await _dbContext.UserNotifications
            .FirstOrDefaultAsync(x => x.Id == notificationId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (notification is null)
            return Result.Failure("Notificación no encontrada.");

        notification.IsRead = true;
        notification.ReadAt = DateTimeOffset.UtcNow;
        notification.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result<GenerateLostPetAlertsResponse>> GenerateLostPetAlertsAsync(
        Guid lostPetId,
        CancellationToken cancellationToken = default)
    {
        var lostPet = await _dbContext.LostPets
            .AsNoTracking()
            .Include(x => x.Pet)
            .FirstOrDefaultAsync(x => x.Id == lostPetId && !x.IsDeleted, cancellationToken);

        if (lostPet is null)
            return Result<GenerateLostPetAlertsResponse>.Failure("Reporte no encontrado.");

        var candidatesResult = await _candidateService.GetCandidatesAsync(lostPetId, cancellationToken);

        if (candidatesResult.IsFailure)
            return Result<GenerateLostPetAlertsResponse>.Failure(candidatesResult.Error!);

        var candidates = candidatesResult.Value ?? Array.Empty<Piyi.Contracts.Alerts.AlertCandidateResponse>();

        var internalCount = 0;
        var pushCount = 0;

        foreach (var candidate in candidates)
        {
            if (candidate.UserId == lostPet.UserId)
                continue;

            var title = "Mascota perdida cerca de ti";
            var body = $"Ayuda a encontrar a {lostPet.Pet.Name}. Fue vista por última vez cerca de tu zona.";
            var dataJson = "{ \"type\": \"LostPetNearby\", \"lostPetId\": \"" + lostPet.Id + "\", \"petId\": \"" + lostPet.PetId + "\" }";

            var notification = new UserNotification
            {
                Id = Guid.NewGuid(),
                UserId = candidate.UserId,
                Type = NotificationType.LostPetNearby,
                Title = title,
                Body = body,
                DataJson = dataJson,
                IsRead = false,
                CreatedAt = DateTimeOffset.UtcNow
            };

            _dbContext.UserNotifications.Add(notification);
            internalCount++;

            var devices = await _dbContext.UserDevices
                .AsNoTracking()
                .Where(x => x.UserId == candidate.UserId && x.IsActive && !x.IsDeleted)
                .ToListAsync(cancellationToken);

            foreach (var device in devices)
            {
                _dbContext.PushNotificationQueue.Add(new PushNotificationQueue
                {
                    Id = Guid.NewGuid(),
                    UserId = candidate.UserId,
                    UserDeviceId = device.Id,
                    UserNotificationId = notification.Id,
                    PushToken = device.PushToken,
                    Title = title,
                    Body = body,
                    DataJson = dataJson,
                    Status = PushNotificationStatus.Pending,
                    AttemptCount = 0,
                    NextAttemptAt = DateTimeOffset.UtcNow,
                    CreatedAt = DateTimeOffset.UtcNow
                });

                pushCount++;
            }
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<GenerateLostPetAlertsResponse>.Success(new GenerateLostPetAlertsResponse
        {
            LostPetId = lostPetId,
            CandidateUsers = candidates.Count,
            InternalNotificationsCreated = internalCount,
            PushQueueItemsCreated = pushCount
        });
    }

    public async Task<Result<IReadOnlyList<PushQueueItemResponse>>> GetPendingPushQueueAsync(CancellationToken cancellationToken = default)
    {
        var items = await _dbContext.PushNotificationQueue
            .AsNoTracking()
            .Where(x => x.Status == PushNotificationStatus.Pending && !x.IsDeleted)
            .OrderBy(x => x.CreatedAt)
            .Take(100)
            .Select(x => new PushQueueItemResponse
            {
                Id = x.Id,
                UserId = x.UserId,
                UserDeviceId = x.UserDeviceId,
                Title = x.Title,
                Body = x.Body,
                Status = x.Status.ToString(),
                AttemptCount = x.AttemptCount,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<PushQueueItemResponse>>.Success(items);
    }
}
