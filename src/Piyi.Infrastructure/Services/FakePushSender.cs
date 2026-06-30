using Microsoft.Extensions.Logging;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;

namespace Piyi.Infrastructure.Services;

public sealed class FakePushSender : IPushSender
{
    private readonly ILogger<FakePushSender> _logger;

    public FakePushSender(ILogger<FakePushSender> logger)
    {
        _logger = logger;
    }

    public Task<Result> SendAsync(
        string pushToken,
        string title,
        string body,
        string? dataJson,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(pushToken))
            return Task.FromResult(Result.Failure("Push token vacío."));

        _logger.LogInformation(
            "FAKE PUSH SENT | Token: {PushToken} | Title: {Title} | Body: {Body} | Data: {DataJson}",
            pushToken,
            title,
            body,
            dataJson);

        return Task.FromResult(Result.Success());
    }
}
