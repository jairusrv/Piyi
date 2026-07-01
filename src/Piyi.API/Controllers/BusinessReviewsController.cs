using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessReviews;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/businesses/{businessId:guid}/reviews")]
public sealed class BusinessReviewsController : ControllerBase
{
    private readonly IBusinessReviewService _service;

    public BusinessReviewsController(IBusinessReviewService service)
    {
        _service = service;
    }

    [HttpGet]
    [AllowAnonymous]
    public async Task<IActionResult> GetReviews(
        Guid businessId,
        CancellationToken cancellationToken)
    {
        var reviews = await _service.GetByBusinessAsync(businessId, cancellationToken);
        return Ok(reviews);
    }

    [HttpGet("summary")]
    [AllowAnonymous]
    public async Task<IActionResult> GetSummary(
        Guid businessId,
        CancellationToken cancellationToken)
    {
        var summary = await _service.GetSummaryAsync(businessId, cancellationToken);
        return Ok(summary);
    }

    [HttpPost]
    [Authorize]
    public async Task<IActionResult> Create(
        Guid businessId,
        CreateBusinessReviewRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();

        if (userId is null)
        {
            return Unauthorized(new { message = "Usuario no autenticado." });
        }

        try
        {
            var review = await _service.CreateAsync(
                businessId,
                userId.Value,
                request,
                cancellationToken);

            return Ok(review);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{reviewId:guid}/reply")]
    [Authorize]
    public async Task<IActionResult> Reply(
        Guid reviewId,
        ReplyBusinessReviewRequest request,
        CancellationToken cancellationToken)
    {
        var review = await _service.ReplyAsync(reviewId, request, cancellationToken);

        if (review is null)
        {
            return NotFound(new { message = "Reseña no encontrada." });
        }

        return Ok(review);
    }

    [HttpPost("{reviewId:guid}/report")]
    [Authorize]
    public async Task<IActionResult> Report(
        Guid reviewId,
        ReportBusinessReviewRequest request,
        CancellationToken cancellationToken)
    {
        var reported = await _service.ReportAsync(reviewId, request, cancellationToken);

        if (!reported)
        {
            return NotFound(new { message = "Reseña no encontrada." });
        }

        return Ok(new { message = "Reseña reportada correctamente." });
    }

    [HttpDelete("{reviewId:guid}")]
    [Authorize]
    public async Task<IActionResult> Delete(
        Guid reviewId,
        CancellationToken cancellationToken)
    {
        var userId = GetCurrentUserId();

        if (userId is null)
        {
            return Unauthorized(new { message = "Usuario no autenticado." });
        }

        var deleted = await _service.DeleteAsync(reviewId, userId.Value, cancellationToken);

        if (!deleted)
        {
            return NotFound(new { message = "Reseña no encontrada." });
        }

        return NoContent();
    }

    private Guid? GetCurrentUserId()
    {
        var value =
            User.FindFirstValue(ClaimTypes.NameIdentifier) ??
            User.FindFirstValue("sub") ??
            User.FindFirstValue("userId") ??
            User.FindFirstValue("id");

        return Guid.TryParse(value, out var id) ? id : null;
    }
}
