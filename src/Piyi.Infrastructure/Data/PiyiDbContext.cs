using Microsoft.EntityFrameworkCore;
using Piyi.Domain.Common;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data;

public sealed class PiyiDbContext : DbContext
{
    public PiyiDbContext(DbContextOptions<PiyiDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<AuthProvider> AuthProviders => Set<AuthProvider>();
    public DbSet<Pet> Pets => Set<Pet>();
    public DbSet<Species> Species => Set<Species>();
    public DbSet<Breed> Breeds => Set<Breed>();
    public DbSet<PetQrCode> PetQrCodes => Set<PetQrCode>();
    public DbSet<PetVaccine> PetVaccines => Set<PetVaccine>();
    public DbSet<PetReminder> PetReminders => Set<PetReminder>();
    public DbSet<PetAppointment> PetAppointments => Set<PetAppointment>();
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

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        ApplyAuditFields();
        return base.SaveChangesAsync(cancellationToken);
    }

    public override int SaveChanges()
    {
        ApplyAuditFields();
        return base.SaveChanges();
    }

    private void ApplyAuditFields()
    {
        var now = DateTimeOffset.UtcNow;

        foreach (var entry in ChangeTracker.Entries<BaseEntity>())
        {
            if (entry.State == EntityState.Added)
            {
                if (entry.Entity.CreatedAt == default)
                    entry.Entity.CreatedAt = now;
            }

            if (entry.State == EntityState.Modified)
            {
                entry.Entity.UpdatedAt = now;
            }
        }
    }
}
