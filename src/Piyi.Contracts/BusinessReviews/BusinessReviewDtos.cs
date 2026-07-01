namespace Piyi.Contracts.BusinessReviews;

public sealed record BusinessReviewDto(
    Guid Id,
    Guid BusinessId,
    Guid UserId,
    string? UserName,
    int Rating,
    string? Comment,
    IReadOnlyList<string> Photos,
    string? BusinessReply,
    DateTimeOffset? BusinessRepliedAt,
    bool IsReported,
    bool IsApproved,
    DateTimeOffset CreatedAt);

public sealed record BusinessReviewSummaryDto(
    Guid BusinessId,
    decimal AverageRating,
    int TotalReviews,
    int FiveStars,
    int FourStars,
    int ThreeStars,
    int TwoStars,
    int OneStar);

public sealed record CreateBusinessReviewRequest(
    int Rating,
    string? Comment,
    IReadOnlyList<string>? Photos);

public sealed record ReplyBusinessReviewRequest(
    string Reply);

public sealed record ReportBusinessReviewRequest(
    string Reason);
