namespace Piyi.Contracts.LostPets;

public sealed class LostPetListItemResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public string PetName { get; set; } = string.Empty;

    public string? PetPhotoUrl { get; set; }

    public string SpeciesName { get; set; } = string.Empty;

    public string Title { get; set; } = string.Empty;

    public string? LastSeenAddress { get; set; }

    public decimal? LastSeenLatitude { get; set; }

    public decimal? LastSeenLongitude { get; set; }

    public DateTimeOffset LostDate { get; set; }

    public string Status { get; set; } = string.Empty;
}
