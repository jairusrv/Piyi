using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class ReviewConfiguration : BaseEntityConfiguration<Review>
{
    protected override void ConfigureEntity(EntityTypeBuilder<Review> builder)
    {
        builder.ToTable("Reviews");
        builder.Property(x => x.Rating).IsRequired();
        builder.HasCheckConstraint("CK_Reviews_Rating", "\"Rating\" >= 1 AND \"Rating\" <= 5");
        builder.HasOne(x => x.Business).WithMany(x => x.Reviews).HasForeignKey(x => x.BusinessId);
        builder.HasOne(x => x.User).WithMany(x => x.Reviews).HasForeignKey(x => x.UserId);
    }
}
