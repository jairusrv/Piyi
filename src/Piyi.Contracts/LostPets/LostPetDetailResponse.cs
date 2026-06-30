namespace Piyi.Contracts.LostPets;

public sealed class LostPetDetailResponse
{
    public Guid Id { get; set; }

    public Guid PetId { get; set; }

    public string PetName { get; set; } = string.Empty;

    public string? PetPhotoUrl { get; set; }

    public string SpeciesName { get; set; } = string.Empty;

    public string? BreedName { get; set; }

    public string? Color { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string? LastSeenAddress { get; set; }

    public decimal? LastSeenLatitude { get; set; }

    public decimal? LastSeenLongitude { get; set; }

    public DateTimeOffset LostDate { get; set; }

    public string Status { get; set; } = string.Empty;

    public string? ContactPhone { get; set; }

    public decimal? RewardAmount { get; set; }

    public IReadOnlyList<LostPetPhotoResponse> Photos { get; set; } = [];

    public DateTimeOffset CreatedAt { get; set; }
}
