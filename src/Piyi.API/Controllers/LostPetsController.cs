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
    public async Task<IActionResult> GetActive(
        [FromQuery] string? city,
        [FromQuery] string? region,
        [FromQuery] decimal? latitude,
        [FromQuery] decimal? longitude,
        [FromQuery] decimal? radiusKm,
        CancellationToken cancellationToken)
    {
        var result = await _lostPetService.GetActiveAsync(city, region, latitude, longitude, radiusKm, cancellationToken);
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

    [HttpPost("lost-pets/{lostPetId:guid}/photos")]
    [Authorize]
    public async Task<IActionResult> AddPhoto(Guid lostPetId, [FromBody] AddLostPetPhotoRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _lostPetService.AddPhotoAsync(userId.Value, lostPetId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpDelete("lost-pets/{lostPetId:guid}/photos/{photoId:guid}")]
    [Authorize]
    public async Task<IActionResult> DeletePhoto(Guid lostPetId, Guid photoId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _lostPetService.DeletePhotoAsync(userId.Value, lostPetId, photoId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(new { message = "Foto eliminada correctamente." });
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
