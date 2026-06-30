using Piyi.Application.Common;
using Piyi.Contracts.Businesses;

namespace Piyi.Application.Abstractions;

public interface IBusinessDirectoryService
{
    Task<Result<IReadOnlyList<BusinessListItemResponse>>> SearchAsync(
        string? search,
        Guid? businessTypeId,
        CancellationToken cancellationToken = default);

    Task<Result<BusinessDetailResponse>> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
}
