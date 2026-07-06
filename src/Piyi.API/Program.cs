using Piyi.Application;
using Piyi.Infrastructure;

using Piyi.Infrastructure.Data.Seed;using Serilog;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, configuration) =>
{
    configuration
        .ReadFrom.Configuration(context.Configuration)
        .WriteTo.Console();
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddAuthorization();

builder.Services.AddCors(options =>
{
    options.AddPolicy("PiyiCors", policy =>
    {
        policy.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin();
    });
});

builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);

var app = builder.Build();

if (app.Environment.IsDevelopment() ||
    string.Equals(Environment.GetEnvironmentVariable("PIYI_ENABLE_SWAGGER"), "true", StringComparison.OrdinalIgnoreCase))
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseSerilogRequestLogging();
app.UseCors("PiyiCors");
app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles();

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<Piyi.Infrastructure.Data.PiyiDbContext>();

    try
    {
        await PetCatalogSeeder.SeedAsync(dbContext);
    }
    catch (Exception ex)
    {
        app.Logger.LogError(ex, "Error seeding PiyÃ­ pet catalog.");
    }
}

app.MapControllers();

app.MapGet("/health", () => Results.Ok(new
{
    service = "PiyÃƒÂ­ API",
    status = "OK",
    version = "0.0.1",
    timestamp = DateTimeOffset.UtcNow
}));

app.Run();
