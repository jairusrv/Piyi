using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessServiceConfiguration : BaseEntityConfiguration<BusinessService>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessService> builder)
    {
        builder.ToTable("BusinessServices");
        builder.Property(x => x.Name).HasMaxLength(150).IsRequired();
        builder.Property(x => x.PriceFrom).HasPrecision(10, 2);
        builder.Property(x => x.PriceTo).HasPrecision(10, 2);
        builder.HasOne(x => x.Business).WithMany(x => x.Services).HasForeignKey(x => x.BusinessId);
    }
}
