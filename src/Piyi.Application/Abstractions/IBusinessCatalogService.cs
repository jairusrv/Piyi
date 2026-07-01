using Piyi.Contracts.BusinessCatalog;

namespace Piyi.Application.Abstractions;

public interface IBusinessCatalogService
{
    Task<IReadOnlyList<BusinessCatalogItemDto>> SearchAsync(
        string? search,
        string? category,
        string? brand,
        string? species,
        string? breed,
        bool availableOnly,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<BusinessCatalogItemDto>> GetByBusinessAsync(
        Guid businessId,
        CancellationToken cancellationToken = default);

    Task<BusinessCatalogItemDto?> GetByIdAsync(
        Guid id,
        CancellationToken cancellationToken = default);

    Task<BusinessCatalogItemDto> CreateAsync(
        CreateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken = default);

    Task<BusinessCatalogItemDto?> UpdateAsync(
        Guid id,
        UpdateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken = default);

    Task<bool> DeleteAsync(
        Guid id,
        CancellationToken cancellationToken = default);
}
