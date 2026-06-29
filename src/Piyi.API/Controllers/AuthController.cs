using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Auth;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request, CancellationToken cancellationToken)
    {
        var result = await _authService.RegisterAsync(request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
    {
        var result = await _authService.LoginAsync(request, cancellationToken);

        if (result.IsFailure)
            return Unauthorized(new { message = result.Error });

        return Ok(result.Value);
    }
}
