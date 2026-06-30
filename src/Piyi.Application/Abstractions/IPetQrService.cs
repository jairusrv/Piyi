using Piyi.Application.Common;
using Piyi.Contracts.Pets;

namespace Piyi.Application.Abstractions;

public interface IPetQrService
{
    Task<Result<PetQrCodeResponse>> GenerateOrGetQrAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PetQrCodeResponse>> GetQrByPetAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PublicPetQrProfileResponse>> GetPublicProfileByCodeAsync(string code, CancellationToken cancellationToken = default);
}
