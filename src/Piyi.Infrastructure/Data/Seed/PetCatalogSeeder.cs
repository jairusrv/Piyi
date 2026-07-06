using System.Data;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;

namespace Piyi.Infrastructure.Data.Seed;

public static class PetCatalogSeeder
{
    public static async Task SeedAsync(PiyiDbContext dbContext, CancellationToken cancellationToken = default)
    {
        var seedPath = Path.Combine(AppContext.BaseDirectory, "Data", "Seed", "pet_catalog_seed.json");
        if (!File.Exists(seedPath))
        {
            seedPath = Path.Combine(Directory.GetCurrentDirectory(), "src", "Piyi.Infrastructure", "Data", "Seed", "pet_catalog_seed.json");
        }

        if (!File.Exists(seedPath))
        {
            return;
        }

        var json = await File.ReadAllTextAsync(seedPath, cancellationToken);
        var data = JsonSerializer.Deserialize<Dictionary<string, string[]>>(json);

        if (data is null || data.Count == 0)
        {
            return;
        }

        var connection = dbContext.Database.GetDbConnection();

        if (connection.State != ConnectionState.Open)
        {
            await connection.OpenAsync(cancellationToken);
        }

        await EnsurePgCryptoAsync(connection, cancellationToken);

        var speciesTable = await FindTableAsync(connection, "Species", cancellationToken);
        var breedsTable = await FindTableAsync(connection, "Breeds", cancellationToken);

        if (speciesTable is null || breedsTable is null)
        {
            return;
        }

        var speciesColumns = await GetColumnsAsync(connection, speciesTable.Value, cancellationToken);
        var breedColumns = await GetColumnsAsync(connection, breedsTable.Value, cancellationToken);

        var sort = 1;
        foreach (var species in data.Keys)
        {
            await InsertSpeciesAsync(connection, speciesTable.Value, speciesColumns, species, sort++, cancellationToken);
        }

        var breedSort = 1;
        foreach (var pair in data)
        {
            foreach (var breed in pair.Value)
            {
                await InsertBreedAsync(connection, speciesTable.Value, breedsTable.Value, speciesColumns, breedColumns, pair.Key, breed, breedSort++, cancellationToken);
            }
        }
    }

    private static async Task EnsurePgCryptoAsync(System.Data.Common.DbConnection connection, CancellationToken cancellationToken)
    {
        try
        {
            await using var cmd = connection.CreateCommand();
            cmd.CommandText = "create extension if not exists pgcrypto;";
            await cmd.ExecuteNonQueryAsync(cancellationToken);
        }
        catch
        {
            // Some managed providers may restrict CREATE EXTENSION. If so, we continue and use client GUIDs.
        }
    }

    private static async Task<(string Schema, string Name)?> FindTableAsync(System.Data.Common.DbConnection connection, string tableName, CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = """
            select table_schema, table_name
            from information_schema.tables
            where table_type = 'BASE TABLE'
              and lower(table_name) = lower(@tableName)
            order by case when table_schema = 'public' then 0 else 1 end
            limit 1;
        """;
        Add(command, "tableName", tableName);

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return (reader.GetString(0), reader.GetString(1));
    }

    private static async Task<HashSet<string>> GetColumnsAsync(System.Data.Common.DbConnection connection, (string Schema, string Name) table, CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = """
            select column_name
            from information_schema.columns
            where table_schema = @schema
              and table_name = @table;
        """;
        Add(command, "schema", table.Schema);
        Add(command, "table", table.Name);

        var columns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            columns.Add(reader.GetString(0));
        }

