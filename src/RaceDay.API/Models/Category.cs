namespace RaceDay.API.Models;

/// <summary>
/// Represents a category within an event, such as age group or distance-based category.
/// </summary>
public class Category
{
    public int CategoryID { get; set; }

    public int EventID { get; set; }

    public string CategoryName { get; set; } = string.Empty;

    public decimal? DistanceKM { get; set; }

    public int? MaxParticipants { get; set; }

    public decimal EntryFee { get; set; }

    // Many categories belong to one event.
    public Event Event { get; set; } = null!;

    // A category can have many participant entries.
    public ICollection<Entry>? Entries { get; set; } = new List<Entry>();
}
