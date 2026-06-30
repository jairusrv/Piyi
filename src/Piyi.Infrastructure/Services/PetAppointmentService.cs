using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Pets;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class PetAppointmentService : IPetAppointmentService
{
    private readonly PiyiDbContext _dbContext;

    public PetAppointmentService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<PetAppointmentResponse>>> GetAppointmentsAsync(Guid userId, Guid petId, CancellationToken cancellationToken = default)
    {
        if (!await UserOwnsPetAsync(userId, petId, cancellationToken))
            return Result<IReadOnlyList<PetAppointmentResponse>>.Failure("Mascota no encontrada.");

        var items = await _dbContext.PetAppointments
            .AsNoTracking()
            .Include(x => x.Business)
            .Where(x => x.PetId == petId && !x.IsDeleted)
            .OrderBy(x => x.AppointmentDateTime)
            .Select(x => ToResponse(x))
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<PetAppointmentResponse>>.Success(items);
    }

    public async Task<Result<PetAppointmentResponse>> GetAppointmentByIdAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default)
    {
        if (!await UserOwnsPetAsync(userId, petId, cancellationToken))
            return Result<PetAppointmentResponse>.Failure("Mascota no encontrada.");

        var appointment = await _dbContext.PetAppointments
            .AsNoTracking()
            .Include(x => x.Business)
            .FirstOrDefaultAsync(x => x.Id == appointmentId && x.PetId == petId && !x.IsDeleted, cancellationToken);

        if (appointment is null)
            return Result<PetAppointmentResponse>.Failure("Cita no encontrada.");

        return Result<PetAppointmentResponse>.Success(ToResponse(appointment));
    }

    public async Task<Result<PetAppointmentResponse>> CreateAppointmentAsync(Guid userId, Guid petId, CreatePetAppointmentRequest request, CancellationToken cancellationToken = default)
    {
        if (!await UserOwnsPetAsync(userId, petId, cancellationToken))
            return Result<PetAppointmentResponse>.Failure("Mascota no encontrada.");

        var validation = await ValidateBusinessAsync(request.BusinessId, cancellationToken);
        if (validation.IsFailure)
            return Result<PetAppointmentResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Title))
            return Result<PetAppointmentResponse>.Failure("El título de la cita es requerido.");

        var appointment = new PetAppointment
        {
            Id = Guid.NewGuid(),
            PetId = petId,
            BusinessId = request.BusinessId,
            Title = request.Title.Trim(),
            Type = ParseEnum(request.Type, AppointmentType.Other),
            Status = AppointmentStatus.Scheduled,
            AppointmentDateTime = request.AppointmentDateTime,
            PlaceName = Clean(request.PlaceName),
            Address = Clean(request.Address),
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            ContactName = Clean(request.ContactName),
            ContactPhone = Clean(request.ContactPhone),
            Notes = Clean(request.Notes),
            ReminderEnabled = request.ReminderEnabled,
            ReminderAt = request.ReminderAt,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.PetAppointments.Add(appointment);
        await _dbContext.SaveChangesAsync(cancellationToken);

        var created = await _dbContext.PetAppointments
            .AsNoTracking()
            .Include(x => x.Business)
            .FirstAsync(x => x.Id == appointment.Id, cancellationToken);

        return Result<PetAppointmentResponse>.Success(ToResponse(created));
    }

    public async Task<Result<PetAppointmentResponse>> UpdateAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, UpdatePetAppointmentRequest request, CancellationToken cancellationToken = default)
    {
        if (!await UserOwnsPetAsync(userId, petId, cancellationToken))
            return Result<PetAppointmentResponse>.Failure("Mascota no encontrada.");

        var appointment = await _dbContext.PetAppointments
            .Include(x => x.Business)
            .FirstOrDefaultAsync(x => x.Id == appointmentId && x.PetId == petId && !x.IsDeleted, cancellationToken);

        if (appointment is null)
            return Result<PetAppointmentResponse>.Failure("Cita no encontrada.");

        var validation = await ValidateBusinessAsync(request.BusinessId, cancellationToken);
        if (validation.IsFailure)
            return Result<PetAppointmentResponse>.Failure(validation.Error!);

        if (string.IsNullOrWhiteSpace(request.Title))
            return Result<PetAppointmentResponse>.Failure("El título de la cita es requerido.");

        appointment.BusinessId = request.BusinessId;
        appointment.Title = request.Title.Trim();
        appointment.Type = ParseEnum(request.Type, AppointmentType.Other);
        appointment.AppointmentDateTime = request.AppointmentDateTime;
        appointment.PlaceName = Clean(request.PlaceName);
        appointment.Address = Clean(request.Address);
        appointment.Latitude = request.Latitude;
        appointment.Longitude = request.Longitude;
        appointment.ContactName = Clean(request.ContactName);
        appointment.ContactPhone = Clean(request.ContactPhone);
        appointment.Notes = Clean(request.Notes);
        appointment.ReminderEnabled = request.ReminderEnabled;
        appointment.ReminderAt = request.ReminderAt;
        appointment.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        var updated = await _dbContext.PetAppointments
            .AsNoTracking()
            .Include(x => x.Business)
            .FirstAsync(x => x.Id == appointment.Id, cancellationToken);

        return Result<PetAppointmentResponse>.Success(ToResponse(updated));
    }

    public async Task<Result> DeleteAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default)
    {
        var appointment = await GetOwnedAppointmentAsync(userId, petId, appointmentId, cancellationToken);
        if (appointment is null)
            return Result.Failure("Cita no encontrada.");

        appointment.IsDeleted = true;
        appointment.DeletedAt = DateTimeOffset.UtcNow;
        appointment.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> CompleteAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default)
    {
        var appointment = await GetOwnedAppointmentAsync(userId, petId, appointmentId, cancellationToken);
        if (appointment is null)
            return Result.Failure("Cita no encontrada.");

        appointment.Status = AppointmentStatus.Completed;
        appointment.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result> CancelAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken = default)
    {
        var appointment = await GetOwnedAppointmentAsync(userId, petId, appointmentId, cancellationToken);
        if (appointment is null)
            return Result.Failure("Cita no encontrada.");

        appointment.Status = AppointmentStatus.Cancelled;
        appointment.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private async Task<PetAppointment?> GetOwnedAppointmentAsync(Guid userId, Guid petId, Guid appointmentId, CancellationToken cancellationToken)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return null;

        return await _dbContext.PetAppointments
            .FirstOrDefaultAsync(x => x.Id == appointmentId && x.PetId == petId && !x.IsDeleted, cancellationToken);
    }

    private async Task<bool> UserOwnsPetAsync(Guid userId, Guid petId, CancellationToken cancellationToken)
    {
        return await _dbContext.Pets
            .AnyAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);
    }

    private async Task<Result> ValidateBusinessAsync(Guid? businessId, CancellationToken cancellationToken)
    {
        if (!businessId.HasValue)
            return Result.Success();

        var exists = await _dbContext.Businesses
            .AnyAsync(x => x.Id == businessId.Value && !x.IsDeleted, cancellationToken);

        return exists ? Result.Success() : Result.Failure("El negocio seleccionado no existe.");
    }

    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();

    private static TEnum ParseEnum<TEnum>(string? value, TEnum defaultValue) where TEnum : struct
    {
        return !string.IsNullOrWhiteSpace(value) && Enum.TryParse<TEnum>(value, true, out var parsed)
            ? parsed
            : defaultValue;
    }

    private static PetAppointmentResponse ToResponse(PetAppointment appointment)
    {
        return new PetAppointmentResponse
        {
            Id = appointment.Id,
            PetId = appointment.PetId,
            BusinessId = appointment.BusinessId,
            BusinessName = appointment.Business?.Name,
            Title = appointment.Title,
            Type = appointment.Type.ToString(),
            Status = appointment.Status.ToString(),
            AppointmentDateTime = appointment.AppointmentDateTime,
            PlaceName = appointment.PlaceName,
            Address = appointment.Address,
            Latitude = appointment.Latitude,
            Longitude = appointment.Longitude,
            ContactName = appointment.ContactName,
            ContactPhone = appointment.ContactPhone,
            Notes = appointment.Notes,
            ReminderEnabled = appointment.ReminderEnabled,
            ReminderAt = appointment.ReminderAt,
            CreatedAt = appointment.CreatedAt
        };
    }
}
