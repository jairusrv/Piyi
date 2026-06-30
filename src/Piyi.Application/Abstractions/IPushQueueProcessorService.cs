using Piyi.Application.Common;
using Piyi.Contracts.Notifications;

namespace Piyi.Application.Abstractions;

public interface IPushQueueProcessorService
{
    Task<Result<ProcessPushQueueResponse>> ProcessPendingAsync(
        int maxItems = 50,
        CancellationToken cancellationToken = default);
}
