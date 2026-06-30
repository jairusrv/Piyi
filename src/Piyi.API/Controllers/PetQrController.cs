using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/pets/{petId:guid}/qr")]
[Authorize]
public sealed class PetQrController : ControllerBase
{
    private readonly IPetQrService _petQrService;

    public PetQrController(IPetQrService petQrService)
    {
        _petQrService = petQrService;
    }

    [HttpPost]
    public async Task<IActionResult> Generate(Guid petId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();

        if (userId is null)
            return Unauthorized(new { message = "Token inválido." });

        var result = await _petQrService.GenerateOrGetQrAsync(userId.Value, petId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpGet]
    public async Task<IActionResult> Get(Guid petId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();

        if (userId is null)
            return Unauthorized(new { message = "Token inválido." });

        var result = await _petQrService.GetQrByPetAsync(userId.Value, petId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    private Guid? GetCurrentUserId()
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);

        return Guid.TryParse(userIdValue, out var userId)
            ? userId
            : null;
    }
}
