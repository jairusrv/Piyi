using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public sealed class UsersController : ControllerBase
{
    private readonly IUserService _userService;

    public UsersController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpGet("me")]
    public async Task<IActionResult> Me(CancellationToken cancellationToken)
    {
        var userIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(userIdValue, out var userId))
            return Unauthorized(new { message = "Token inválido." });

        var result = await _userService.GetCurrentUserAsync(userId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(result.Value);
    }
}
