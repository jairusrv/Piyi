namespace Piyi.Contracts.Businesses;

public sealed class BusinessScheduleResponse
{
    public Guid Id { get; set; }

    public int DayOfWeek { get; set; }

    public TimeOnly? OpensAt { get; set; }

    public TimeOnly? ClosesAt { get; set; }

    public bool IsClosed { get; set; }
}
