using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessReviews;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class BusinessReviewService : IBusinessReviewService
{
    private readonly PiyiDbContext _db;

    public BusinessReviewService(PiyiDbContext db)
    {
        _db = db;
    }

    public async Task<IReadOnlyList<BusinessReviewDto>> GetByBusinessAsync(
        Guid businessId,
        CancellationToken cancellationToken = default)
    {
        var reviews = await _db.Set<BusinessReview>()
            .AsNoTracking()
            .Include(x => x.User)
            .Where(x =>
                x.BusinessId == businessId &&
                !x.IsDeleted &&
                x.IsApproved)
            .OrderByDescending(x => x.CreatedAt)
            .Take(100)
            .ToListAsync(cancellationToken);

        return reviews.Select(ToDto).ToList();
    }

    public async Task<BusinessReviewSummaryDto> GetSummaryAsync(
        Guid businessId,
        CancellationToken cancellationToken = default)
    {
        var ratings = await _db.Set<BusinessReview>()
            .AsNoTracking()
            .Where(x =>
                x.BusinessId == businessId &&
                !x.IsDeleted &&
                x.IsApproved)
            .Select(x => x.Rating)
            .ToListAsync(cancellationToken);

        if (ratings.Count == 0)
        {
            return new BusinessReviewSummaryDto(
                businessId,
                0,
                0,
                0,
                0,
                0,
                0,
                0);
        }

        return new BusinessReviewSummaryDto(
            businessId,
            Math.Round((decimal)ratings.Average(), 2),
            ratings.Count,
            ratings.Count(x => x == 5),
            ratings.Count(x => x == 4),
            ratings.Count(x => x == 3),
            ratings.Count(x => x == 2),
            ratings.Count(x => x == 1));
    }

    public async Task<BusinessReviewDto> CreateAsync(
        Guid businessId,
        Guid userId,
        CreateBusinessReviewRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.Rating < 1 || request.Rating > 5)
        {
            throw new InvalidOperationException("La calificación debe estar entre 1 y 5.");
        }

        var businessExists = await _db.Businesses
            .AnyAsync(x => x.Id == businessId && !x.IsDeleted && x.IsActive, cancellationToken);

        if (!businessExists)
        {
            throw new InvalidOperationException("El negocio no existe.");
        }

        var review = new BusinessReview
        {
            BusinessId = businessId,
            UserId = userId,
            Rating = request.Rating,
            Comment = Clean(request.Comment),
            PhotosJson = SerializePhotos(request.Photos),
            CreatedAt = DateTimeOffset.UtcNow,
            IsApproved = true
        };

        _db.Set<BusinessReview>().Add(review);
        await _db.SaveChangesAsync(cancellationToken);

        var created = await _db.Set<BusinessReview>()
            .AsNoTracking()
            .Include(x => x.User)
            .FirstAsync(x => x.Id == review.Id, cancellationToken);

        return ToDto(created);
    }

    public async Task<BusinessReviewDto?> ReplyAsync(
        Guid reviewId,
        ReplyBusinessReviewRequest request,
        CancellationToken cancellationToken = default)
    {
        var review = await _db.Set<BusinessReview>()
            .Include(x => x.User)
            .FirstOrDefaultAsync(x => x.Id == reviewId && !x.IsDeleted, cancellationToken);

        if (review is null)
        {
            return null;
        }

        review.BusinessReply = Clean(request.Reply);
        review.BusinessRepliedAt = DateTimeOffset.UtcNow;
        review.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(review);
    }

    public async Task<bool> ReportAsync(
        Guid reviewId,
        ReportBusinessReviewRequest request,
        CancellationToken cancellationToken = default)
    {
        var review = await _db.Set<BusinessReview>()
            .FirstOrDefaultAsync(x => x.Id == reviewId && !x.IsDeleted, cancellationToken);

        if (review is null)
        {
            return false;
        }

        review.IsReported = true;
        review.ReportReason = Clean(request.Reason);
        review.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return true;
    }

    public async Task<bool> DeleteAsync(
        Guid reviewId,
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        var review = await _db.Set<BusinessReview>()
            .FirstOrDefaultAsync(x =>
                x.Id == reviewId &&
                x.UserId == userId &&
                !x.IsDeleted,
                cancellationToken);

        if (review is null)
        {
            return false;
        }

        review.IsDeleted = true;
        review.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return true;
    }

    private static BusinessReviewDto ToDto(BusinessReview review)
    {
        // Tu entidad User actual no tiene FullName.
        // Usamos Email como nombre visible temporal.
        var userName = review.User?.Email;

        return new BusinessReviewDto(
            review.Id,
            review.BusinessId,
            review.UserId,
            userName,
            review.Rating,
            review.Comment,
            DeserializePhotos(review.PhotosJson),
            review.BusinessReply,
            review.BusinessRepliedAt,
            review.IsReported,
            review.IsApproved,
            review.CreatedAt);
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static string? SerializePhotos(IReadOnlyList<string>? photos)
    {
        if (photos is null || photos.Count == 0)
        {
            return null;
        }

        var clean = photos
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Select(x => x.Trim())
            .Take(5)
            .ToList();

        return clean.Count == 0 ? null : JsonSerializer.Serialize(clean);
    }

    private static IReadOnlyList<string> DeserializePhotos(string? json)
    {
        if (string.IsNullOrWhiteSpace(json))
        {
            return Array.Empty<string>();
        }

        try
        {
            var result = JsonSerializer.Deserialize<List<string>>(json);
            return result is null ? Array.Empty<string>() : result;
        }
        catch
        {
            return Array.Empty<string>();
        }
    }
}
