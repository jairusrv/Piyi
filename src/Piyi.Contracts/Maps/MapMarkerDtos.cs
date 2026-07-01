namespace Piyi.Contracts.Maps;

public sealed record LostPetMapMarkerDto(
    Guid Id,
    string PetName,
    string Title,
    decimal? Latitude,
    decimal? Longitude,
    string? PhotoUrl,
    decimal? RewardAmount,
    string? LastSeenAddress);

public sealed record BusinessMapMarkerDto(
    Guid Id,
    string Name,
    string? BusinessTypeName,
    decimal? Latitude,
    decimal? Longitude,
    string? LogoUrl,
    bool IsVerified,
    string? Address);
