namespace Piyi.Contracts.LostPets;

public sealed class LostPetSightingResponse
{
    public Guid Id { get; set; }

    public Guid LostPetId { get; set; }

    public Guid? UserId { get; set; }

    public decimal Latitude { get; set; }

    public decimal Longitude { get; set; }

    public string? Address { get; set; }

    public string? Observation { get; set; }

    public string? PhotoUrl { get; set; }

    public string Status { get; set; } = string.Empty;

    public DateTimeOffset CreatedAt { get; set; }
}
