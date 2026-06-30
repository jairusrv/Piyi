using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Piyi.Application.Abstractions;
using Piyi.Application.Common;
using Piyi.Contracts.Pets;
using Piyi.Domain.Entities;
using Piyi.Infrastructure.Data;

namespace Piyi.Infrastructure.Services;

public sealed class PetQrService : IPetQrService
{
    private readonly PiyiDbContext _dbContext;
    private readonly IConfiguration _configuration;

    public PetQrService(PiyiDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _configuration = configuration;
    }

    public async Task<Result<PetQrCodeResponse>> GenerateOrGetQrAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var pet = await _dbContext.Pets
            .Include(x => x.QrCode)
            .FirstOrDefaultAsync(x => x.Id == petId && x.UserId == userId && !x.IsDeleted, cancellationToken);

        if (pet is null)
            return Result<PetQrCodeResponse>.Failure("Mascota no encontrada.");

        if (pet.QrCode is not null)
            return Result<PetQrCodeResponse>.Success(ToResponse(pet.QrCode));

        var code = await GenerateUniqueCodeAsync(cancellationToken);
        var publicBaseUrl = _configuration["PublicApp:BaseUrl"] ?? "https://piyi.app";

        var qr = new PetQrCode
        {
            Id = Guid.NewGuid(),
            PetId = pet.Id,
            Code = code,
            PublicUrl = $"{publicBaseUrl.TrimEnd('/')}/p/{code}",
            IsActive = true,
            ScanCount = 0,
            CreatedAt = DateTimeOffset.UtcNow
        };

        _dbContext.PetQrCodes.Add(qr);
        await _dbContext.SaveChangesAsync(cancellationToken);

        return Result<PetQrCodeResponse>.Success(ToResponse(qr));
    }

    public async Task<Result<PetQrCodeResponse>> GetQrByPetAsync(
        Guid userId,
        Guid petId,
        CancellationToken cancellationToken = default)
    {
        var qr = await _dbContext.PetQrCodes
            .AsNoTracking()
            .Include(x => x.Pet)
            .FirstOrDefaultAsync(x => x.PetId == petId && x.Pet.UserId == userId && !x.Pet.IsDeleted, cancellationToken);

        if (qr is null)
            return Result<PetQrCodeResponse>.Failure("QR no encontrado para esta mascota.");

        return Result<PetQrCodeResponse>.Success(ToResponse(qr));
    }

    public async Task<Result<PublicPetQrProfileResponse>> GetPublicProfileByCodeAsync(
        string code,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(code))
            return Result<PublicPetQrProfileResponse>.Failure("Código inválido.");

        var qr = await _dbContext.PetQrCodes
            .Include(x => x.Pet)
                .ThenInclude(x => x.Species)
            .Include(x => x.Pet)
                .ThenInclude(x => x.Breed)
            .Include(x => x.Pet)
                .ThenInclude(x => x.User)
            .FirstOrDefaultAsync(x => x.Code == code && x.IsActive && !x.IsDeleted, cancellationToken);

        if (qr is null || qr.Pet.IsDeleted)
            return Result<PublicPetQrProfileResponse>.Failure("QR no encontrado.");

        qr.ScanCount += 1;
        qr.LastScannedAt = DateTimeOffset.UtcNow;
        await _dbContext.SaveChangesAsync(cancellationToken);

        var pet = qr.Pet;

        return Result<PublicPetQrProfileResponse>.Success(new PublicPetQrProfileResponse
        {
            PetName = pet.Name,
            SpeciesName = pet.Species?.Name ?? string.Empty,
            BreedName = pet.Breed?.Name,
            PhotoUrl = pet.PhotoUrl,
            Color = pet.Color,
            OwnerFirstName = pet.User?.FirstName,
            ContactPhone = pet.User?.PhoneNumber
        });
    }

    private async Task<string> GenerateUniqueCodeAsync(CancellationToken cancellationToken)
    {
        for (var attempt = 0; attempt < 10; attempt++)
        {
            var code = CreateCode();

            var exists = await _dbContext.PetQrCodes
                .AnyAsync(x => x.Code == code, cancellationToken);

            if (!exists)
                return code;
        }

        return $"{CreateCode()}{CreateCode()[..4]}";
    }

    private static string CreateCode()
    {
        return Convert.ToBase64String(Guid.NewGuid().ToByteArray())
            .Replace("+", string.Empty)
            .Replace("/", string.Empty)
            .Replace("=", string.Empty)
            .ToUpperInvariant()[..10];
    }

    private static PetQrCodeResponse ToResponse(PetQrCode qr)
    {
        return new PetQrCodeResponse
        {
            Id = qr.Id,
            PetId = qr.PetId,
            Code = qr.Code,
            PublicUrl = qr.PublicUrl,
            IsActive = qr.IsActive,
            ScanCount = qr.ScanCount,
            LastScannedAt = qr.LastScannedAt,
            CreatedAt = qr.CreatedAt
        };
    }
}
