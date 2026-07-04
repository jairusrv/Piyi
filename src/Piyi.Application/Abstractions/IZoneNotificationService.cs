using Piyi.Contracts.ZoneNotifications;

namespace Piyi.Application.Abstractions;

public interface IZoneNotificationService
{
    Task<UserSafeZoneDto?> GetSafeZoneAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<UserSafeZoneDto> UpsertSafeZoneAsync(
        Guid userId,
        UpsertUserSafeZoneRequest request,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<NearbyLostPetAlertDto>> GetNearbyLostPetsAsync(
        Guid userId,
        CancellationToken cancellationToken = default);
}
