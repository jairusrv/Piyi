namespace Piyi.Contracts.LostPets;

public sealed class CreateLostPetRequest
{
    public string Title { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    public string? LastSeenAddress { get; set; }

    public decimal? LastSeenLatitude { get; set; }

    public decimal? LastSeenLongitude { get; set; }

    public DateTimeOffset LostDate { get; set; }

    public string? ContactPhone { get; set; }

    public decimal? RewardAmount { get; set; }
}
