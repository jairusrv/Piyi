using Microsoft.EntityFrameworkCore;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Pets;
using Piyi.Domain.Entities;
using Piyi.Domain.Enums;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class PetHealthService : IPetHealthService
{
    private readonly PiyiDbContext _dbContext;

    public PetHealthService(PiyiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Result<IReadOnlyList<PetVaccineResponse>>> GetVaccinesAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return Result<IReadOnlyList<PetVaccineResponse>>.Failure("Mascota no encontrada.");

        var items = await _dbContext.PetVaccines
            .AsNoTracking()
            .Where(x => x.PetId == petId && !x.IsDeleted)
            .OrderByDescending(x => x.AppliedDate)
            .Select(x => new PetVaccineResponse
            {
                Id = x.Id,
                PetId = x.PetId,
                Name = x.Name,
                AppliedDate = x.AppliedDate,
                NextDueDate = x.NextDueDate,
                Notes = x.Notes,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<PetVaccineResponse>>.Success(items);
    }

    public async Task<Result<PetVaccineResponse>> CreateVaccineAsync(
        Guid userId,
        Guid petId,
        CreatePetVaccineRequest request,
        CancellationToken cancellationToken = default)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return Result<PetVaccineResponse>.Failure("Mascota no encontrada.");

        if (string.IsNullOrWhiteSpace(request.Name))
            return Result<PetVaccineResponse>.Failure("El nombre de la vacuna es requerido.");

        var vaccine = new PetVaccine
        {
            Id = Guid.NewGuid(),
            PetId = petId,
            Name = request.Name.Trim(),
            AppliedDate = request.AppliedDate,
            NextDueDate = request.NextDueDate,
            Notes = Clean(request.Notes),
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.PetVaccines.Add(vaccine);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<PetVaccineResponse>.Success(new PetVaccineResponse
        {
            Id = vaccine.Id,
            PetId = vaccine.PetId,
            Name = vaccine.Name,
            AppliedDate = vaccine.AppliedDate,
            NextDueDate = vaccine.NextDueDate,
            Notes = vaccine.Notes,
            CreatedAt = vaccine.CreatedAt
        });
    }

    public async Task<Result<IReadOnlyList<PetReminderResponse>>> GetRemindersAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return Result<IReadOnlyList<PetReminderResponse>>.Failure("Mascota no encontrada.");

        var items = await _dbContext.PetReminders
            .AsNoTracking()
            .Where(x => x.PetId == petId && !x.IsDeleted)
            .OrderBy(x => x.IsCompleted)
            .ThenBy(x => x.ReminderDate)
            .Select(x => new PetReminderResponse
            {
                Id = x.Id,
                PetId = x.PetId,
                Title = x.Title,
                Type = x.Type.ToString(),
                ReminderDate = x.ReminderDate,
                RepeatType = x.RepeatType.ToString(),
                IsCompleted = x.IsCompleted,
                Notes = x.Notes,
                CreatedAt = x.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Result<IReadOnlyList<PetReminderResponse>>.Success(items);
    }

    public async Task<Result<PetReminderResponse>> CreateReminderAsync(
        Guid userId,
        Guid petId,
        CreatePetReminderRequest request,
        CancellationToken cancellationToken = default)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return Result<PetReminderResponse>.Failure("Mascota no encontrada.");

        if (string.IsNullOrWhiteSpace(request.Title))
            return Result<PetReminderResponse>.Failure("El título del recordatorio es requerido.");

        var reminder = new PetReminder
        {
            Id = Guid.NewGuid(),
            PetId = petId,
            Title = request.Title.Trim(),
            Type = ParseEnum(request.Type, ReminderType.Other),
            ReminderDate = request.ReminderDate,
            RepeatType = ParseEnum(request.RepeatType, RepeatType.None),
            IsCompleted = false,
            Notes = Clean(request.Notes),
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.PetReminders.Add(reminder);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<PetReminderResponse>.Success(new PetReminderResponse
        {
            Id = reminder.Id,
            PetId = reminder.PetId,
            Title = reminder.Title,
            Type = reminder.Type.ToString(),
            ReminderDate = reminder.ReminderDate,
            RepeatType = reminder.RepeatType.ToString(),
            IsCompleted = reminder.IsCompleted,
            Notes = reminder.Notes,
            CreatedAt = reminder.CreatedAt
        });
    }

    public async Task<Result> CompleteReminderAsync(
        Guid userId,
        Guid petId,
        Guid reminderId,
        CancellationToken cancellationToken = default)
    {
        var ownsPet = await UserOwnsPetAsync(userId, petId, cancellationToken);
        if (!ownsPet)
            return Result.Failure("Mascota no encontrada.");

        var reminder = await _dbContext.PetReminders
            .FirstOrDefaultAsync(x => x.Id == reminderId && x.PetId == petId && !x.IsDeleted, cancellationToken);

        if (reminder is null)
            return Result.Failure("Recordatorio no encontrado.");

        reminder.IsCompleted = true;
        reminder.UpdatedAt = DateTimeOffset.UtcNow;

        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }

    private async Task<bool> UserOwnsPetAsync(Guid userId, Guid petId, CancellationToken cancellationToken)
    {
        return await _dbContext.Pets
            .AnyAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);
    }

    private static string? Clean(string? value)
    {
        return string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }

    private static TEnum ParseEnum<TEnum>(string? value, TEnum defaultValue)
        where TEnum : struct
    {
        if (!string.IsNullOrWhiteSpace(value) &&
            Enum.TryParse<TEnum>(value, ignoreCase: true, out var parsed))
        {
            return parsed;
        }

        return defaultValue;
    }
}
