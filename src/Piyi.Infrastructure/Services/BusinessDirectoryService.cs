using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Businesses;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class BusinessDirectoryService : IBusinessDirectoryService
{
    private readonly PiyiDbContext _dbContext;

    public BusinessDirectoryService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<BusinessListItemResponse>>> SearchAsync(
        string? search,
        Guid? businessTypeId,
        CancellationToken cancellationToken = default)
    {
        var query = _dbContext.Businesses
            .AsNoTracking()
            .Include(x => x.BusinessType)
            .Where(x => !x.IsDeleted && x.IsActive);

        if (!string.IsNullOrWhiteSpace(search))
        {
            var term = search.Trim().ToLower();
            query = query.Where(x =>
                x.Name.ToLower().Contains(term) ||
                (x.Description != null && x.Description.ToLower().Contains(term)) ||
                (x.City != null && x.City.ToLower().Contains(term)) ||
                (x.Region != null && x.Region.ToLower().Contains(term)));
        }

        if (businessTypeId.HasValue)
        {
            query = query.Where(x => x.BusinessTypeId == businessTypeId.Value);
        }

        var items = await query
            .OrderByDescending(x => x.IsVerified)
            .ThenBy(x => x.Name)
            .Select(x => new BusinessListItemResponse
            {
                Id = x.Id,
                Name = x.Name,
                BusinessTypeId = x.BusinessTypeId,
                BusinessTypeName = x.BusinessType != null ? x.BusinessType.Name : null,
                Description = x.Description,
                Phone = x.Phone,
                WhatsApp = x.WhatsApp,
                Address = x.Address,
                City = x.City,
                Region = x.Region,
                Country = x.Country,
                Latitude = x.Latitude,
                Longitude = x.Longitude,
                LogoUrl = x.LogoUrl,
                IsVerified = x.IsVerified
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<BusinessListItemResponse>>.Success(items);
    }

    public async Task<Result<BusinessDetailResponse>> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses
            .AsNoTracking()
            .Include(x => x.BusinessType)
            .Include(x => x.Photos)
            .Include(x => x.Services)
            .Include(x => x.Schedules)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted && x.IsActive, cancellationToken);

        if (business is null)
            return Result<BusinessDetailResponse>.Failure("Negocio no encontrado.");

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
            IsActive = business.IsActive,
            Photos = business.Photos
                .Where(x => !x.IsDeleted)
                .OrderBy(x => x.SortOrder)
                .Select(x => new BusinessPhotoResponse
                {
                    Id = x.Id,
                    PhotoUrl = x.PhotoUrl,
                    SortOrder = x.SortOrder
                })
                .ToList(),
            Services = business.Services
                .Where(x => !x.IsDeleted && x.IsActive)
                .OrderBy(x => x.Name)
                .Select(x => new BusinessServiceResponse
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    PriceFrom = x.PriceFrom,
                    PriceTo = x.PriceTo,
                    IsActive = x.IsActive
                })
                .ToList(),
            Schedules = business.Schedules
                .Where(x => !x.IsDeleted)
                .OrderBy(x => x.DayOfWeek)
                .Select(x => new BusinessScheduleResponse
                {
                    Id = x.Id,
                    DayOfWeek = x.DayOfWeek,
                    OpensAt = x.OpensAt,
                    ClosesAt = x.ClosesAt,
                    IsClosed = x.IsClosed
                })
                .ToList()
        });
    }
}
