using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class ReviewConfiguration : IEntityTypeConfiguration<Review>
{
    public void Configure(EntityTypeBuilder<Review> builder)
    {
        builder.ToTable("Reviews", table =>
        {
            table.HasCheckConstraint("CK_Reviews_Rating", "\"Rating\" >= 1 AND \"Rating\" <= 5");
        });

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Comment)
            .HasMaxLength(1000);

        builder.Property(x => x.Rating)
            .IsRequired();

        builder.Property(x => x.IsApproved)
            .HasDefaultValue(false);

        builder.HasOne(x => x.Business)
            .WithMany(x => x.Reviews)
            .HasForeignKey(x => x.BusinessId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.User)
            .WithMany(x => x.Reviews)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
