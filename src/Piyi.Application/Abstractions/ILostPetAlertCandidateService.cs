using Piyi.Application.Common;
using Piyi.Contracts.Alerts;

namespace Piyi.Application.Abstractions;

public interface ILostPetAlertCandidateService
{
    Task<Result<IReadOnlyList<AlertCandidateResponse>>> GetCandidatesAsync(Guid lostPetId, CancellationToken cancellationToken = default);
}
