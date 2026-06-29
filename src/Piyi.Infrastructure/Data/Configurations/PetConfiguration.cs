using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class PetConfiguration : BaseEntityConfiguration<Pet>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Pet> builder)
    {
        builder.ToTable("Pets");
        builder.Property(x => x.Name).HasMaxLength(100).IsRequired();
        builder.Property(x => x.ApproximateAge).HasMaxLength(50);
        builder.Property(x => x.Color).HasMaxLength(100);
        builder.Property(x => x.MicrochipNumber).HasMaxLength(100);
        builder.Property(x => x.WeightKg).HasPrecision(6, 2);
        builder.Property(x => x.Sex).HasConversion<string>().HasMaxLength(20).IsRequired();
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(30).IsRequired();
        builder.HasOne(x => x.User).WithMany(x => x.Pets).HasForeignKey(x => x.UserId);
        builder.HasOne(x => x.Species).WithMany(x => x.Pets).HasForeignKey(x => x.SpeciesId);
        builder.HasOne(x => x.Breed).WithMany(x => x.Pets).HasForeignKey(x => x.BreedId).OnDelete(DeleteBehavior.SetNull);
        builder.HasIndex(x => x.UserId);
    }
}
