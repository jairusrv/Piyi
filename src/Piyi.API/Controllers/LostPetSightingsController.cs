using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.LostPets;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/lost-pets/{lostPetId:guid}/sightings")]
public sealed class LostPetSightingsController : ControllerBase
{
    private readonly ILostPetSightingService _sightingService;

    public LostPetSightingsController(ILostPetSightingService sightingService)
    {
        _sightingService = sightingService;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        Guid lostPetId,
        [FromBody] CreateLostPetSightingRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserIdOptional();

        var result = await _sightingService.CreateAsync(userId, lostPetId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpGet]
    public async Task<IActionResult> Get(Guid lostPetId, CancellationToken cancellationToken)
    {
        var result = await _sightingService.GetByLostPetAsync(lostPetId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{sightingId:guid}/confirm")]
    [Authorize]
    public async Task<IActionResult> Confirm(Guid lostPetId, Guid sightingId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserIdRequired();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _sightingService.ConfirmAsync(userId.Value, lostPetId, sightingId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Avistamiento confirmado." });
    }

    [HttpPut("{sightingId:guid}/discard")]
    [Authorize]
    public async Task<IActionResult> Discard(Guid lostPetId, Guid sightingId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserIdRequired();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _sightingService.DiscardAsync(userId.Value, lostPetId, sightingId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Avistamiento descartado." });
    }

    [HttpDelete("{sightingId:guid}")]
    [Authorize]
    public async Task<IActionResult> Delete(Guid lostPetId, Guid sightingId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserIdRequired();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _sightingService.DeleteAsync(userId.Value, lostPetId, sightingId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Avistamiento eliminado." });
    }

    private Guid? GetCurrentUserIdOptional()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }

    private Guid? GetCurrentUserIdRequired()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
