using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessPhotoConfiguration : BaseEntityConfiguration<BusinessPhoto>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessPhoto> builder)
    {
        builder.ToTable("BusinessPhotos");
        builder.Property(x => x.PhotoUrl).IsRequired();
        builder.HasOne(x => x.Business).WithMany(x => x.Photos).HasForeignKey(x => x.BusinessId);
    }
}
