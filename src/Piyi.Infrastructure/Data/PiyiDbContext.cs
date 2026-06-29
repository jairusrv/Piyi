using Microsoft.EntityFrameworkCore;
using Piyi.Domain.Common;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data;

public class PiyiDbContext(DbContextOptions<PiyiDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<AuthProvider> AuthProviders => Set<AuthProvider>();
    public DbSet<Pet> Pets => Set<Pet>();
    public DbSet<Species> Species => Set<Species>();
    public DbSet<Breed> Breeds => Set<Breed>();
    public DbSet<PetQrCode> PetQrCodes => Set<PetQrCode>();
    public DbSet<PetVaccine> PetVaccines => Set<PetVaccine>();
    public DbSet<PetReminder> PetReminders => Set<PetReminder>();
    public DbSet<Business> Businesses => Set<Business>();
    public DbSet<BusinessType> BusinessTypes => Set<BusinessType>();
    public DbSet<BusinessPhoto> BusinessPhotos => Set<BusinessPhoto>();
    public DbSet<BusinessService> BusinessServices => Set<BusinessService>();
    public DbSet<BusinessSchedule> BusinessSchedules => Set<BusinessSchedule>();
    public DbSet<Review> Reviews => Set<Review>();
    public DbSet<LostPet> LostPets => Set<LostPet>();
    public DbSet<LostPetPhoto> LostPetPhotos => Set<LostPetPhoto>();
    public DbSet<Subscription> Subscriptions => Set<Subscription>();
    public DbSet<AdEvent> AdEvents => Set<AdEvent>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(PiyiDbContext).Assembly);
        base.OnModelCreating(modelBuilder);
    }

    public override int SaveChanges()
    {
        ApplyAuditData();
        return base.SaveChanges();
    }

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        ApplyAuditData();
        return base.SaveChangesAsync(cancellationToken);
    }

    private void ApplyAuditData()
    {
        var entries = ChangeTracker.Entries<BaseEntity>();
        var now = DateTimeOffset.UtcNow;

        foreach (var entry in entries)
        {
            if (entry.State == EntityState.Added)
            {
                entry.Entity.CreatedAt = now;
            }

            if (entry.State == EntityState.Modified)
            {
                entry.Entity.UpdatedAt = now;
            }
        }
    }
}
