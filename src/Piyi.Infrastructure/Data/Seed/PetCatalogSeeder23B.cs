using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Data.Seed;

public static class PetCatalogSeeder23B
{
    private sealed class SpeciesSeed
    {
        public string Name { get; set; } = string.Empty;

        public string? Icon { get; set; }

        public int SortOrder { get; set; }

        public List<List<string>> Breeds { get; set; } = [];
    }

    public static async Task SeedAsync(
        PiyiDbContext dbContext,
        CancellationToken cancellationToken = default)
    {
        var seedPath = ResolveSeedPath();

        if (seedPath is null)
        {
            throw new FileNotFoundException(
                "No se encontró Data/Seed/pet_catalog_23B.json.");
        }

        var json = await File.ReadAllTextAsync(seedPath, cancellationToken);

        var catalog =
            JsonSerializer.Deserialize<Dictionary<string, SpeciesSeed>>(
                json,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

        if (catalog is null || catalog.Count == 0)
        {
            throw new InvalidOperationException(
                "El catálogo de especies y razas está vacío.");
        }

        var existingSpecies = await dbContext.Species
            .IgnoreQueryFilters()
            .ToListAsync(cancellationToken);

        foreach (var item in catalog.OrderBy(x => x.Value.SortOrder))
        {
            var code = item.Key.Trim();
            var seed = item.Value;

            var species = existingSpecies.FirstOrDefault(
                x => string.Equals(
                    x.Code,
                    code,
                    StringComparison.OrdinalIgnoreCase));

            if (species is null)
            {
                species = new Species
                {
                    Name = seed.Name.Trim(),
                    Code = code,
                    Icon = seed.Icon,
                    SortOrder = seed.SortOrder,
                    IsActive = true,
                    IsDeleted = false
                };

                dbContext.Species.Add(species);
                existingSpecies.Add(species);
            }
            else
            {
                species.Name = seed.Name.Trim();
                species.Icon = seed.Icon;
                species.SortOrder = seed.SortOrder;
                species.IsActive = true;
                species.IsDeleted = false;
                species.DeletedAt = null;
                species.DeletedBy = null;
            }
        }

        await dbContext.SaveChangesAsync(cancellationToken);

        var speciesIds = existingSpecies
            .Select(x => x.Id)
            .ToArray();

        var existingBreeds = await dbContext.Breeds
            .IgnoreQueryFilters()
            .Where(x => speciesIds.Contains(x.SpeciesId))
            .ToListAsync(cancellationToken);

        foreach (var item in catalog)
        {
            var species = existingSpecies.First(
                x => string.Equals(
                    x.Code,
                    item.Key,
                    StringComparison.OrdinalIgnoreCase));

            foreach (var breedSeed in item.Value.Breeds)
            {
                if (breedSeed.Count == 0)
                {
                    continue;
                }

                var breedName = breedSeed[0].Trim();
                var size = breedSeed.Count > 1
                    ? breedSeed[1].Trim()
                    : null;

                var breed = existingBreeds.FirstOrDefault(
                    x =>
                        x.SpeciesId == species.Id &&
                        string.Equals(
                            x.Name,
                            breedName,
                            StringComparison.OrdinalIgnoreCase));

                if (breed is null)
                {
                    breed = new Breed
                    {
                        SpeciesId = species.Id,
                        Name = breedName,
                        Size = string.IsNullOrWhiteSpace(size)
                            ? null
                            : size,
                        IsActive = true,
                        IsDeleted = false
                    };

                    dbContext.Breeds.Add(breed);
                    existingBreeds.Add(breed);
                }
                else
                {
                    breed.Name = breedName;
                    breed.Size = string.IsNullOrWhiteSpace(size)
                        ? null
                        : size;
                    breed.IsActive = true;
                    breed.IsDeleted = false;
                    breed.DeletedAt = null;
                    breed.DeletedBy = null;
                }
            }
        }

        await dbContext.SaveChangesAsync(cancellationToken);
    }

    private static string? ResolveSeedPath()
    {
        var candidates = new[]
        {
            Path.Combine(
                AppContext.BaseDirectory,
                "Data",
                "Seed",
                "pet_catalog_23B.json"),
            Path.Combine(
                Directory.GetCurrentDirectory(),
                "Data",
                "Seed",
                "pet_catalog_23B.json"),
            Path.Combine(
                Directory.GetCurrentDirectory(),
                "src",
                "Piyi.Infrastructure",
                "Data",
                "Seed",
                "pet_catalog_23B.json")
        };

        return candidates.FirstOrDefault(File.Exists);
    }
}
