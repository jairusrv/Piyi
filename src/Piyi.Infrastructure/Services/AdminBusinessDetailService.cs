using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Businesses;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class AdminBusinessDetailService : IAdminBusinessDetailService
{
    private readonly PiyiDbContext _dbContext;

    public AdminBusinessDetailService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<BusinessServiceResponse>> AddServiceAsync(
        Guid businessId,
        CreateBusinessServiceRequest request,
        CancellationToken cancellationToken = default)
    {
        if (!await BusinessExistsAsync(businessId, cancellationToken))
            return Result<BusinessServiceResponse>.Failure("Negocio no encontrado.");

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<BusinessServiceResponse>.Failure("El nombre del servicio es requerido.");

        var service = new BusinessService
        {
            Id = Guid.NewGuid(),
            BusinessId = businessId,
            Name = request.Name.Trim(),
            Description = Clean(request.Description),
            PriceFrom = request.PriceFrom,
            PriceTo = request.PriceTo,
            IsActive = true,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.BusinessServices.Add(service);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<BusinessServiceResponse>.Success(new BusinessServiceResponse
        {
            Id = service.Id,
            Name = service.Name,
            Description = service.Description,
            PriceFrom = service.PriceFrom,
            PriceTo = service.PriceTo,
            IsActive = service.IsActive
        });
    }

    public async Task<Result> DeleteServiceAsync(
        Guid businessId,
        Guid serviceId,
        CancellationToken cancellationToken = default)
    {
        var service = await _dbContext.BusinessServices
            .FirstOrDefaultAsync(x => x.Id == serviceId && x.BusinessId == businessId && !x.IsDeleted, cancellationToken);

        if (service is null)
            return Result.Failure("Servicio no encontrado.");

        service.IsDeleted = true;
        service.DeletedAt = DateTimeOffset.UtcNow;
        service.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result<BusinessPhotoResponse>> AddPhotoAsync(
        Guid businessId,
        CreateBusinessPhotoRequest request,
        CancellationToken cancellationToken = default)
    {
        if (!await BusinessExistsAsync(businessId, cancellationToken))
            return Result<BusinessPhotoResponse>.Failure("Negocio no encontrado.");

        if (string.IsNullOrWhiteSpace(request.PhotoUrl))
            return Result<BusinessPhotoResponse>.Failure("La URL de la foto es requerida.");

        var photo = new BusinessPhoto
        {
            Id = Guid.NewGuid(),
            BusinessId = businessId,
            PhotoUrl = request.PhotoUrl.Trim(),
            SortOrder = request.SortOrder,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.BusinessPhotos.Add(photo);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<BusinessPhotoResponse>.Success(new BusinessPhotoResponse
        {
            Id = photo.Id,
            PhotoUrl = photo.PhotoUrl,
            SortOrder = photo.SortOrder
        });
    }

    public async Task<Result> DeletePhotoAsync(
        Guid businessId,
        Guid photoId,
        CancellationToken cancellationToken = default)
    {
        var photo = await _dbContext.BusinessPhotos
            .FirstOrDefaultAsync(x => x.Id == photoId && x.BusinessId == businessId && !x.IsDeleted, cancellationToken);

        if (photo is null)
            return Result.Failure("Foto no encontrada.");

        photo.IsDeleted = true;
        photo.DeletedAt = DateTimeOffset.UtcNow;
        photo.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result<IReadOnlyList<BusinessScheduleResponse>>> UpdateSchedulesAsync(
        Guid businessId,
        UpdateBusinessSchedulesRequest request,
        CancellationToken cancellationToken = default)
    {
        if (!await BusinessExistsAsync(businessId, cancellationToken))
            return Result<IReadOnlyList<BusinessScheduleResponse>>.Failure("Negocio no encontrado.");

        if (request.Schedules.Count == 0)
            return Result<IReadOnlyList<BusinessScheduleResponse>>.Failure("Debe enviar al menos un horario.");

        foreach (var item in request.Schedules)
        {
            if (item.DayOfWeek < 0 || item.DayOfWeek > 6)
                return Result<IReadOnlyList<BusinessScheduleResponse>>.Failure("DayOfWeek debe estar entre 0 y 6.");

            if (!item.IsClosed && (item.OpensAt is null || item.ClosesAt is null))
                return Result<IReadOnlyList<BusinessScheduleResponse>>.Failure("Si el día está abierto debe indicar hora de apertura y cierre.");
        }

        var current = await _dbContext.BusinessSchedules
            .Where(x => x.BusinessId == businessId && !x.IsDeleted)
            .ToListAsync(cancellationToken);

        foreach (var schedule in current)
        {
            schedule.IsDeleted = true;
            schedule.DeletedAt = DateTimeOffset.UtcNow;
            schedule.UpdatedAt = DateTimeOffset.UtcNow;
        }

        var newSchedules = request.Schedules
            .OrderBy(x => x.DayOfWeek)
            .Select(x => new BusinessSchedule
            {
                Id = Guid.NewGuid(),
                BusinessId = businessId,
                DayOfWeek = x.DayOfWeek,
                OpensAt = x.IsClosed ? null : x.OpensAt,
                ClosesAt = x.IsClosed ? null : x.ClosesAt,
                IsClosed = x.IsClosed,
                CreatedAt = DateTimeOffset.UtcNow
            })
            .ToList();

        _dbContext.BusinessSchedules.AddRange(newSchedules);
        await _dbContext.SaveChangesAsync(cancellationToken);

        var response = newSchedules
            .OrderBy(x => x.DayOfWeek)
            .Select(x => new BusinessScheduleResponse
            {
                Id = x.Id,
                DayOfWeek = x.DayOfWeek,
                OpensAt = x.OpensAt,
                ClosesAt = x.ClosesAt,
                IsClosed = x.IsClosed
            })
            .ToList();

        return Result<IReadOnlyList<BusinessScheduleResponse>>.Success(response);
    }

    private async Task<bool> BusinessExistsAsync(Guid businessId, CancellationToken cancellationToken)
    {
        return await _dbContext.Businesses
            .AnyAsync(x => x.Id == businessId && !x.IsDeleted, cancellationToken);
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
}
