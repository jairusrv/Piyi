using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.Businesses;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/admin/businesses/{businessId:guid}")]
[Authorize(Roles = "Admin")]
public sealed class AdminBusinessDetailsController : ControllerBase
{
    private readonly IAdminBusinessDetailService _service;

    public AdminBusinessDetailsController(IAdminBusinessDetailService service)
    {
        _service = service;
    }

    [HttpPost("services")]
    public async Task<IActionResult> AddService(
        Guid businessId,
        [FromBody] CreateBusinessServiceRequest request,
        CancellationToken cancellationToken)
    {
        var result = await _service.AddServiceAsync(businessId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpDelete("services/{serviceId:guid}")]
    public async Task<IActionResult> DeleteService(
        Guid businessId,
        Guid serviceId,
        CancellationToken cancellationToken)
    {
        var result = await _service.DeleteServiceAsync(businessId, serviceId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Servicio eliminado correctamente." });
    }

    [HttpPost("photos")]
    public async Task<IActionResult> AddPhoto(
        Guid businessId,
        [FromBody] CreateBusinessPhotoRequest request,
        CancellationToken cancellationToken)
    {
        var result = await _service.AddPhotoAsync(businessId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }

    [HttpDelete("photos/{photoId:guid}")]
    public async Task<IActionResult> DeletePhoto(
        Guid businessId,
        Guid photoId,
        CancellationToken cancellationToken)
    {
        var result = await _service.DeletePhotoAsync(businessId, photoId, cancellationToken);

        if (result.IsFailure)
            return NotFound(new { message = result.Error });

        return Ok(new { message = "Foto eliminada correctamente." });
    }

    [HttpPut("schedules")]
    public async Task<IActionResult> UpdateSchedules(
        Guid businessId,
        [FromBody] UpdateBusinessSchedulesRequest request,
        CancellationToken cancellationToken)
    {
        var result = await _service.UpdateSchedulesAsync(businessId, request, cancellationToken);

        if (result.IsFailure)
            return BadRequest(new { message = result.Error });

        return Ok(result.Value);
    }
}
