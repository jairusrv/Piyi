using Piyi.Application.Common;
using Piyi.Contracts.Pets;

namespace Piyi.Application.Abstractions;

public interface IPetAppointmentService
{
    Task<Result<IReadOnlyList<PetAppointmentResponse>>> GetAppointmentsAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default);

    Task<Result<PetAppointmentResponse>> GetAppointmentByIdAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default);

    Task<Result<PetAppointmentResponse>> CreateAppointmentAsync(Guid userId, Guid petId, CreatePetAppointmentRequest request, CancellationToken cancellationToken = default);

    Task<Result<PetAppointmentResponse>> UpdateAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, UpdatePetAppointmentRequest request, CancellationToken cancellationToken = default);

    Task<Result> DeleteAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default);

    Task<Result> CompleteAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default);

    Task<Result> CancelAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default);
}
