using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class CatalogsController : ControllerBase
{
    private readonly ICatalogService _catalogService;

    public CatalogsController(ICatalogService catalogService)
    {
        _catalogService = catalogService;
    }

    [HttpGet("species")]
    public async Task<IActionResult> GetSpecies(CancellationToken cancellationToken)
    {
        var result = await _catalogService.GetSpeciesAsync(cancellationToken);

        return Ok(result.Value);
    }

    [HttpGet("species/{speciesId:guid}/breeds")]
    public async Task<IActionResult> GetBreedsBySpecies(Guid speciesId, CancellationToken cancellationToken)
    {
        var result = await _catalogService.GetBreedsBySpeciesAsync(speciesId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }
}
