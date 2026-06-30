using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Catalogs;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class CatalogService : ICatalogService
{
    private readonly PiyiDbContext _dbContext;

    public CatalogService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<SpeciesResponse>>> GetSpeciesAsync(CancellationToken cancellationToken = default)
    {
        var items = await _dbContext.Species
            .AsNoTracking()
            .Where(x => !x.IsDeleted)
            .OrderBy(x => x.SortOrder)
            .ThenBy(x => x.Name)
            .Select(x => new SpeciesResponse
            {
                Id = x.Id,
                Name = x.Name,
                Code = x.Code,
                Icon = x.Icon,
                SortOrder = x.SortOrder
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<SpeciesResponse>>.Success(items);
    }

    public async Task<Result<IReadOnlyList<BreedResponse>>> GetBreedsBySpeciesAsync(Guid speciesId, CancellationToken cancellationToken = default)
    {
        var speciesExists = await _dbContext.Species
            .AnyAsync(x => x.Id == speciesId && !x.IsDeleted, cancellationToken);

        if (!speciesExists)
            return Result<IReadOnlyList<BreedResponse>>.Failure("La especie no existe.");

        var items = await _dbContext.Breeds
            .AsNoTracking()
            .Where(x => x.SpeciesId == speciesId && !x.IsDeleted)
            .OrderBy(x => x.SortOrder)
            .ThenBy(x => x.Name)
            .Select(x => new BreedResponse
            {
                Id = x.Id,
                SpeciesId = x.SpeciesId,
                Name = x.Name,
                Size = x.Size,
                SortOrder = x.SortOrder
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<BreedResponse>>.Success(items);
    }
}
