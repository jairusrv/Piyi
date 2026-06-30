namespace Piyi.Contracts.Businesses;

public sealed class UpdateBusinessSchedulesRequest
{
    public IReadOnlyList<BusinessScheduleItemRequest> Schedules { get; set; } = [];
}

public sealed class BusinessScheduleItemRequest
{
    public int DayOfWeek { get; set; }

    public TimeOnly? OpensAt { get; set; }

    public TimeOnly? ClosesAt { get; set; }

    public bool IsClosed { get; set; }
}
