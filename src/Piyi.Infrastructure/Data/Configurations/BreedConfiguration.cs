using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BreedConfiguration : BaseEntityConfiguration<Breed>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Breed> builder)
    {
        builder.ToTable("Breeds");
        builder.Property(x => x.Name).HasMaxLength(120).IsRequired();
        builder.Property(x => x.Size).HasMaxLength(40);
        builder.HasOne(x => x.Species).WithMany(x => x.Breeds).HasForeignKey(x => x.SpeciesId);
    }
}
