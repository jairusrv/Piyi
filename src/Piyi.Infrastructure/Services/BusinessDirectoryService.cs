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
            .Where(x => !x.IsDeleted);

        if (!string.IsNullOrWhiteSpace(search))
        {
            var term = search.Trim().ToLower();
            query = query.Where(x => x.Name.ToLower().Contains(term));
        }

        if (businessTypeId.HasValue)
        {
            query = query.Where(x => x.BusinessTypeId == businessTypeId.Value);
        }

        var items = await query
            .OrderBy(x => x.Name)
            .Select(x => new BusinessListItemResponse
            {
                Id = x.Id,
                Name = x.Name,
                BusinessTypeId = x.BusinessTypeId,
                BusinessTypeName = x.BusinessType != null ? x.BusinessType.Name : null
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<BusinessListItemResponse>>.Success(items);
    }

    public async Task<Result<BusinessDetailResponse>> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var business = await _dbContext.Businesses
            .AsNoTracking()
            .Include(x => x.BusinessType)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

        if (business is null)
            return Result<BusinessDetailResponse>.Failure("Negocio no encontrado.");

        return Result<BusinessDetailResponse>.Success(new BusinessDetailResponse
        {
            Id = business.Id,
            Name = business.Name,
            BusinessTypeId = business.BusinessTypeId,
            BusinessTypeName = business.BusinessType?.Name
        });
    }
}
