using Piyi.Contracts.BusinessReviews;

namespace Piyi.Application.Abstractions;

public interface IBusinessReviewService
{
    Task<IReadOnlyList<BusinessReviewDto>> GetByBusinessAsync(
        Guid businessId,
        CancellationToken cancellationToken = default);

    Task<BusinessReviewSummaryDto> GetSummaryAsync(
        Guid businessId,
        CancellationToken cancellationToken = default);

    Task<BusinessReviewDto> CreateAsync(
        Guid businessId,
        Guid userId,
        CreateBusinessReviewRequest request,
        CancellationToken cancellationToken = default);

    Task<BusinessReviewDto?> ReplyAsync(
        Guid reviewId,
        ReplyBusinessReviewRequest request,
        CancellationToken cancellationToken = default);

    Task<bool> ReportAsync(
        Guid reviewId,
        ReportBusinessReviewRequest request,
        CancellationToken cancellationToken = default);

    Task<bool> DeleteAsync(
        Guid reviewId,
        Guid userId,
        CancellationToken cancellationToken = default);
}
