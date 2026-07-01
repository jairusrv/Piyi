using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/map")]
[Authorize]
public sealed class MapController : ControllerBase
{
    private readonly IMapService _mapService;

    public MapController(IMapService mapService)
    {
        _mapService = mapService;
    }

    [HttpGet("lost-pets")]
    public async Task<IActionResult> GetLostPets(CancellationToken cancellationToken)
    {
        var items = await _mapService.GetLostPetsAsync(cancellationToken);
        return Ok(items);
    }

    [HttpGet("businesses")]
    public async Task<IActionResult> GetBusinesses(CancellationToken cancellationToken)
    {
        var items = await _mapService.GetBusinessesAsync(cancellationToken);
        return Ok(items);
    }
}
