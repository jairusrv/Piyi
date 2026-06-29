using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Users;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class UserService : IUserService
{
    private readonly PiyiDbContext _dbContext;

    public UserService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<UserProfileResponse>> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _dbContext.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == userId && !x.IsDeleted, cancellationToken);

        if (user is null)
            return Result<UserProfileResponse>.Failure("Usuario no encontrado.");

        return Result<UserProfileResponse>.Success(new UserProfileResponse
        {
            Id = user.Id,
            FirstName = user.FirstName,
            LastName = user.LastName,
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            Role = user.Role.ToString(),
            IsActive = user.IsActive,
            CreatedAt = user.CreatedAt
        });
    }
}
