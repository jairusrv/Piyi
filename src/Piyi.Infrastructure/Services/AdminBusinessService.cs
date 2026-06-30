using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Businesses;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class AdminBusinessService : IAdminBusinessService
{
    private readonly PiyiDbContext _dbContext;

    public AdminBusinessService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<BusinessDetailResponse>> CreateAsync(CreateBusinessRequest request, CancellationToken cancellationToken = default)
    {
        var validation = await ValidateBusinessTypeAsync(request.BusinessTypeId, cancellationToken);
        if (validation.IsFailure)
            return Result<BusinessDetailResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<BusinessDetailResponse>.Failure("El nombre del negocio es requerido.");

        var business = new Business
        {
            Id = Guid.NewGuid(),
            BusinessTypeId = request.BusinessTypeId,
            Name = request.Name.Trim(),
            Description = Clean(request.Description),
            Phone = Clean(request.Phone),
            WhatsApp = Clean(request.WhatsApp),
            Email = Clean(request.Email),
            Website = Clean(request.Website),
            FacebookUrl = Clean(request.FacebookUrl),
            InstagramUrl = Clean(request.InstagramUrl),
            TikTokUrl = Clean(request.TikTokUrl),
            Address = Clean(request.Address),
            Country = Clean(request.Country),
            Region = Clean(request.Region),
            City = Clean(request.City),
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            LogoUrl = Clean(request.LogoUrl),
            IsVerified = false,
            IsActive = true,
            Status = BusinessStatus.Active,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.Businesses.Add(business);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return await GetBusinessDetailAsync(business.Id, cancellationToken);
    }

    public async Task<Result<BusinessDetailResponse>> UpdateAsync(Guid id, UpdateBusinessRequest request, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

        if (business is null)
            return Result<BusinessDetailResponse>.Failure("Negocio no encontrado.");

        var validation = await ValidateBusinessTypeAsync(request.BusinessTypeId, cancellationToken);
        if (validation.IsFailure)
            return Result<BusinessDetailResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<BusinessDetailResponse>.Failure("El nombre del negocio es requerido.");

        business.BusinessTypeId = request.BusinessTypeId;
        business.Name = request.Name.Trim();
        business.Description = Clean(request.Description);
        business.Phone = Clean(request.Phone);
        business.WhatsApp = Clean(request.WhatsApp);
        business.Email = Clean(request.Email);
        business.Website = Clean(request.Website);
        business.FacebookUrl = Clean(request.FacebookUrl);
        business.InstagramUrl = Clean(request.InstagramUrl);
        business.TikTokUrl = Clean(request.TikTokUrl);
        business.Address = Clean(request.Address);
        business.Country = Clean(request.Country);
        business.Region = Clean(request.Region);
        business.City = Clean(request.City);
        business.Latitude = request.Latitude;
        business.Longitude = request.Longitude;
        business.LogoUrl = Clean(request.LogoUrl);
        business.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return await GetBusinessDetailAsync(business.Id, cancellationToken);
    }

    public async Task<Result> VerifyAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);
        if (business is null) return Result.Failure("Negocio no encontrado.");

        business.IsVerified = true;
        business.UpdatedAt = DateTimeOffset.UtcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> ActivateAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);
        if (business is null) return Result.Failure("Negocio no encontrado.");

        business.IsActive = true;
        business.Status = BusinessStatus.Active;
        business.UpdatedAt = DateTimeOffset.UtcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> DeactivateAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);
        if (business is null) return Result.Failure("Negocio no encontrado.");

        business.IsActive = false;
        business.Status = BusinessStatus.Inactive;
        business.UpdatedAt = DateTimeOffset.UtcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private async Task<Result<BusinessDetailResponse>> GetBusinessDetailAsync(Guid id, CancellationToken cancellationToken)
    {
        var business = await _dbContext.Businesses
            .AsNoTracking()
            .Include(x => x.BusinessType)
            .Include(x => x.Photos)
            .Include(x => x.Services)
            .Include(x => x.Schedules)
            .FirstAsync(x => x.Id == id, cancellationToken);

        return Result<BusinessDetailResponse>.Success(new BusinessDetailResponse
        {
            Id = business.Id,
            Name = business.Name,
            BusinessTypeId = business.BusinessTypeId,
            BusinessTypeName = business.BusinessType?.Name,
            Description = business.Description,
            Phone = business.Phone,
            WhatsApp = business.WhatsApp,
            Email = business.Email,
            Website = business.Website,
            FacebookUrl = business.FacebookUrl,
            InstagramUrl = business.InstagramUrl,
            TikTokUrl = business.TikTokUrl,
            Address = business.Address,
            Country = business.Country,
            Region = business.Region,
            City = business.City,
            Latitude = business.Latitude,
            Longitude = business.Longitude,
            LogoUrl = business.LogoUrl,
            IsVerified = business.IsVerified,
            IsActive = business.IsActive
        });
    }

    private async Task<Result> ValidateBusinessTypeAsync(Guid businessTypeId, CancellationToken cancellationToken)
    {
        var exists = await _dbContext.BusinessTypes.AnyAsync(x => x.Id == businessTypeId && !x.IsDeleted, cancellationToken);
        return exists ? Result.Success() : Result.Failure("El tipo de negocio no existe.");
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}
