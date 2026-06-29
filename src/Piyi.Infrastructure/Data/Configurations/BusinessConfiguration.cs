using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessConfiguration : BaseEntityConfiguration<Business>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Business> builder)
    {
        builder.ToTable("Businesses");
        builder.Property(x => x.Name).HasMaxLength(150).IsRequired();
        builder.Property(x => x.Phone).HasMaxLength(30);
        builder.Property(x => x.WhatsApp).HasMaxLength(30);
        builder.Property(x => x.Email).HasMaxLength(150);
        builder.Property(x => x.Country).HasMaxLength(80).IsRequired();
        builder.Property(x => x.Region).HasMaxLength(80);
        builder.Property(x => x.City).HasMaxLength(80);
        builder.Property(x => x.Latitude).HasPrecision(10, 7);
        builder.Property(x => x.Longitude).HasPrecision(10, 7);
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(30).IsRequired();
        builder.HasOne(x => x.OwnerUser).WithMany(x => x.Businesses).HasForeignKey(x => x.OwnerUserId).OnDelete(DeleteBehavior.SetNull);
        builder.HasOne(x => x.BusinessType).WithMany(x => x.Businesses).HasForeignKey(x => x.BusinessTypeId);
        builder.HasIndex(x => x.BusinessTypeId);
        builder.HasIndex(x => new { x.Latitude, x.Longitude });
    }
}
