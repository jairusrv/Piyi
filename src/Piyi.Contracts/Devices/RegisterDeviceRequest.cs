namespace Piyi.Contracts.Devices;

public sealed class RegisterDeviceRequest
{
    public string DeviceIdentifier { get; set; } = string.Empty;

    public string Platform { get; set; } = "Unknown";

    public string PushToken { get; set; } = string.Empty;

    public string? DeviceName { get; set; }

    public string? AppVersion { get; set; }
}
