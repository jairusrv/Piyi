using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class UserSafeZoneConfiguration : IEntityTypeConfiguration<UserSafeZone>
{
    public void Configure(EntityTypeBuilder<UserSafeZone> builder)
    {
        builder.ToTable("UserSafeZones");
        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name).HasMaxLength(120).IsRequired();
        builder.Property(x => x.Address).HasMaxLength(500);
        builder.Property(x => x.District).HasMaxLength(120);
        builder.Property(x => x.City).HasMaxLength(120);
        builder.Property(x => x.Region).HasMaxLength(120);
        builder.Property(x => x.Country).HasMaxLength(120);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.IsActive);
        builder.HasIndex(x => x.IsDeleted);
    }
}
