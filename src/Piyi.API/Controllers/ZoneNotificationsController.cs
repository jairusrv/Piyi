using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.ZoneNotifications;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/zone-notifications")]
[Authorize]
public sealed class ZoneNotificationsController : ControllerBase
{
    private readonly IZoneNotificationService _service;

    public ZoneNotificationsController(IZoneNotificationService service)
    {
        _service = service;
    }

    [HttpGet("safe-zone")]
    public async Task<IActionResult> GetSafeZone(CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Usuario no autenticado." });

        var zone = await _service.GetSafeZoneAsync(userId.Value, cancellationToken);
        if (zone is null) return NotFound(new { message = "No tienes zona segura configurada." });

        return Ok(zone);
    }

    [HttpPut("safe-zone")]
    public async Task<IActionResult> UpsertSafeZone(
        UpsertUserSafeZoneRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Usuario no autenticado." });

        var zone = await _service.UpsertSafeZoneAsync(userId.Value, request, cancellationToken);
        return Ok(zone);
    }

    [HttpGet("nearby-lost-pets")]
    public async Task<IActionResult> GetNearbyLostPets(CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Usuario no autenticado." });

        var items = await _service.GetNearbyLostPetsAsync(userId.Value, cancellationToken);
        return Ok(items);
    }

    private Guid? GetCurrentUserId()
    {
        var value =
            User.FindFirstValue(ClaimTypes.NameIdentifier) ??
            User.FindFirstValue("sub") ??
            User.FindFirstValue("userId") ??
            User.FindFirstValue("id");

        return Guid.TryParse(value, out var id) ? id : null;
    }
}
