namespace RaceDay.API.Models;

/// <summary>
/// Represents a RaceDay user. A user can act as either an organiser or a participant.
/// </summary>
public enum UserRole
{
    Organiser,
    Participant
}

public class User
{
    public int UserID { get; set; }

    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    // Password is stored as a hash, never as plain text.
    public string PasswordHash { get; set; } = string.Empty;

    public UserRole Role { get; set; }

    public DateTime CreatedAt { get; set; }

    // One organiser can manage many events.
    public ICollection<Event>? Events { get; set; } = new List<Event>();

    // One participant can submit multiple event entries.
    public ICollection<Entry>? Entries { get; set; } = new List<Entry>();
}
