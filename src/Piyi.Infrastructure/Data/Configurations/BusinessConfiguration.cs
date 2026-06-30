using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessConfiguration : IEntityTypeConfiguration<Business>
{
    public void Configure(EntityTypeBuilder<Business> builder)
    {
        builder.ToTable("Businesses");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
            .HasMaxLength(180)
            .IsRequired();

        builder.Property(x => x.Description)
            .HasMaxLength(2000);

        builder.Property(x => x.Phone)
            .HasMaxLength(40);

        builder.Property(x => x.WhatsApp)
            .HasMaxLength(40);

        builder.Property(x => x.Email)
            .HasMaxLength(180);

        builder.Property(x => x.Website)
            .HasMaxLength(500);

        builder.Property(x => x.FacebookUrl)
            .HasMaxLength(500);

        builder.Property(x => x.InstagramUrl)
            .HasMaxLength(500);

        builder.Property(x => x.TikTokUrl)
            .HasMaxLength(500);

        builder.Property(x => x.Address)
            .HasMaxLength(500);

        builder.Property(x => x.Country)
            .HasMaxLength(100);

        builder.Property(x => x.Region)
            .HasMaxLength(100);

        builder.Property(x => x.City)
            .HasMaxLength(100);

        builder.Property(x => x.Latitude)
            .HasPrecision(10, 7);

        builder.Property(x => x.Longitude)
            .HasPrecision(10, 7);

        builder.Property(x => x.LogoUrl)
            .HasMaxLength(1000);

        builder.Property(x => x.IsVerified)
            .HasDefaultValue(false);

        builder.Property(x => x.IsActive)
            .HasDefaultValue(true);

        builder.Property(x => x.Status)
            .HasConversion<string>()
            .HasMaxLength(40)
            .IsRequired();

        builder.HasOne(x => x.OwnerUser)
            .WithMany(x => x.Businesses)
            .HasForeignKey(x => x.OwnerUserId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasOne(x => x.BusinessType)
            .WithMany(x => x.Businesses)
            .HasForeignKey(x => x.BusinessTypeId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasIndex(x => x.Name);
        builder.HasIndex(x => x.BusinessTypeId);
        builder.HasIndex(x => x.IsActive);
        builder.HasIndex(x => x.IsVerified);
        builder.HasIndex(x => new { x.Latitude, x.Longitude });
    }
}
