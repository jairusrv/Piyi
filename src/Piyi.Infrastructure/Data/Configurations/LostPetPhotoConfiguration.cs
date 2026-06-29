using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class LostPetPhotoConfiguration : BaseEntityConfiguration<LostPetPhoto>
{
    protected override void ConfigureEntity(EntityTypeBuilder<LostPetPhoto> builder)
    {
        builder.ToTable("LostPetPhotos");
        builder.Property(x => x.PhotoUrl).IsRequired();
        builder.HasOne(x => x.LostPet).WithMany(x => x.Photos).HasForeignKey(x => x.LostPetId);
    }
}
