using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class LostPetConfiguration : BaseEntityConfiguration<LostPet>
{
    protected override void ConfigureEntity(EntityTypeBuilder<LostPet> builder)
    {
        builder.ToTable("LostPets");
        builder.Property(x => x.Title).HasMaxLength(150).IsRequired();
        builder.Property(x => x.LastSeenLatitude).HasPrecision(10, 7);
        builder.Property(x => x.LastSeenLongitude).HasPrecision(10, 7);
        builder.Property(x => x.RewardAmount).HasPrecision(10, 2);
        builder.Property(x => x.Status).HasConversion<string>().HasMaxLength(30).IsRequired();
        builder.HasOne(x => x.Pet).WithMany(x => x.LostPetReports).HasForeignKey(x => x.PetId);
        builder.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId);
        builder.HasIndex(x => x.Status);
        builder.HasIndex(x => new { x.LastSeenLatitude, x.LastSeenLongitude });
    }
}
