using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/dev/lost-pets")]
public sealed class DevLostPetAlertsController : ControllerBase
{
    private readonly ILostPetAlertCandidateService _service;
    private readonly IWebHostEnvironment _environment;

    public DevLostPetAlertsController(
        ILostPetAlertCandidateService service,
        IWebHostEnvironment environment)
    {
        _service = service;
        _environment = environment;
    }

    [HttpGet("{lostPetId:guid}/alert-candidates")]
    public async Task<IActionResult> GetCandidates(Guid lostPetId, CancellationToken cancellationToken)
    {
        if (!_environment.IsDevelopment())
            return NotFound();

        var result = await _service.GetCandidatesAsync(lostPetId, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }
}
