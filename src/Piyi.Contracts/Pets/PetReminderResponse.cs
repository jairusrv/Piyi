namespace Piyi.Contracts.Pets;

public sealed class PetReminderResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public DateTimeOffset ReminderDate { get; set; }

    public string RepeatType { get; set; } = string.Empty;

    public bool IsCompleted { get; set; }

    public string? Notes { get; set; }

    public DateTimeOffset CreatedAt { get; set; }
}
