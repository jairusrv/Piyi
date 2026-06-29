using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class AuthProviderConfiguration : BaseEntityConfiguration<AuthProvider>
{
    protected override void ConfigureEntity(EntityTypeBuilder<AuthProvider> builder)
    {
        builder.ToTable("AuthProviders");
        builder.Property(x => x.ProviderType).HasConversion<string>().HasMaxLength(30).IsRequired();
        builder.Property(x => x.ProviderUserId).HasMaxLength(250).IsRequired();
        builder.HasIndex(x => new { x.ProviderType, x.ProviderUserId }).IsUnique();
        builder.HasOne(x => x.User).WithMany(x => x.AuthProviders).HasForeignKey(x => x.UserId);
    }
}
