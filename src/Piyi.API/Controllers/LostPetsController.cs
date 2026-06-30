using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.LostPets;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api")]
public sealed class LostPetsController : ControllerBase
{
    private readonly ILostPetService _lostPetService;

    public LostPetsController(ILostPetService lostPetService)
    {
        _lostPetService = lostPetService;
    }

    [HttpGet("lost-pets")]
    public async Task<IActionResult> GetActive(CancellationToken cancellationToken)
    {
        var result = await _lostPetService.GetActiveAsync(cancellationToken);
        return Ok(result.Value);
    }

    [HttpGet("lost-pets/{id:guid}")]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var result = await _lostPetService.GetByIdAsync(id, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPost("pets/{petId:guid}/lost-pets")]
    [Authorize]
    public async Task<IActionResult> Create(Guid petId, [FromBody] CreateLostPetRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _lostPetService.CreateAsync(userId.Value, petId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("lost-pets/{id:guid}/found")]
    [Authorize]
    public async Task<IActionResult> MarkAsFound(Guid id, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _lostPetService.MarkAsFoundAsync(userId.Value, id, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Mascota marcada como encontrada." });
    }

    [HttpPut("lost-pets/{id:guid}/close")]
    [Authorize]
    public async Task<IActionResult> Close(Guid id, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _lostPetService.CloseAsync(userId.Value, id, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Reporte cerrado correctamente." });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return Guid.TryParse(userIdValue, out var userId) ? userId : null;
    }
}
