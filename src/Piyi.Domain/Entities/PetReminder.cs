using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public class PetReminder : BaseEntity
{
    public Guid PetId { get; set; }
    public string Title { get; set; } = string.Empty;
    public ReminderType Type { get; set; } = ReminderType.Other;
    public DateTimeOffset ReminderDate { get; set; }
    public RepeatType RepeatType { get; set; } = RepeatType.None;
    public bool IsCompleted { get; set; }
    public string? Notes { get; set; }

    public Pet Pet { get; set; } = null!;
}
