using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class UserDeviceConfiguration : IEntityTypeConfiguration<UserDevice>
{
    public void Configure(EntityTypeBuilder<UserDevice> builder)
    {
        builder.ToTable("UserDevices");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.DeviceIdentifier)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(x => x.Platform)
            .HasConversion<string>()
            .HasMaxLength(40)
            .IsRequired();

        builder.Property(x => x.PushToken)
            .HasMaxLength(1000)
            .IsRequired();

        builder.Property(x => x.DeviceName)
            .HasMaxLength(200);

        builder.Property(x => x.AppVersion)
            .HasMaxLength(80);

        builder.Property(x => x.IsActive)
            .HasDefaultValue(true);

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.UserId);
        builder.HasIndex(x => x.PushToken);
        builder.HasIndex(x => new { x.UserId, x.DeviceIdentifier }).IsUnique();
    }
}
