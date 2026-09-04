namespace RaceDay.API.Models;

/// <summary>
/// Represents the recorded result for a participant's event entry.
/// </summary>
public enum ResultStatus
{
    Finished,
    DNF,
    DNS,
    Disqualified
}

public class Result
{
    public int ResultID { get; set; }

    public int EntryID { get; set; }

    public TimeSpan FinishTime { get; set; }

    public int OverallPosition { get; set; }

    public int CategoryPosition { get; set; }

    public ResultStatus ResultStatus { get; set; }

    public DateTime RecordedAt { get; set; }

    // One entry can have one associated result.
    public Entry Entry { get; set; } = null!;
}
