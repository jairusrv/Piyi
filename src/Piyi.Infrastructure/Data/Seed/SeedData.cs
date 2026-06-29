using Microsoft.EntityFrameworkCore;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Seed;

public static class SeedData
{
    public static async Task SeedAsync(PiyiDbContext context, CancellationToken cancellationToken = default)
    {
        await SeedSpeciesAsync(context, cancellationToken);
        await SeedBusinessTypesAsync(context, cancellationToken);
    }

    private static async Task SeedSpeciesAsync(PiyiDbContext context, CancellationToken cancellationToken)
    {
        if (await context.Species.AnyAsync(cancellationToken))
        {
            return;
        }

        context.Species.AddRange(
            new Species { Code = "DOG", Name = "Perro", Icon = "dog", SortOrder = 1 },
            new Species { Code = "CAT", Name = "Gato", Icon = "cat", SortOrder = 2 },
            new Species { Code = "OTHER", Name = "Otro", Icon = "paw", SortOrder = 99 }
        );

        await context.SaveChangesAsync(cancellationToken);
    }

    private static async Task SeedBusinessTypesAsync(PiyiDbContext context, CancellationToken cancellationToken)
    {
        if (await context.BusinessTypes.AnyAsync(cancellationToken))
        {
            return;
        }

        context.BusinessTypes.AddRange(
            new BusinessType { Code = "VETERINARY", Name = "Veterinaria", Icon = "medical", SortOrder = 1 },
            new BusinessType { Code = "GROOMING", Name = "Grooming", Icon = "scissors", SortOrder = 2 },
            new BusinessType { Code = "PET_SHOP", Name = "Tienda", Icon = "store", SortOrder = 3 },
            new BusinessType { Code = "HOTEL", Name = "Hotel", Icon = "hotel", SortOrder = 4 },
            new BusinessType { Code = "WALKER", Name = "Paseador", Icon = "walk", SortOrder = 5 },
            new BusinessType { Code = "TRAINER", Name = "Entrenador", Icon = "training", SortOrder = 6 },
            new BusinessType { Code = "SHELTER", Name = "Refugio", Icon = "home", SortOrder = 7 }
        );

        await context.SaveChangesAsync(cancellationToken);
    }
}
