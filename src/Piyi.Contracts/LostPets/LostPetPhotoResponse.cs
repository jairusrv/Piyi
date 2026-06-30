namespace Piyi.Contracts.LostPets;

public sealed class LostPetPhotoResponse
{
    public Guid Id { get; set; }

    public string PhotoUrl { get; set; } = string.Empty;

    public DateTimeOffset CreatedAt { get; set; }
}
