namespace Piyi.Contracts.ZoneNotifications;

public sealed record UserSafeZoneDto(
    Guid Id,
    Guid UserId,
    string Name,
    decimal Latitude,
    decimal Longitude,
    decimal RadiusKm,
    string? Address,
    string? District,
    string? City,
    string? Region,
    string? Country,
    bool IsActive);

public sealed record UpsertUserSafeZoneRequest(
    string? Name,
    decimal Latitude,
    decimal Longitude,
    decimal RadiusKm,
    string? Address,
    string? District,
    string? City,
    string? Region,
    string? Country);

public sealed record NearbyLostPetAlertDto(
    Guid LostPetId,
    Guid PetId,
    string PetName,
    string Title,
    string? PhotoUrl,
    string? LastSeenAddress,
    decimal? Latitude,
    decimal? Longitude,
    decimal DistanceKm,
    decimal? RewardAmount);
