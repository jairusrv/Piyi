using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class PetQrCodeConfiguration : BaseEntityConfiguration<PetQrCode>
{
    protected override void ConfigureEntity(EntityTypeBuilder<PetQrCode> builder)
    {
        builder.ToTable("PetQrCodes");
        builder.Property(x => x.Code).HasMaxLength(100).IsRequired();
        builder.Property(x => x.PublicUrl).IsRequired();
        builder.HasIndex(x => x.Code).IsUnique();
        builder.HasOne(x => x.Pet).WithOne(x => x.QrCode).HasForeignKey<PetQrCode>(x => x.PetId);
    }
}
