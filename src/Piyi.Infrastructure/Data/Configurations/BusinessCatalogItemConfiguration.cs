using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessCatalogItemConfiguration : IEntityTypeConfiguration<BusinessCatalogItem>
{
    public void Configure(EntityTypeBuilder<BusinessCatalogItem> builder)
    {
        builder.ToTable("BusinessCatalogItems");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
            .HasMaxLength(180)
            .IsRequired();

        builder.Property(x => x.Description)
            .HasMaxLength(2000);

        builder.Property(x => x.Category)
            .HasMaxLength(120);

        builder.Property(x => x.Brand)
            .HasMaxLength(120);

        builder.Property(x => x.Barcode)
            .HasMaxLength(80);

        builder.Property(x => x.Sku)
            .HasMaxLength(80);

        builder.Property(x => x.Currency)
            .HasMaxLength(10)
            .HasDefaultValue("CRC");

        builder.Property(x => x.PhotoUrl)
            .HasMaxLength(1000);

        builder.Property(x => x.PetSpecies)
            .HasMaxLength(120);

        builder.Property(x => x.BreedTarget)
            .HasMaxLength(120);

        builder.Property(x => x.AgeTarget)
            .HasMaxLength(120);

        builder.Property(x => x.WeightTarget)
            .HasMaxLength(120);

        builder.Property(x => x.Tags)
            .HasMaxLength(1000);

        builder.Property(x => x.Notes)
            .HasMaxLength(1000);

        builder.HasOne(x => x.Business)
            .WithMany()
            .HasForeignKey(x => x.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.BusinessId);
        builder.HasIndex(x => x.Type);
        builder.HasIndex(x => x.Category);
        builder.HasIndex(x => x.Brand);
        builder.HasIndex(x => x.Barcode);
        builder.HasIndex(x => x.Sku);
        builder.HasIndex(x => x.IsAvailable);
        builder.HasIndex(x => x.IsFeatured);
        builder.HasIndex(x => x.IsDeleted);
    }
}
