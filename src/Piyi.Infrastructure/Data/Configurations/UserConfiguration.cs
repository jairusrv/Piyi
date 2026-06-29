using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("Users");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.FirstName)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(x => x.LastName)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(x => x.Email)
            .HasMaxLength(180)
            .IsRequired();

        builder.HasIndex(x => x.Email)
            .IsUnique();

        builder.Property(x => x.PhoneNumber)
            .HasMaxLength(40);

        builder.Property(x => x.PasswordHash)
            .HasMaxLength(500)
            .IsRequired();

        builder.Property(x => x.PhotoUrl)
            .HasMaxLength(1000);

        builder.Property(x => x.Language)
            .HasMaxLength(20);

        builder.Property(x => x.Country)
            .HasMaxLength(80);

        builder.Property(x => x.TimeZone)
            .HasMaxLength(80);

        builder.Property(x => x.Role)
            .HasConversion<string>()
            .HasMaxLength(40)
            .IsRequired();

        builder.Property(x => x.IsActive)
            .HasDefaultValue(true);

        builder.Property(x => x.EmailVerified)
            .HasDefaultValue(false);

        builder.Property(x => x.PhoneVerified)
            .HasDefaultValue(false);
    }
}
