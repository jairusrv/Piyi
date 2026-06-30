using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class UserDevice : BaseEntity
{
    public Guid UserId { get; set; }

    public string DeviceIdentifier { get; set; } = string.Empty;

    public DevicePlatform Platform { get; set; } = DevicePlatform.Unknown;

    public string PushToken { get; set; } = string.Empty;

    public string? DeviceName { get; set; }

    public string? AppVersion { get; set; }

    public bool IsActive { get; set; } = true;

    public DateTimeOffset? LastSeenAt { get; set; }

    public User User { get; set; } = default!;
}
