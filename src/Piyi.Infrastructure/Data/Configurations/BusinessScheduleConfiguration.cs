using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Piyi.Domain.Entities;

namespace Piyi.Infrastructure.Data.Configurations;

public sealed class BusinessScheduleConfiguration : BaseEntityConfiguration<BusinessSchedule>
{
    protected override void ConfigureEntity(EntityTypeBuilder<BusinessSchedule> builder)
    {
        builder.ToTable("BusinessSchedules");
        builder.HasOne(x => x.Business).WithMany(x => x.Schedules).HasForeignKey(x => x.BusinessId);
    }
}
