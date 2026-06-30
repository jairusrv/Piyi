using Piyi.Application.Common;

namespace Piyi.Application.Abstractions;

public interface IPushSender
{
    Task<Result> SendAsync(
        string pushToken,
        string title,
        string body,
        string? dataJson,
        CancellationToken cancellationToken = default);
}
