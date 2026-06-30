using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Devices;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/users/me/devices")]
[Authorize]
public sealed class UserDevicesController : ControllerBase
{
    private readonly IUserDeviceService _deviceService;

    public UserDevicesController(IUserDeviceService deviceService)
    {
        _deviceService = deviceService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _deviceService.GetMyDevicesAsync(userId.Value, cancellationToken);
        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Register(
        [FromBody] RegisterDeviceRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _deviceService.RegisterOrUpdateAsync(userId.Value, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{deviceId:guid}")]
    public async Task<IActionResult> Update(
        Guid deviceId,
        [FromBody] UpdateDeviceRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _deviceService.UpdateAsync(userId.Value, deviceId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpDelete("{deviceId:guid}")]
    public async Task<IActionResult> Deactivate(Guid deviceId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _deviceService.DeactivateAsync(userId.Value, deviceId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Dispositivo desactivado correctamente." });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
