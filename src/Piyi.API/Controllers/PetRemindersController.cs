using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Pets;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/pets/{petId:guid}/reminders")]
[Authorize]
public sealed class PetRemindersController : ControllerBase
{
    private readonly IPetHealthService _petHealthService;

    public PetRemindersController(IPetHealthService petHealthService)
    {
        _petHealthService = petHealthService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(Guid petId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _petHealthService.GetRemindersAsync(userId.Value, petId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Guid petId, [FromBody] CreatePetReminderRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _petHealthService.CreateReminderAsync(userId.Value, petId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{reminderId:guid}/complete")]
    public async Task<IActionResult> Complete(Guid petId, Guid reminderId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _petHealthService.CompleteReminderAsync(userId.Value, petId, reminderId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Recordatorio completado correctamente." });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
