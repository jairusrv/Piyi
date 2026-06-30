using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Pets;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/pets/{petId:guid}/appointments")]
[Authorize]
public sealed class PetAppointmentsController : ControllerBase
{
    private readonly IPetAppointmentService _appointmentService;

    public PetAppointmentsController(IPetAppointmentService appointmentService)
    {
        _appointmentService = appointmentService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(Guid petId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.GetAppointmentsAsync(userId.Value, petId, cancellationToken);

        if (result.IsFailure) return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpGet("{appointmentId:guid}")]
    public async Task<IActionResult> GetById(Guid petId, Guid appointmentId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.GetAppointmentByIdAsync(userId.Value, petId, appointmentId, cancellationToken);

        if (result.IsFailure) return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Guid petId, [FromBody] CreatePetAppointmentRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.CreateAppointmentAsync(userId.Value, petId, request, cancellationToken);

        if (result.IsFailure) return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{appointmentId:guid}")]
    public async Task<IActionResult> Update(Guid petId, Guid appointmentId, [FromBody] UpdatePetAppointmentRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.UpdateAppointmentAsync(userId.Value, petId, appointmentId, request, cancellationToken);

        if (result.IsFailure) return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpDelete("{appointmentId:guid}")]
    public async Task<IActionResult> Delete(Guid petId, Guid appointmentId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.DeleteAppointmentAsync(userId.Value, petId, appointmentId, cancellationToken);

        if (result.IsFailure) return NotFound(new { message = result.Error });

        return Ok(new { message = "Cita eliminada correctamente." });
    }

    [HttpPut("{appointmentId:guid}/complete")]
    public async Task<IActionResult> Complete(Guid petId, Guid appointmentId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.CompleteAppointmentAsync(userId.Value, petId, appointmentId, cancellationToken);

        if (result.IsFailure) return BadRequest(new { message = result.Error });

        return Ok(new { message = "Cita marcada como completada." });
    }

    [HttpPut("{appointmentId:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid petId, Guid appointmentId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _appointmentService.CancelAppointmentAsync(userId.Value, petId, appointmentId, cancellationToken);

        if (result.IsFailure) return BadRequest(new { message = result.Error });

        return Ok(new { message = "Cita cancelada correctamente." });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
