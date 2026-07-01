using Piyi.Contracts.Maps;

namespace Piyi.Application.Abstractions;

public interface IMapService
{
    Task<IReadOnlyList<LostPetMapMarkerDto>> GetLostPetsAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<BusinessMapMarkerDto>> GetBusinessesAsync(CancellationToken cancellationToken = default);
}
