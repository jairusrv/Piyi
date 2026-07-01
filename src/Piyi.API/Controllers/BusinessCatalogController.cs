using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Piyi.Application.Abstractions;
using Piyi.Contracts.BusinessCatalog;

namespace Piyi.API.Controllers;

[ApiController]
[Route("api/catalog")]
public sealed class BusinessCatalogController : ControllerBase
{
    private readonly IBusinessCatalogService _service;

    public BusinessCatalogController(IBusinessCatalogService service)
    {
        _service = service;
    }

    [HttpGet("search")]
    [AllowAnonymous]
    public async Task<IActionResult> Search(
        [FromQuery] string? search,
        [FromQuery] string? category,
        [FromQuery] string? brand,
        [FromQuery] string? species,
        [FromQuery] string? breed,
        [FromQuery] bool availableOnly = true,
        CancellationToken cancellationToken = default)
    {
        var items = await _service.SearchAsync(
            search,
            category,
            brand,
            species,
            breed,
            availableOnly,
            cancellationToken);

        return Ok(items);
    }

    [HttpGet("business/{businessId:guid}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetByBusiness(
        Guid businessId,
        CancellationToken cancellationToken)
    {
        var items = await _service.GetByBusinessAsync(businessId, cancellationToken);
        return Ok(items);
    }

    [HttpGet("{id:guid}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetById(
        Guid id,
        CancellationToken cancellationToken)
    {
        var item = await _service.GetByIdAsync(id, cancellationToken);

        if (item is null)
        {
            return NotFound(new { message = "Publicación no encontrada." });
        }

        return Ok(item);
    }

    [HttpPost]
    [Authorize]
    public async Task<IActionResult> Create(
        CreateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
        {
            return BadRequest(new { message = "El nombre es requerido." });
        }

        try
        {
            var item = await _service.CreateAsync(request, cancellationToken);
            return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("{id:guid}")]
    [Authorize]
    public async Task<IActionResult> Update(
        Guid id,
        UpdateBusinessCatalogItemRequest request,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
        {
            return BadRequest(new { message = "El nombre es requerido." });
        }

        try
        {
            var item = await _service.UpdateAsync(id, request, cancellationToken);

            if (item is null)
            {
                return NotFound(new { message = "Publicación no encontrada." });
            }

            return Ok(item);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpDelete("{id:guid}")]
    [Authorize]
    public async Task<IActionResult> Delete(
        Guid id,
        CancellationToken cancellationToken)
    {
        var deleted = await _service.DeleteAsync(id, cancellationToken);

        if (!deleted)
        {
            return NotFound(new { message = "Publicación no encontrada." });
        }

        return NoContent();
    }
}
