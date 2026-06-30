using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Alerts;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/users/me/alert-settings")]
[Authorize]
public sealed class UserAlertSettingsController : ControllerBase
{
    private readonly IUserAlertSettingService _service;

    public UserAlertSettingsController(IUserAlertSettingService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _service.GetOrCreateAsync(userId.Value, cancellationToken);
        return Ok(result.Value);
    }

    [HttpPut]
    public async Task<IActionResult> Update(
        [FromBody] UpdateUserAlertSettingRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _service.UpdateAsync(userId.Value, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
