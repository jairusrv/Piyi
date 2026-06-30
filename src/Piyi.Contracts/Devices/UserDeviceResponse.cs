namespace Piyi.Contracts.Devices;

public sealed class UserDeviceResponse
{
    public Guid Id { get; set; }

    public string DeviceIdentifier { get; set; } = string.Empty;

    public string Platform { get; set; } = string.Empty;

    public string? DeviceName { get; set; }

    public string? AppVersion { get; set; }

    public bool IsActive { get; set; }

    public DateTimeOffset? LastSeenAt { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
