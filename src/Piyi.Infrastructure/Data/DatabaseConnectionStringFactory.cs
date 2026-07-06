using Microsoft.Extensions.Configuration;

namespace Piyi.Infrastructure.Data;

public static class DatabaseConnectionStringFactory
{
    public static string GetConnectionString(IConfiguration configuration)
    {
        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? string.Empty;

        var raw =
            Environment.GetEnvironmentVariable("ConnectionStrings__DefaultConnection") ??
            Environment.GetEnvironmentVariable("DATABASE_URL") ??
            Environment.GetEnvironmentVariable("NEON_DATABASE_URL") ??
            Environment.GetEnvironmentVariable("POSTGRES_URL") ??
            configuration.GetConnectionString("DefaultConnection");

        if (string.IsNullOrWhiteSpace(raw))
        {
            throw new InvalidOperationException(
                "No database connection string configured. Set DATABASE_URL or ConnectionStrings__DefaultConnection.");
        }

        var connectionString = Normalize(raw.Trim());

        if (IsProduction(environment) && IsLocalhostConnection(connectionString))
        {
            throw new InvalidOperationException(
                "Production is trying to use a local PostgreSQL connection. " +
                "Configure Render Environment variable DATABASE_URL or ConnectionStrings__DefaultConnection with the Neon connection string.");
        }

        return connectionString;
    }

    private static string Normalize(string value)
    {
        if (value.StartsWith("postgresql://", StringComparison.OrdinalIgnoreCase) ||
            value.StartsWith("postgres://", StringComparison.OrdinalIgnoreCase))
        {
            return ConvertPostgresUrlToNpgsql(value);
        }

        return value;
    }

    private static string ConvertPostgresUrlToNpgsql(string url)
    {
        var uri = new Uri(url);

        var userInfo = uri.UserInfo.Split(':', 2);
        var username = Uri.UnescapeDataString(userInfo.ElementAtOrDefault(0) ?? string.Empty);
        var password = Uri.UnescapeDataString(userInfo.ElementAtOrDefault(1) ?? string.Empty);

        var database = uri.AbsolutePath.TrimStart('/');

        var query = ParseQuery(uri.Query);

        var sslMode = query.TryGetValue("sslmode", out var sslModeValue)
            ? sslModeValue
            : "require";

        var npgsqlSslMode = sslMode.Equals("disable", StringComparison.OrdinalIgnoreCase)
            ? "Disable"
            : "Require";

        var port = uri.IsDefaultPort ? 5432 : uri.Port;

        return
            $"Host={uri.Host};" +
            $"Port={port};" +
            $"Database={database};" +
            $"Username={username};" +
            $"Password={password};" +
            $"SSL Mode={npgsqlSslMode};" +
            "Trust Server Certificate=true;" +
            "Timeout=30;" +
            "Command Timeout=30;";
    }

    private static Dictionary<string, string> ParseQuery(string query)
    {
        var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        if (string.IsNullOrWhiteSpace(query))
        {
            return result;
        }

        foreach (var part in query.TrimStart('?').Split('&', StringSplitOptions.RemoveEmptyEntries))
        {
            var pieces = part.Split('=', 2);
            var key = Uri.UnescapeDataString(pieces[0]);
            var value = pieces.Length > 1 ? Uri.UnescapeDataString(pieces[1]) : string.Empty;
            result[key] = value;
        }

        return result;
    }

    private static bool IsProduction(string environment)
    {
        return environment.Equals("Production", StringComparison.OrdinalIgnoreCase);
    }

    private static bool IsLocalhostConnection(string connectionString)
    {
        return connectionString.Contains("localhost", StringComparison.OrdinalIgnoreCase) ||
               connectionString.Contains("127.0.0.1", StringComparison.OrdinalIgnoreCase) ||
               connectionString.Contains("Host=.;", StringComparison.OrdinalIgnoreCase);
    }
}
