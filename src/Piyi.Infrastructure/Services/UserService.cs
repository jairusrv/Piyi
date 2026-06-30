using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Users;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class UserService : IUserService
{
    private readonly PiyiDbContext _dbContext;
    private readonly IPasswordHasher _passwordHasher;

    public UserService(PiyiDbContext dbContext, IPasswordHasher passwordHasher)
    {
        _dbContext = dbContext;
        _passwordHasher = passwordHasher;
    }

    public async Task<Result<UserProfileResponse>> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _dbContext.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, cancellationToken);

        if (user is null)
            return Result<UserProfileResponse>.Failure("Usuario no encontrado.");

        return Result<UserProfileResponse>.Success(ToProfileResponse(user));
    }

    public async Task<Result<UserProfileResponse>> UpdateCurrentUserAsync(
        Guid userId,
        UpdateUserProfileRequest request,
        CancellationToken cancellationToken = default)
    {
        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, cancellationToken);

        if (user is null)
            return Result<UserProfileResponse>.Failure("Usuario no encontrado.");

        if (string.IsNullOrWhiteSpace(request.FirstName))
            return Result<UserProfileResponse>.Failure("El nombre es requerido.");

        if (string.IsNullOrWhiteSpace(request.LastName))
            return Result<UserProfileResponse>.Failure("El apellido es requerido.");

        user.FirstName = request.FirstName.Trim();
        user.LastName = request.LastName.Trim();
        user.PhoneNumber = string.IsNullOrWhiteSpace(request.PhoneNumber) ? null : request.PhoneNumber.Trim();
        user.PhotoUrl = string.IsNullOrWhiteSpace(request.PhotoUrl) ? null : request.PhotoUrl.Trim();
        user.Language = string.IsNullOrWhiteSpace(request.Language) ? null : request.Language.Trim();
        user.Country = string.IsNullOrWhiteSpace(request.Country) ? null : request.Country.Trim();
        user.TimeZone = string.IsNullOrWhiteSpace(request.TimeZone) ? null : request.TimeZone.Trim();
        user.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<UserProfileResponse>.Success(ToProfileResponse(user));
    }

    public async Task<Result> ChangePasswordAsync(
        Guid userId,
        ChangePasswordRequest request,
        CancellationToken cancellationToken = default)
    {
        var user = await _dbContext.Users
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, cancellationToken);

        if (user is null)
            return Result.Failure("Usuario no encontrado.");

        if (string.IsNullOrWhiteSpace(request.CurrentPassword))
            return Result.Failure("La contraseña actual es requerida.");

        if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Length < 8)
            return Result.Failure("La nueva contraseña debe tener al menos 8 caracteres.");

        if (string.IsNullOrWhiteSpace(user.PasswordHash) ||
            !_passwordHasher.Verify(request.CurrentPassword, user.PasswordHash))
        {
            return Result.Failure("La contraseña actual no es correcta.");
        }

        user.PasswordHash = _passwordHasher.Hash(request.NewPassword);
        user.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }

    private static UserProfileResponse ToProfileResponse(Piyi.Domain.Entities.User user)
    {
        return new UserProfileResponse
        {
            Id = user.Id,
            FirstName = user.FirstName,
            LastName = user.LastName,
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            Role = user.Role.ToString(),
            IsActive = user.IsActive,
            CreatedAt = user.CreatedAt
        };
    }
}
