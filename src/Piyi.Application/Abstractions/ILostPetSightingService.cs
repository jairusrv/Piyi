using Piyi.Application.Common;
using Piyi.Contracts.LostPets;

namespace Piyi.Application.Abstractions;

public interface ILostPetSightingService
{
    Task<Result<LostPetSightingResponse>> CreateAsync(
        Guid? userId,
        Guid lostPetId,
        CreateLostPetSightingRequest request,
        CancellationToken cancellationToken = default);

    Task<Result<IReadOnlyList<LostPetSightingResponse>>> GetByLostPetAsync(
        Guid lostPetId,
        CancellationToken cancellationToken = default);

    Task<Result> ConfirmAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default);

    Task<Result> DiscardAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default);

    Task<Result> DeleteAsync(Guid userId, Guid lostPetId, Guid sightingId, CancellationToken cancellationToken = default);
}
