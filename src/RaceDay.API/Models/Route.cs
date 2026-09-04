namespace RaceDay.API.Models;

/// <summary>
/// Represents the route configured for an event.
/// </summary>
public class Route
{
    public int RouteID { get; set; }

    public int EventID { get; set; }

    public string RouteName { get; set; } = string.Empty;

    public decimal DistanceKM { get; set; }

    public int? ElevationGainM { get; set; }

    public string? RouteDescription { get; set; }

    public string? MapURL { get; set; }

    // Each route belongs to one event.
    public Event Event { get; set; } = null!;
}
