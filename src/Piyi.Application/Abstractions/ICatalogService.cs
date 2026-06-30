using Piyi.Application.Common;
using Piyi.Contracts.Catalogs;

namespace Piyi.Application.Abstractions;

public interface ICatalogService
{
    Task<Result<IReadOnlyList<SpeciesResponse>>> GetSpeciesAsync(CancellationToken cancellationToken = default);

    Task<Result<IReadOnlyList<BreedResponse>>> GetBreedsBySpeciesAsync(Guid speciesId, CancellationToken cancellationToken = default);
}
