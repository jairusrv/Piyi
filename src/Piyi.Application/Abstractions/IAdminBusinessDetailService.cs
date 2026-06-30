using Piyi.Application.Common;
using Piyi.Contracts.Businesses;

namespace Piyi.Application.Abstractions;

public interface IAdminBusinessDetailService
{
    Task<Result<BusinessServiceResponse>> AddServiceAsync(Guid businessId, CreateBusinessServiceRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeleteServiceAsync(Guid businessId, Guid serviceId, CancellationToken cancellationToken = default);

    Task<Result<BusinessPhotoResponse>> AddPhotoAsync(Guid businessId, CreateBusinessPhotoRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeletePhotoAsync(Guid businessId, Guid photoId, CancellationToken cancellationToken = default);

    Task<Result<IReadOnlyList<BusinessScheduleResponse>>> UpdateSchedulesAsync(Guid businessId, UpdateBusinessSchedulesRequest request, CancellationToken cancellationToken = default);
}
