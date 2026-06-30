using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Businesses;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/admin/businesses")]
[Authorize(Roles = "Admin")]
public sealed class AdminBusinessesController : ControllerBase
{
    private readonly IAdminBusinessService _adminBusinessService;

    public AdminBusinessesController(IAdminBusinessService adminBusinessService)
    {
        _adminBusinessService = adminBusinessService;
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateBusinessRequest request, CancellationToken cancellationToken)
    {
        var result = await _adminBusinessService.CreateAsync(request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateBusinessRequest request, CancellationToken cancellationToken)
    {
        var result = await _adminBusinessService.UpdateAsync(id, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPut("{id:guid}/verify")]
    public async Task<IActionResult> Verify(Guid id, CancellationToken cancellationToken)
    {
        var result = await _adminBusinessService.VerifyAsync(id, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Negocio verificado correctamente." });
    }

    [HttpPut("{id:guid}/activate")]
    public async Task<IActionResult> Activate(Guid id, CancellationToken cancellationToken)
    {
        var result = await _adminBusinessService.ActivateAsync(id, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Negocio activado correctamente." });
    }

    [HttpPut("{id:guid}/deactivate")]
    public async Task<IActionResult> Deactivate(Guid id, CancellationToken cancellationToken)
    {
        var result = await _adminBusinessService.DeactivateAsync(id, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Negocio desactivado correctamente." });
    }
}
