namespace Piyi.Contracts.Devices;

public sealed class UpdateDeviceRequest
{
    public string PushToken { get; set; } = string.Empty;

    public string? DeviceName { get; set; }

    public string? AppVersion { get; set; }

    public bool IsActive { get; set; } = true;
}
