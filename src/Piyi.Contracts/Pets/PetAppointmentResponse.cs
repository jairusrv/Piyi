namespace Piyi.Contracts.Pets;

public sealed class PetAppointmentResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public Guid? BusinessId { get; set; }

    public string? BusinessName { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public string Status { get; set; } = string.Empty;

    public DateTimeOffset AppointmentDateTime { get; set; }

    public string? PlaceName { get; set; }

    public string? Address { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? ContactName { get; set; }

    public string? ContactPhone { get; set; }

    public string? Notes { get; set; }

    public bool ReminderEnabled { get; set; }

    public DateTimeOffset? ReminderAt { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
