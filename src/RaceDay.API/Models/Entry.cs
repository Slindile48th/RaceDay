namespace RaceDay.API.Models;

/// <summary>
/// Represents a participant's registration into a selected category for an event.
/// </summary>
public class Entry
{
    public int EntryID { get; set; }

    public int UserID { get; set; }

    public int CategoryID { get; set; }

    public DateTime EntryDate { get; set; }

    // A participant/user can have many entries.
    public User User { get; set; } = null!;

    // A category can have many entries.
    public Category Category { get; set; } = null!;

// An entry may have zero or one result, depending on whether the participant has completed the event.
    public Result? Result { get; set; }
}
