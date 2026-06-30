using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Notifications;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class PushQueueProcessorService : IPushQueueProcessorService
{
    private readonly PiyiDbContext _dbContext;
    private readonly IPushSender _pushSender;

    public PushQueueProcessorService(PiyiDbContext dbContext, IPushSender pushSender)
    {
        _dbContext = dbContext;
        _pushSender = pushSender;
    }

    public async Task<Result<ProcessPushQueueResponse>> ProcessPendingAsync(
        int maxItems = 50,
        CancellationToken cancellationToken = default)
    {
        if (maxItems <= 0)
            maxItems = 50;

        if (maxItems > 200)
            maxItems = 200;

        var now = DateTimeOffset.UtcNow;

        var items = await _dbContext.PushNotificationQueue
            .Where(x =>
                !x.IsDeleted &&
                x.Status == PushNotificationStatus.Pending &&
                (x.NextAttemptAt == null || x.NextAttemptAt <= now))
            .OrderBy(x => x.CreatedAt)
            .Take(maxItems)
            .ToListAsync(cancellationToken);

        var response = new ProcessPushQueueResponse
        {
            Processed = items.Count
        };

        foreach (var item in items)
        {
            var result = await _pushSender.SendAsync(
                item.PushToken,
                item.Title,
                item.Body,
                item.DataJson,
                cancellationToken);

            item.AttemptCount++;
            item.UpdatedAt = DateTimeOffset.UtcNow;

            if (result.IsSuccess)
            {
                item.Status = PushNotificationStatus.Sent;
                item.SentAt = DateTimeOffset.UtcNow;
                item.LastError = null;
                response.Sent++;
            }
            else
            {
                item.LastError = result.Error;
                response.Failed++;

                if (item.AttemptCount >= 3)
                {
                    item.Status = PushNotificationStatus.Failed;
                }
                else
                {
                    item.Status = PushNotificationStatus.Pending;
                    item.NextAttemptAt = DateTimeOffset.UtcNow.AddMinutes(5 * item.AttemptCount);
                }
            }
        }

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<ProcessPushQueueResponse>.Success(response);
    }
}
