using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/dev")]
public sealed class DevNotificationsController : ControllerBase
{
    private readonly INotificationService _notificationService;
    private readonly IWebHostEnvironment _environment;

    public DevNotificationsController(
        INotificationService notificationService,
        IWebHostEnvironment environment)
    {
        _notificationService = notificationService;
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
}
