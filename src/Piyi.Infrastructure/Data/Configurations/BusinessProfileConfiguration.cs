using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessProfileConfiguration : IEntityTypeConfiguration<BusinessProfile>
{
    public void Configure(EntityTypeBuilder<BusinessProfile> builder)
    {
        builder.ToTable("BusinessProfiles");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.BannerUrl).HasMaxLength(1000);
        builder.Property(x => x.ShortDescription).HasMaxLength(500);
        builder.Property(x => x.LongDescription).HasMaxLength(3000);
        builder.Property(x => x.Story).HasMaxLength(3000);
        builder.Property(x => x.Mission).HasMaxLength(2000);
        builder.Property(x => x.Specialties).HasMaxLength(1000);
        builder.Property(x => x.Languages).HasMaxLength(500);

        builder.Property(x => x.WebsiteUrl).HasMaxLength(1000);
        builder.Property(x => x.FacebookUrl).HasMaxLength(1000);
        builder.Property(x => x.InstagramUrl).HasMaxLength(1000);
        builder.Property(x => x.TikTokUrl).HasMaxLength(1000);
        builder.Property(x => x.YouTubeUrl).HasMaxLength(1000);

        builder.Property(x => x.GalleryJson).HasColumnType("jsonb");

        builder.HasOne(x => x.Business)
            .WithOne()
            .HasForeignKey<BusinessProfile>(x => x.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.BusinessId).IsUnique();
        builder.HasIndex(x => x.IsDeleted);
    }
}
