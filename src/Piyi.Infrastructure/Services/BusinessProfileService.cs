using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessProfiles;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class BusinessProfileService : IBusinessProfileService
{
    private readonly PiyiDbContext _db;

    public BusinessProfileService(PiyiDbContext db)
    {
        _db = db;
    }

    public async Task<BusinessProfileDto?> GetByBusinessIdAsync(
        Guid businessId,
        CancellationToken cancellationToken = default)
    {
        var business = await _db.Businesses
            .AsNoTracking()
            .Include(x => x.BusinessType)
            .FirstOrDefaultAsync(x =>
                x.Id == businessId &&
                !x.IsDeleted &&
                x.IsActive,
                cancellationToken);

        if (business is null)
        {
            return null;
        }

        var profile = await _db.Set<BusinessProfile>()
            .AsNoTracking()
            .FirstOrDefaultAsync(x =>
                x.BusinessId == businessId &&
                !x.IsDeleted,
                cancellationToken);

        return ToDto(business, profile);
    }

    public async Task<BusinessProfileDto> UpsertAsync(
        Guid businessId,
        UpsertBusinessProfileRequest request,
        CancellationToken cancellationToken = default)
    {
        var business = await _db.Businesses
            .Include(x => x.BusinessType)
            .FirstOrDefaultAsync(x =>
                x.Id == businessId &&
                !x.IsDeleted,
                cancellationToken);

        if (business is null)
        {
            throw new InvalidOperationException("El negocio no existe.");
        }

        var profile = await _db.Set<BusinessProfile>()
            .FirstOrDefaultAsync(x =>
                x.BusinessId == businessId &&
                !x.IsDeleted,
                cancellationToken);

        if (profile is null)
        {
            profile = new BusinessProfile
            {
                BusinessId = businessId,
                CreatedAt = DateTimeOffset.UtcNow
            };

            _db.Set<BusinessProfile>().Add(profile);
        }

        profile.BannerUrl = Clean(request.BannerUrl);
        profile.ShortDescription = Clean(request.ShortDescription);
        profile.LongDescription = Clean(request.LongDescription);
        profile.Story = Clean(request.Story);
        profile.Mission = Clean(request.Mission);
        profile.Specialties = Clean(request.Specialties);
        profile.Languages = Clean(request.Languages);

        profile.AcceptsSinpe = request.AcceptsSinpe;
        profile.AcceptsCard = request.AcceptsCard;
        profile.HasParking = request.HasParking;
        profile.IsAccessible = request.IsAccessible;
        profile.HasEmergency24h = request.HasEmergency24h;
        profile.HasHomeService = request.HasHomeService;
        profile.HasOwnDelivery = request.HasOwnDelivery;

        profile.WebsiteUrl = Clean(request.WebsiteUrl);
        profile.FacebookUrl = Clean(request.FacebookUrl);
        profile.InstagramUrl = Clean(request.InstagramUrl);
        profile.TikTokUrl = Clean(request.TikTokUrl);
        profile.YouTubeUrl = Clean(request.YouTubeUrl);

        profile.GalleryJson = SerializeGallery(request.Gallery);
        profile.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(business, profile);
    }

    private static BusinessProfileDto ToDto(Business business, BusinessProfile? profile)
    {
        return new BusinessProfileDto(
            profile?.Id ?? Guid.Empty,
            business.Id,
            business.Name,
            business.BusinessType?.Name,
            business.LogoUrl,
            profile?.BannerUrl,
            profile?.ShortDescription ?? business.Description,
            profile?.LongDescription ?? business.Description,
            profile?.Story,
            profile?.Mission,
            profile?.Specialties,
            profile?.Languages,
            profile?.AcceptsSinpe ?? false,
            profile?.AcceptsCard ?? false,
            profile?.HasParking ?? false,
            profile?.IsAccessible ?? false,
            profile?.HasEmergency24h ?? false,
            profile?.HasHomeService ?? false,
            profile?.HasOwnDelivery ?? false,
            profile?.WebsiteUrl,
            profile?.FacebookUrl,
            profile?.InstagramUrl,
            profile?.TikTokUrl,
            profile?.YouTubeUrl,
            business.Phone,
            business.WhatsApp,
            business.Email,
            business.Address,
            business.City,
            business.Region,
            business.Country,
            business.Latitude,
            business.Longitude,
            business.IsVerified,
            business.IsProviderPro,
            DeserializeGallery(profile?.GalleryJson));
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static string? SerializeGallery(IReadOnlyList<string>? gallery)
    {
        if (gallery is null || gallery.Count == 0)
        {
            return null;
        }

        var clean = gallery
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Select(x => x.Trim())
            .Take(20)
            .ToList();

        return clean.Count == 0 ? null : JsonSerializer.Serialize(clean);
    }

    private static IReadOnlyList<string> DeserializeGallery(string? json)
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
