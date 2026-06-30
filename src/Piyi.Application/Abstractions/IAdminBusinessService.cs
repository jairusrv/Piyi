using Piyi.Application.Common;
using Piyi.Contracts.Businesses;

namespace Piyi.Application.Abstractions;

public interface IAdminBusinessService
{
    Task<Result<BusinessDetailResponse>> CreateAsync(CreateBusinessRequest request, CancellationToken cancellationToken = default);

    Task<Result<BusinessDetailResponse>> UpdateAsync(Guid id, UpdateBusinessRequest request, CancellationToken cancellationToken = default);

    Task<Result> VerifyAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result> ActivateAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result> DeactivateAsync(Guid id, CancellationToken cancellationToken = default);
}
