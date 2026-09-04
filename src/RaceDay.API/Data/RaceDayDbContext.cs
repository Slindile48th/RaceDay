using Microsoft.EntityFrameworkCore;
using RaceDay.API.Models;

namespace RaceDay.API.Data;

/// <summary>
/// The EF Core context is the bridge between the C# model classes and the SQLite database.
/// Each DbSet represents one table that EF Core can query, track, and persist.
/// </summary>
public class RaceDayDbContext : DbContext
{
    public RaceDayDbContext(DbContextOptions<RaceDayDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();

    public DbSet<Event> Events => Set<Event>();

    public DbSet<Category> Categories => Set<Category>();

    public DbSet<RaceDay.API.Models.Route> Routes => Set<RaceDay.API.Models.Route>();

    public DbSet<Entry> Entries => Set<Entry>();

    public DbSet<Result> Results => Set<Result>();
}
