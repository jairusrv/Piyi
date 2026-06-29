namespace Piyi.Infrastructure.Authentication;

public sealed class JwtSettings
{
    public string Issuer { get; set; } = "Piyi";
    public string Audience { get; set; } = "Piyi";
    public string SecretKey { get; set; } = "CHANGE_THIS_SECRET_KEY_TO_A_LONG_SECURE_VALUE_32_CHARS_MIN";
    public int ExpirationMinutes { get; set; } = 1440;
}
