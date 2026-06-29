using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class PetReminderConfiguration : BaseEntityConfiguration<PetReminder>
{
    protected override void ConfigureEntity(EntityTypeBuilder<PetReminder> builder)
    {
        builder.ToTable("PetReminders");
        builder.Property(x => x.Title).HasMaxLength(150).IsRequired();
        builder.Property(x => x.Type).HasConversion<string>().HasMaxLength(40).IsRequired();
        builder.Property(x => x.RepeatType).HasConversion<string>().HasMaxLength(40).IsRequired();
        builder.HasOne(x => x.Pet).WithMany(x => x.Reminders).HasForeignKey(x => x.PetId);
    }
}
