using Piyi.Domain.Common;

namespace Piyi.Domain.Entities;

public class BusinessSchedule : BaseEntity
{
    public Guid BusinessId { get; set; }
    public int DayOfWeek { get; set; }
    public TimeOnly? OpensAt { get; set; }
    public TimeOnly? ClosesAt { get; set; }
    public bool IsClosed { get; set; }

    public Business Business { get; set; } = null!;
}
