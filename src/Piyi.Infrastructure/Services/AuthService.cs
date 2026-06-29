using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Auth;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Authentication;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class AuthService : IAuthService
{
    private readonly PiyiDbContext _dbContext;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IJwtTokenService _jwtTokenService;
    private readonly JwtSettings _jwtSettings;

    public AuthService(
        PiyiDbContext dbContext,
        IPasswordHasher passwordHasher,
        IJwtTokenService jwtTokenService,
        IOptions<JwtSettings> jwtSettings)
    {
        _dbContext = dbContext;
        _passwordHasher = passwordHasher;
        _jwtTokenService = jwtTokenService;
        _jwtSettings = jwtSettings.Value;
    }

    public async Task<Result<AuthResponse>> RegisterAsync(RegisterRequest request, CancellationToken cancellationToken = default)
    {
        var email = request.Email.Trim().ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(request.FirstName))
            return Result<AuthResponse>.Failure("El nombre es requerido.");

        if (string.IsNullOrWhiteSpace(request.LastName))
            return Result<AuthResponse>.Failure("El apellido es requerido.");

        if (string.IsNullOrWhiteSpace(email))
            return Result<AuthResponse>.Failure("El correo es requerido.");

        if (string.IsNullOrWhiteSpace(request.Password) || request.Password.Length < 8)
            return Result<AuthResponse>.Failure("La contraseña debe tener al menos 8 caracteres.");

        var exists = await _dbContext.Users.AnyAsync(x => x.Email == email, cancellationToken);
        if (exists)
            return Result<AuthResponse>.Failure("Ya existe una cuenta con ese correo.");

        var user = new User
        {
            Id = Guid.NewGuid(),
            FirstName = request.FirstName.Trim(),
            LastName = request.LastName.Trim(),
            Email = email,
            PhoneNumber = request.PhoneNumber?.Trim(),
            PasswordHash = _passwordHasher.Hash(request.Password),
            Role = UserRole.User,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };

        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<AuthResponse>.Success(BuildAuthResponse(user));
    }

    public async Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default)
    {
        var email = request.Email.Trim().ToLowerInvariant();

        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.Email == email && !x.IsDeleted, cancellationToken);

        if (user is null)
            return Result<AuthResponse>.Failure("Correo o contraseña inválidos.");

        if (!user.IsActive)
            return Result<AuthResponse>.Failure("La cuenta está inactiva.");

        if (!_passwordHasher.Verify(request.Password, user.PasswordHash))
            return Result<AuthResponse>.Failure("Correo o contraseña inválidos.");

        return Result<AuthResponse>.Success(BuildAuthResponse(user));
    }

    private AuthResponse BuildAuthResponse(User user)
    {
        var expiresAt = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpirationMinutes);
        var token = _jwtTokenService.GenerateToken(user, expiresAt);

        return new AuthResponse
        {
            Token = token,
            ExpiresAt = expiresAt,
            User = new UserAuthResponse
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Role = user.Role.ToString()
            }
        };
    }
}
