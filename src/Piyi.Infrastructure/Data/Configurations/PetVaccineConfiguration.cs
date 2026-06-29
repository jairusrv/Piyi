using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class PetVaccineConfiguration : BaseEntityConfiguration<PetVaccine>
{
    protected override void ConfigureEntity(EntityTypeBuilder<PetVaccine> builder)
    {
        builder.ToTable("PetVaccines");
        builder.Property(x => x.Name).HasMaxLength(150).IsRequired();
        builder.HasOne(x => x.Pet).WithMany(x => x.Vaccines).HasForeignKey(x => x.PetId);
    }
}
