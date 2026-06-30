namespace Piyi.Contracts.LostPets;

public sealed class CreateLostPetSightingRequest
{
    public decimal Latitude { get; set; }

    public decimal Longitude { get; set; }

    public string? Address { get; set; }

    public string? Observation { get; set; }

    public string? PhotoUrl { get; set; }
}