        return columns;
    }

    private static async Task InsertSpeciesAsync(System.Data.Common.DbConnection connection, (string Schema, string Name) table, HashSet<string> columns, string name, int sortOrder, CancellationToken cancellationToken)
    {
        if (!columns.Contains("Name")) return;

        await using var exists = connection.CreateCommand();
        exists.CommandText = $"""select 1 from "{table.Schema}"."{table.Name}" where lower("Name") = lower(@name) limit 1;""";
        Add(exists, "name", name);

        if (await exists.ExecuteScalarAsync(cancellationToken) is not null) return;

        var insertColumns = new List<string>();
        var insertValues = new List<string>();
        AddGuid(columns, insertColumns, insertValues, "Id", "@id");
        AddColumn(columns, insertColumns, insertValues, "Name", "@name");
        AddColumn(columns, insertColumns, insertValues, "Description", "@description");
        AddBool(columns, insertColumns, insertValues, "IsActive");
        AddBool(columns, insertColumns, insertValues, "IsEnabled");
        AddColumn(columns, insertColumns, insertValues, "SortOrder", "@sortOrder");
        AddTimestamp(columns, insertColumns, insertValues, "CreatedAt");
        AddTimestamp(columns, insertColumns, insertValues, "CreatedAtUtc");
        AddTimestamp(columns, insertColumns, insertValues, "UpdatedAt");
        AddTimestamp(columns, insertColumns, insertValues, "UpdatedAtUtc");

        await using var insert = connection.CreateCommand();
        insert.CommandText = $"""insert into "{table.Schema}"."{table.Name}" ({string.Join(", ", insertColumns)}) values ({string.Join(", ", insertValues)});""";
        Add(insert, "id", Guid.NewGuid());
        Add(insert, "name", name);
        Add(insert, "description", $"Especie de mascota: {name}");
        Add(insert, "sortOrder", sortOrder);
        await insert.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task InsertBreedAsync(System.Data.Common.DbConnection connection, (string Schema, string Name) speciesTable, (string Schema, string Name) breedTable, HashSet<string> speciesColumns, HashSet<string> breedColumns, string species, string breed, int sortOrder, CancellationToken cancellationToken)
    {
        if (!breedColumns.Contains("Name")) return;

        object? speciesId = null;
        var breedSpeciesIdColumn = First(breedColumns, "SpeciesId", "PetSpeciesId");

        if (speciesColumns.Contains("Id"))
        {
            await using var speciesCommand = connection.CreateCommand();
            speciesCommand.CommandText = $"""select "Id" from "{speciesTable.Schema}"."{speciesTable.Name}" where lower("Name") = lower(@name) limit 1;""";
            Add(speciesCommand, "name", species);
            speciesId = await speciesCommand.ExecuteScalarAsync(cancellationToken);
        }

        await using var exists = connection.CreateCommand();
        if (breedSpeciesIdColumn is not null && speciesId is not null)
        {
            exists.CommandText = $"""select 1 from "{breedTable.Schema}"."{breedTable.Name}" where lower("Name") = lower(@name) and "{breedSpeciesIdColumn}" = @speciesId limit 1;""";
            Add(exists, "speciesId", speciesId);
        }
        else if (breedColumns.Contains("SpeciesName"))
        {
            exists.CommandText = $"""select 1 from "{breedTable.Schema}"."{breedTable.Name}" where lower("Name") = lower(@name) and lower("SpeciesName") = lower(@speciesName) limit 1;""";
            Add(exists, "speciesName", species);
        }
        else
        {
            exists.CommandText = $"""select 1 from "{breedTable.Schema}"."{breedTable.Name}" where lower("Name") = lower(@name) limit 1;""";
        }
        Add(exists, "name", breed);

        if (await exists.ExecuteScalarAsync(cancellationToken) is not null) return;

        var insertColumns = new List<string>();
        var insertValues = new List<string>();
        AddGuid(breedColumns, insertColumns, insertValues, "Id", "@id");
        AddColumn(breedColumns, insertColumns, insertValues, "Name", "@name");
        AddColumn(breedColumns, insertColumns, insertValues, "Description", "@description");
        if (breedSpeciesIdColumn is not null && speciesId is not null) AddColumn(breedColumns, insertColumns, insertValues, breedSpeciesIdColumn, "@speciesId");
        AddColumn(breedColumns, insertColumns, insertValues, "SpeciesName", "@speciesName");
        AddBool(breedColumns, insertColumns, insertValues, "IsActive");
        AddBool(breedColumns, insertColumns, insertValues, "IsEnabled");
        AddColumn(breedColumns, insertColumns, insertValues, "SortOrder", "@sortOrder");
        AddTimestamp(breedColumns, insertColumns, insertValues, "CreatedAt");
        AddTimestamp(breedColumns, insertColumns, insertValues, "CreatedAtUtc");
        AddTimestamp(breedColumns, insertColumns, insertValues, "UpdatedAt");
        AddTimestamp(breedColumns, insertColumns, insertValues, "UpdatedAtUtc");

        await using var insert = connection.CreateCommand();
        insert.CommandText = $"""insert into "{breedTable.Schema}"."{breedTable.Name}" ({string.Join(", ", insertColumns)}) values ({string.Join(", ", insertValues)});""";
        Add(insert, "id", Guid.NewGuid());
        Add(insert, "name", breed);
        Add(insert, "description", $"{breed} ({species})");
        Add(insert, "speciesName", species);
        if (speciesId is not null) Add(insert, "speciesId", speciesId);
        Add(insert, "sortOrder", sortOrder);
        await insert.ExecuteNonQueryAsync(cancellationToken);
    }

    private static string? First(HashSet<string> columns, params string[] names) => names.FirstOrDefault(columns.Contains);

    private static void AddColumn(HashSet<string> columns, List<string> insertColumns, List<string> insertValues, string column, string value)
    {
        if (!columns.Contains(column)) return;
        insertColumns.Add($@"""{column}""");
        insertValues.Add(value);
    }

    private static void AddGuid(HashSet<string> columns, List<string> insertColumns, List<string> insertValues, string column, string value)
    {
        if (!columns.Contains(column)) return;
        insertColumns.Add($@"""{column}""");
        insertValues.Add(value);
    }

    private static void AddBool(HashSet<string> columns, List<string> insertColumns, List<string> insertValues, string column)
    {
        if (!columns.Contains(column)) return;
        insertColumns.Add($@"""{column}""");
        insertValues.Add("true");
    }

    private static void AddTimestamp(HashSet<string> columns, List<string> insertColumns, List<string> insertValues, string column)
    {
        if (!columns.Contains(column)) return;
        insertColumns.Add($@"""{column}""");
        insertValues.Add("now()");
    }

    private static void Add(System.Data.Common.DbCommand command, string name, object value)
    {
        var parameter = command.CreateParameter();
        parameter.ParameterName = name;
        parameter.Value = value;
        command.Parameters.Add(parameter);
    }
}
