using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class AdEventConfiguration : BaseEntityConfiguration<AdEvent>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AdEvent> builder)
    {
        builder.ToTable("AdEvents");
        builder.Property(x => x.Placement).HasMaxLength(100).IsRequired();
        builder.Property(x => x.AdProvider).HasMaxLength(50).IsRequired();
        builder.Property(x => x.EventType).HasConversion<string>().HasMaxLength(30).IsRequired();
        builder.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.SetNull);
    }
}
