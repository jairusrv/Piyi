using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessReviewConfiguration : IEntityTypeConfiguration<BusinessReview>
{
    public void Configure(EntityTypeBuilder<BusinessReview> builder)
    {
        builder.ToTable("BusinessReviews");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Comment).HasMaxLength(2000);
        builder.Property(x => x.PhotosJson).HasColumnType("jsonb");
        builder.Property(x => x.BusinessReply).HasMaxLength(2000);
        builder.Property(x => x.ReportReason).HasMaxLength(1000);

        builder.HasOne(x => x.Business)
            .WithMany()
            .HasForeignKey(x => x.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.BusinessId);
        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.Rating);
        builder.HasIndex(x => x.IsApproved);
        builder.HasIndex(x => x.IsReported);
        builder.HasIndex(x => x.IsDeleted);

        builder.HasCheckConstraint("CK_BusinessReviews_Rating", "\"Rating\" >= 1 AND \"Rating\" <= 5");
    }
}
