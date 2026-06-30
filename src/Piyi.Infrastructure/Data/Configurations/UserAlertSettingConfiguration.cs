using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class UserAlertSettingConfiguration : IEntityTypeConfiguration<UserAlertSetting>
{
    public void Configure(EntityTypeBuilder<UserAlertSetting> builder)
    {
        builder.ToTable("UserAlertSettings");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.LostPetAlertsEnabled)
            .HasDefaultValue(true);

        builder.Property(x => x.Latitude)
            .HasPrecision(10, 7);

        builder.Property(x => x.Longitude)
            .HasPrecision(10, 7);

        builder.Property(x => x.RadiusKm)
            .HasPrecision(8, 2)
            .HasDefaultValue(10);

        builder.Property(x => x.Country)
            .HasMaxLength(100);

        builder.Property(x => x.Region)
            .HasMaxLength(100);

        builder.Property(x => x.City)
            .HasMaxLength(100);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.UserId)
            .IsUnique();

        builder.HasIndex(x => new { x.Latitude, x.Longitude });
    }
}
