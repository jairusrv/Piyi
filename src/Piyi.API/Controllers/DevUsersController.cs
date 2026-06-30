using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Piyi.Contracts.Dev;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/dev/users")]
public sealed class DevUsersController : ControllerBase
{
    private readonly PiyiDbContext _dbContext;
    private readonly IWebHostEnvironment _environment;

    public DevUsersController(PiyiDbContext dbContext, IWebHostEnvironment environment)
    {
        _dbContext = dbContext;
        _environment = environment;
    }

    [HttpPost("promote-admin")]
    public async Task<IActionResult> PromoteToAdmin(
        [FromBody] PromoteUserToAdminRequest request,
        CancellationToken cancellationToken)
    {
        if (!_environment.IsDevelopment())
        {
            return NotFound();
        }

        if (string.IsNullOrWhiteSpace(request.Email))
        {
            return BadRequest(new { message = "El correo es requerido." });
        }

        var email = request.Email.Trim().ToLowerInvariant();

        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.Email == email && !x.IsDeleted, cancellationToken);

        if (user is null)
        {
            return NotFound(new { message = "Usuario no encontrado." });
        }

        user.Role = UserRole.Admin;
        user.IsActive = true;
        user.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Ok(new
        {
            message = "Usuario promovido a Admin correctamente. Debe iniciar sesión nuevamente para obtener un token actualizado.",
            user.Id,
            user.Email,
            Role = user.Role.ToString()
        });
    }
}
