using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/dev")]
public sealed class DevNotificationsController : ControllerBase
{
    private readonly INotificationService _notificationService;
    private readonly IPushQueueProcessorService _pushQueueProcessorService;
    private readonly IWebHostEnvironment _environment;

    public DevNotificationsController(
        INotificationService notificationService,
        IPushQueueProcessorService pushQueueProcessorService,
        IWebHostEnvironment environment)
    {
        _notificationService = notificationService;
        _pushQueueProcessorService = pushQueueProcessorService;
        _environment = environment;
    }

    [HttpPost("lost-pets/{lostPetId:guid}/generate-alerts")]
    public async Task<IActionResult> GenerateLostPetAlerts(Guid lostPetId, CancellationToken cancellationToken)
    {
        if (!_environment.IsDevelopment())
            return NotFound();

        var result = await _notificationService.GenerateLostPetAlertsAsync(lostPetId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpGet("push-queue/pending")]
    public async Task<IActionResult> GetPendingPushQueue(CancellationToken cancellationToken)
    {
        if (!_environment.IsDevelopment())
            return NotFound();

        var result = await _notificationService.GetPendingPushQueueAsync(cancellationToken);
        return Ok(result.Value);
    }

    [HttpPost("push-queue/process")]
    public async Task<IActionResult> ProcessPushQueue(
        [FromQuery] int maxItems,
        CancellationToken cancellationToken)
    {
        if (!_environment.IsDevelopment())
            return NotFound();

        var result = await _pushQueueProcessorService.ProcessPendingAsync(maxItems <= 0 ? 50 : maxItems, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }
}
