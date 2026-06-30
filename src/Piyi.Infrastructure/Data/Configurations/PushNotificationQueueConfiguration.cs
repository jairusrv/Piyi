using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class PushNotificationQueueConfiguration : IEntityTypeConfiguration<PushNotificationQueue>
{
    public void Configure(EntityTypeBuilder<PushNotificationQueue> builder)
    {
        builder.ToTable("PushNotificationQueue");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.PushToken)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(x => x.Title)
            .HasMaxLength(180)
            .IsRequired();

        builder.Property(x => x.Body)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(x => x.DataJson)
            .HasColumnType("jsonb");

        builder.Property(x => x.Status)
            .HasConversion<string>()
            .HasMaxLength(60)
            .IsRequired();

        builder.Property(x => x.LastError)
            .HasMaxLength(2000);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.UserDevice)
            .WithMany()
            .HasForeignKey(x => x.UserDeviceId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasOne(x => x.UserNotification)
            .WithMany()
            .HasForeignKey(x => x.UserNotificationId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.Status);
        builder.HasIndex(x => x.NextAttemptAt);
    }
}
