using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/users/me/notifications")]
[Authorize]
public sealed class UserNotificationsController : ControllerBase
{
    private readonly INotificationService _notificationService;

    public UserNotificationsController(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] bool unreadOnly, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _notificationService.GetMyNotificationsAsync(userId.Value, unreadOnly, cancellationToken);
        return Ok(result.Value);
    }

    [HttpPut("{notificationId:guid}/read")]
    public async Task<IActionResult> MarkAsRead(Guid notificationId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _notificationService.MarkAsReadAsync(userId.Value, notificationId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Notificación marcada como leída." });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
