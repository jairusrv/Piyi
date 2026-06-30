using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class LostPetSightingConfiguration : IEntityTypeConfiguration<LostPetSighting>
{
    public void Configure(EntityTypeBuilder<LostPetSighting> builder)
    {
        builder.ToTable("LostPetSightings");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Latitude)
            .HasPrecision(10, 7)
            .IsRequired();

        builder.Property(x => x.Longitude)
            .HasPrecision(10, 7)
            .IsRequired();

        builder.Property(x => x.Address)
            .HasMaxLength(500);

        builder.Property(x => x.Observation)
            .HasMaxLength(1000);

        builder.Property(x => x.PhotoUrl)
            .HasMaxLength(1000);

        builder.Property(x => x.Status)
            .HasConversion<string>()
            .HasMaxLength(40)
            .IsRequired();

        builder.HasOne(x => x.LostPet)
            .WithMany()
            .HasForeignKey(x => x.LostPetId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasIndex(x => x.LostPetId);
        builder.HasIndex(x => x.Status);
        builder.HasIndex(x => new { x.Latitude, x.Longitude });
    }
}
