using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/public/pets/qr")]
public sealed class PublicPetQrController : ControllerBase
{
    private readonly IPetQrService _petQrService;

    public PublicPetQrController(IPetQrService petQrService)
    {
        _petQrService = petQrService;
    }

    [HttpGet("{code}")]
    public async Task<IActionResult> GetByCode(string code, CancellationToken cancellationToken)
    {
        var result = await _petQrService.GetPublicProfileByCodeAsync(code, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }
}
