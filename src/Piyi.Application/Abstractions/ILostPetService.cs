using Piyi.Application.Common;
using Piyi.Contracts.LostPets;

namespace Piyi.Application.Abstractions;

public interface ILostPetService
{
    Task<Result<IReadOnlyList<LostPetListItemResponse>>> GetActiveAsync(
        string? city,
        string? region,
        decimal? latitude,
        decimal? longitude,
        decimal? radiusKm,
        CancellationToken cancellationToken = default);

    Task<Result<LostPetDetailResponse>> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<LostPetDetailResponse>> CreateAsync(Guid userId, Guid petId, CreateLostPetRequest request, CancellationToken cancellationToken = default);

    Task<Result<LostPetPhotoResponse>> AddPhotoAsync(Guid userId, Guid lostPetId, AddLostPetPhotoRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeletePhotoAsync(Guid userId, Guid lostPetId, Guid photoId, CancellationToken cancellationToken = default);

    Task<Result> MarkAsFoundAsync(Guid userId, Guid id, CancellationToken cancellationToken = default);

    Task<Result> CloseAsync(Guid userId, Guid id, CancellationToken cancellationToken = default);
}
