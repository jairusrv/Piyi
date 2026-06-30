using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class UserNotificationConfiguration : IEntityTypeConfiguration<UserNotification>
{
    public void Configure(EntityTypeBuilder<UserNotification> builder)
    {
        builder.ToTable("UserNotifications");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Type)
            .HasConversion<string>()
            .HasMaxLength(60)
            .IsRequired();

        builder.Property(x => x.Title)
            .HasMaxLength(180)
            .IsRequired();

        builder.Property(x => x.Body)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(x => x.DataJson)
            .HasColumnType("jsonb");

        builder.Property(x => x.IsRead)
            .HasDefaultValue(false);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.IsRead);
        builder.HasIndex(x => x.CreatedAt);
    }
}
