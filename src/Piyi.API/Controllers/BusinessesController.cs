using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class BusinessesController : ControllerBase
{
    private readonly IBusinessDirectoryService _businessDirectoryService;

    public BusinessesController(IBusinessDirectoryService businessDirectoryService)
    {
        _businessDirectoryService = businessDirectoryService;
    }

    [HttpGet]
    public async Task<IActionResult> Search(
        [FromQuery] string? search,
        [FromQuery] Guid? businessTypeId,
        CancellationToken cancellationToken)
    {
        var result = await _businessDirectoryService.SearchAsync(search, businessTypeId, cancellationToken);
        return Ok(result.Value);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var result = await _businessDirectoryService.GetByIdAsync(id, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }
}
