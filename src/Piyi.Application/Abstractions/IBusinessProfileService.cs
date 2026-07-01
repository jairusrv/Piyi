using Piyi.Contracts.BusinessProfiles;

namespace Piyi.Application.Abstractions;

public interface IBusinessProfileService
{
    Task<BusinessProfileDto?> GetByBusinessIdAsync(
        Guid businessId,
        CancellationToken cancellationToken = default);

    Task<BusinessProfileDto> UpsertAsync(
        Guid businessId,
        UpsertBusinessProfileRequest request,
        CancellationToken cancellationToken = default);
}
