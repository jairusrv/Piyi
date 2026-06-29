using Piyi.Domain.Common;
using Piyi.Domain.Enums;

namespace Piyi.Domain.Entities;

public class Pet : BaseEntity
{
    public Guid UserId { get; set; }
    public Guid SpeciesId { get; set; }
    public Guid? BreedId { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateOnly? BirthDate { get; set; }
    public string? ApproximateAge { get; set; }
    public PetSex Sex { get; set; } = PetSex.Unknown;
    public decimal? WeightKg { get; set; }
    public string? Color { get; set; }
    public string? PhotoUrl { get; set; }
    public bool IsSterilized { get; set; }
    public string? MicrochipNumber { get; set; }
    public PetStatus Status { get; set; } = PetStatus.Active;

    public User User { get; set; } = null!;
    public Species Species { get; set; } = null!;
    public Breed? Breed { get; set; }
    public PetQrCode? QrCode { get; set; }
    public ICollection<PetVaccine> Vaccines { get; set; } = new List<PetVaccine>();
    public ICollection<PetReminder> Reminders { get; set; } = new List<PetReminder>();
    public ICollection<LostPet> LostPetReports { get; set; } = new List<LostPet>();
}
