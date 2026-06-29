using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessTypeConfiguration : BaseEntityConfiguration<BusinessType>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessType> builder)
    {
        builder.ToTable("BusinessTypes");
        builder.Property(x => x.Name).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Code).HasMaxLength(50).IsRequired();
        builder.HasIndex(x => x.Code).IsUnique();
    }
}
