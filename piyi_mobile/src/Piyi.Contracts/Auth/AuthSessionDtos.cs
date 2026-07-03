namespace Piyi.Contracts.Auth;

public sealed record RefreshTokenRequest(
    string RefreshToken);

public sealed record RefreshTokenResponse(
    string AccessToken,
    string? RefreshToken,
    DateTimeOffset ExpiresAt);

public sealed record LogoutRequest(
    string? RefreshToken);
