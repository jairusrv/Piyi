using Microsoft.AspNetCore.Mvc;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/system")]
public sealed class SystemController : ControllerBase
{
    [HttpGet("ping")]
    public IActionResult Ping()
    {
        return Ok(new
        {
            message = "Piyí API is running",
            timestamp = DateTimeOffset.UtcNow
        });
    }
}
