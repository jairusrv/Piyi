using Piyi.Application.Common;
using Piyi.Contracts.Pets;

namespace Piyi.Application.Abstractions;

public interface IPetService
{
    Task<Result<IReadOnlyList<PetResponse>>> GetMyPetsAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<Result<PetResponse>> GetPetByIdAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PetResponse>> CreatePetAsync(Guid userId, CreatePetRequest request, CancellationToken cancellationToken = default);

    Task<Result<PetResponse>> UpdatePetAsync(Guid userId, Guid petId, UpdatePetRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeletePetAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);
}
