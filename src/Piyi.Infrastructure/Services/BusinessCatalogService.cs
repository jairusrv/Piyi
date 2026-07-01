using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessCatalog;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class BusinessCatalogService : IBusinessCatalogService
{
    private readonly PiyiDbContext _db;

    public BusinessCatalogService(PiyiDbContext db)
    {
        _db = db;
    }

    public async Task<IReadOnlyList<BusinessCatalogItemDto>> SearchAsync(
        string? search,
        string? category,
        string? brand,
        string? species,
        string? breed,
        bool availableOnly,
        CancellationToken cancellationToken = default)
    {
        var query = _db.Set<BusinessCatalogItem>()
            .AsNoTracking()
            .Include(x => x.Business)
            .Where(x => !x.IsDeleted)
            .Where(x => !x.Business.IsDeleted)
            .Where(x => x.Business.IsActive)
            .Where(x => x.Business.IsProviderPro);

        if (availableOnly)
        {
            query = query.Where(x => x.IsAvailable);
        }

        if (!string.IsNullOrWhiteSpace(search))
        {
            var value = search.Trim().ToLower();

            query = query.Where(x =>
                x.Name.ToLower().Contains(value) ||
                (x.Description != null && x.Description.ToLower().Contains(value)) ||
                (x.Category != null && x.Category.ToLower().Contains(value)) ||
                (x.Brand != null && x.Brand.ToLower().Contains(value)) ||
                (x.Barcode != null && x.Barcode.ToLower().Contains(value)) ||
                (x.Sku != null && x.Sku.ToLower().Contains(value)) ||
                (x.Tags != null && x.Tags.ToLower().Contains(value)) ||
                (x.PetSpecies != null && x.PetSpecies.ToLower().Contains(value)) ||
                (x.BreedTarget != null && x.BreedTarget.ToLower().Contains(value)));
        }

        if (!string.IsNullOrWhiteSpace(category))
        {
            var value = category.Trim().ToLower();
            query = query.Where(x => x.Category != null && x.Category.ToLower().Contains(value));
        }

        if (!string.IsNullOrWhiteSpace(brand))
        {
            var value = brand.Trim().ToLower();
            query = query.Where(x => x.Brand != null && x.Brand.ToLower().Contains(value));
        }

        if (!string.IsNullOrWhiteSpace(species))
        {
            var value = species.Trim().ToLower();
            query = query.Where(x => x.PetSpecies != null && x.PetSpecies.ToLower().Contains(value));
        }

        if (!string.IsNullOrWhiteSpace(breed))
        {
            var value = breed.Trim().ToLower();
            query = query.Where(x => x.BreedTarget != null && x.BreedTarget.ToLower().Contains(value));
        }

        var items = await query
            .OrderByDescending(x => x.IsFeatured)
            .ThenBy(x => x.Name)
            .Take(100)
            .ToListAsync(cancellationToken);

        return items.Select(ToDto).ToList();
    }

    public async Task<IReadOnlyList<BusinessCatalogItemDto>> GetByBusinessAsync(
        Guid businessId,
        CancellationToken cancellationToken = default)
    {
        var items = await _db.Set<BusinessCatalogItem>()
            .AsNoTracking()
            .Include(x => x.Business)
            .Where(x => !x.IsDeleted)
            .Where(x => x.BusinessId == businessId)
            .Where(x => !x.Business.IsDeleted)
            .Where(x => x.Business.IsActive)
            .Where(x => x.Business.IsProviderPro)
            .OrderByDescending(x => x.IsFeatured)
            .ThenBy(x => x.Name)
            .ToListAsync(cancellationToken);

        return items.Select(ToDto).ToList();
    }

    public async Task<BusinessCatalogItemDto?> GetByIdAsync(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var item = await _db.Set<BusinessCatalogItem>()
            .AsNoTracking()
            .Include(x => x.Business)
            .Where(x => !x.IsDeleted)
            .Where(x => x.Id == id)
            .Where(x => !x.Business.IsDeleted)
            .Where(x => x.Business.IsActive)
            .Where(x => x.Business.IsProviderPro)
            .FirstOrDefaultAsync(cancellationToken);

        return item is null ? null : ToDto(item);
    }

    public async Task<BusinessCatalogItemDto> CreateAsync(
        CreateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken = default)
    {
        var business = await _db.Businesses
            .FirstOrDefaultAsync(x => x.Id == request.BusinessId && !x.IsDeleted, cancellationToken);

        if (business is null)
        {
            throw new InvalidOperationException("El negocio no existe.");
        }

        if (!business.IsProviderPro)
        {
            throw new InvalidOperationException("Esta función requiere plan Pro.");
        }

        var item = new BusinessCatalogItem
        {
            BusinessId = request.BusinessId,
            Type = (BusinessCatalogItemType)request.Type,
            Name = request.Name.Trim(),
            Description = Clean(request.Description),
            Category = Clean(request.Category),
            Brand = Clean(request.Brand),
            Barcode = Clean(request.Barcode),
            Sku = Clean(request.Sku),
            ReferencePrice = request.ReferencePrice,
            Currency = string.IsNullOrWhiteSpace(request.Currency) ? "CRC" : request.Currency.Trim().ToUpper(),
            PhotoUrl = Clean(request.PhotoUrl),
            IsAvailable = request.IsAvailable,
            IsFeatured = request.IsFeatured,
            PetSpecies = Clean(request.PetSpecies),
            BreedTarget = Clean(request.BreedTarget),
            AgeTarget = Clean(request.AgeTarget),
            WeightTarget = Clean(request.WeightTarget),
            Tags = Clean(request.Tags),
            Notes = Clean(request.Notes),
            CreatedAt = DateTimeOffset.UtcNow
        };

        _db.Set<BusinessCatalogItem>().Add(item);
        await _db.SaveChangesAsync(cancellationToken);

        var created = await GetByIdAsync(item.Id, cancellationToken);
        return created!;
    }

    public async Task<BusinessCatalogItemDto?> UpdateAsync(
        Guid id,
        UpdateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken = default)
    {
        var item = await _db.Set<BusinessCatalogItem>()
            .Include(x => x.Business)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

        if (item is null)
        {
            return null;
        }

        if (!item.Business.IsProviderPro)
        {
            throw new InvalidOperationException("Esta función requiere plan Pro.");
        }

        item.Type = (BusinessCatalogItemType)request.Type;
        item.Name = request.Name.Trim();
        item.Description = Clean(request.Description);
        item.Category = Clean(request.Category);
        item.Brand = Clean(request.Brand);
        item.Barcode = Clean(request.Barcode);
        item.Sku = Clean(request.Sku);
        item.ReferencePrice = request.ReferencePrice;
        item.Currency = string.IsNullOrWhiteSpace(request.Currency) ? "CRC" : request.Currency.Trim().ToUpper();
        item.PhotoUrl = Clean(request.PhotoUrl);
        item.IsAvailable = request.IsAvailable;
        item.IsFeatured = request.IsFeatured;
        item.PetSpecies = Clean(request.PetSpecies);
        item.BreedTarget = Clean(request.BreedTarget);
        item.AgeTarget = Clean(request.AgeTarget);
        item.WeightTarget = Clean(request.WeightTarget);
        item.Tags = Clean(request.Tags);
        item.Notes = Clean(request.Notes);
        item.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return await GetByIdAsync(id, cancellationToken);
    }

    public async Task<bool> DeleteAsync(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var item = await _db.Set<BusinessCatalogItem>()
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted, cancellationToken);

        if (item is null)
        {
            return false;
        }

        item.IsDeleted = true;
        item.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return true;
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static BusinessCatalogItemDto ToDto(BusinessCatalogItem x)
    {
        return new BusinessCatalogItemDto(
            x.Id,
            x.BusinessId,
            x.Business.Name,
            x.Business.Phone,
            x.Business.WhatsApp,
            x.Business.Address,
            x.Business.City,
            x.Business.Region,
            x.Business.Latitude,
            x.Business.Longitude,
            x.Business.IsVerified,
            (BusinessCatalogItemTypeDto)x.Type,
            x.Name,
            x.Description,
            x.Category,
            x.Brand,
            x.Barcode,
            x.Sku,
            x.ReferencePrice,
            x.Currency,
            x.PhotoUrl,
            x.IsAvailable,
            x.IsFeatured,
            x.PetSpecies,
            x.BreedTarget,
            x.AgeTarget,
            x.WeightTarget,
            x.Tags,
            x.Notes);
    }
}
