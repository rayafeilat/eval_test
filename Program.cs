using Dapper;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddOpenApi();
var app = builder.Build();

app.MapOpenApi();
app.UseHttpsRedirection();

var connectionString = Environment.GetEnvironmentVariable("DB_CONN")
    ?? throw new InvalidOperationException("Missing environment variable 'DB_CONN'.");

int Test = 121;

app.MapGet("/health", async () =>
{
    try
    {
        using var conn = new NpgsqlConnection(connectionString);
        await conn.OpenAsync();
        var result = await conn.ExecuteScalarAsync<int>($"SELECT {Test}");

        return result == Test
            ? Results.Ok(new { status = $"healthy, Database Returned Expected Value ({Test})", database = "up" })
            : Results.Json(
                new { status = "unhealthy", database = "unexpected response" },
                statusCode: StatusCodes.Status503ServiceUnavailable);
    }
    catch (Exception ex)
    {
        return Results.Json(
            new { status = "unhealthy", database = "down", error = ex.Message },
            statusCode: StatusCodes.Status503ServiceUnavailable);
    }
})
.WithName("Health");

app.Run();
