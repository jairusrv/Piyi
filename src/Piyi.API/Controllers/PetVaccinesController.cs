using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Pets;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/pets/{petId:guid}/vaccines")]
[Authorize]
public sealed class PetVaccinesController : ControllerBase
{
    private readonly IPetHealthService _petHealthService;

    public PetVaccinesController(IPetHealthService petHealthService)
    {
        _petHealthService = petHealthService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(Guid petId, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _petHealthService.GetVaccinesAsync(userId.Value, petId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Guid petId, [FromBody] CreatePetVaccineRequest request, CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized(new { message = "Token inválido." });

        var result = await _petHealthService.CreateVaccineAsync(userId.Value, petId, request, cancellationToken);

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
