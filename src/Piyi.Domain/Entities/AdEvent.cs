using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public class AdEvent : BaseEntity
{
    public Guid? UserId { get; set; }
    public string Placement { get; set; } = string.Empty;
    public string AdProvider { get; set; } = "ADMOB";
    public AdEventType EventType { get; set; } = AdEventType.Impression;

    public User? User { get; set; }
}
