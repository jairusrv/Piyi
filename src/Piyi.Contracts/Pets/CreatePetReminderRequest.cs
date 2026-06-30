namespace Piyi.Contracts.Pets;

public sealed class CreatePetReminderRequest
{
    public string Title { get; set; } = string.Empty;

    public string Type { get; set; } = "Other";

    public DateTimeOffset ReminderDate { get; set; }

    public string RepeatType { get; set; } = "None";

    public string? Notes { get; set; }
}
