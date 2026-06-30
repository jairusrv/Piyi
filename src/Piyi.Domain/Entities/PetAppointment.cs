using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public sealed class PetAppointment : BaseEntity
{
    public Guid PetId { get; set; }

    public Guid? BusinessId { get; set; }

    public AppointmentType Type { get; set; } = AppointmentType.Other;

    public AppointmentStatus Status { get; set; } = AppointmentStatus.Scheduled;

    public string Title { get; set; } = string.Empty;

    public DateTimeOffset AppointmentDateTime { get; set; }

    public string? PlaceName { get; set; }

    public string? Address { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? ContactName { get; set; }

    public string? ContactPhone { get; set; }

    public string? Notes { get; set; }

    public bool ReminderEnabled { get; set; } = true;

    public DateTimeOffset? ReminderAt { get; set; }

    public Pet Pet { get; set; } = default!;

    public Business? Business { get; set; }
}
