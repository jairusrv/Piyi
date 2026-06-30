using Piyi.Application.Common;
using Piyi.Contracts.Pets;

namespace Piyi.Application.Abstractions;

public interface IPetHealthService
{
    Task<Result<IReadOnlyList<PetVaccineResponse>>> GetVaccinesAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PetVaccineResponse>> CreateVaccineAsync(Guid userId, Guid petId, CreatePetVaccineRequest request, CancellationToken cancellationToken = default);

    Task<Result<IReadOnlyList<PetReminderResponse>>> GetRemindersAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PetReminderResponse>> CreateReminderAsync(Guid userId, Guid petId, CreatePetReminderRequest request, CancellationToken cancellationToken = default);

    Task<Result> CompleteReminderAsync(Guid userId, Guid petId, Guid reminderId, CancellationToken cancellationToken = default);
}
