using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessProfiles;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/business-profiles")]
public sealed class BusinessProfilesController : ControllerBase
{
    private readonly IBusinessProfileService _service;

    public BusinessProfilesController(IBusinessProfileService service)
    {
        _service = service;
    }

    [HttpGet("{businessId:guid}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetByBusiness(
        Guid businessId,
        CancellationToken cancellationToken)
    {
        var profile = await _service.GetByBusinessIdAsync(businessId, cancellationToken);

        if (profile is null)
        {
            return NotFound(new { message = "Negocio no encontrado." });
        }

        return Ok(profile);
    }

    [HttpPut("{businessId:guid}")]
    [Authorize]
    public async Task<IActionResult> Upsert(
        Guid businessId,
        UpsertBusinessProfileRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var profile = await _service.UpsertAsync(businessId, request, cancellationToken);
            return Ok(profile);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
