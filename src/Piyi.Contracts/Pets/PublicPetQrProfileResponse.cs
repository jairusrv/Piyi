namespace Piyi.Contracts.Pets;

public sealed class PublicPetQrProfileResponse
{
    public string PetName { get; set; } = string.Empty;

    public string SpeciesName { get; set; } = string.Empty;

    public string? BreedName { get; set; }

    public string? PhotoUrl { get; set; }

    public string? Color { get; set; }

    public string? OwnerFirstName { get; set; }

    public string? ContactPhone { get; set; }

    public string Message { get; set; } = "Esta mascota tiene identidad digital en Piyí.";
}
