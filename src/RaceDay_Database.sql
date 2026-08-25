/*
====================================================================
                    RACE DAY DATABASE
                 Programming 2B - POE

                    Objective 3
                 SQL Database Script

    DBMS: Microsoft SQL Server
    Intended for: SQL Server Management Studio (SSMS)

    This script:
    - Creates the RaceDay database
    - Creates all entities from the approved ERD
    - Defines primary keys and foreign keys
    - Defines NOT NULL, UNIQUE, DEFAULT and CHECK constraints
    - Seeds the database with realistic sample data
    - Provides verification queries

    Required sample data:
    - 2 Organisers
    - 2 Participants
    - 3 Events
    - Categories for every event
    - Sample event enrolments
    - Sample results
    - Route information

====================================================================
*/


/*
====================================================================
1. CREATE DATABASE
====================================================================
*/

IF DB_ID('RaceDay') IS NULL
BEGIN
    EXEC('CREATE DATABASE RaceDay');
END;
GO

USE RaceDay;
GO


/*
====================================================================
2. REMOVE EXISTING TABLES FOR REPEATABLE TESTING
====================================================================

These statements allow the script to be executed again during
development and testing.

The tables are removed in reverse dependency order so that
foreign-key constraints do not cause errors.
====================================================================
*/

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL
    DROP TABLE dbo.Results;
GO

IF OBJECT_ID('dbo.Entries', 'U') IS NOT NULL
    DROP TABLE dbo.Entries;
GO

IF OBJECT_ID('dbo.Routes', 'U') IS NOT NULL
    DROP TABLE dbo.Routes;
GO

IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;
GO

IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL
    DROP TABLE dbo.Events;
GO

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE dbo.Users;
GO


/*
====================================================================
3. CREATE USERS TABLE
====================================================================
*/

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) NOT NULL,

    FirstName NVARCHAR(50) NOT NULL,

    LastName NVARCHAR(50) NOT NULL,

    Email NVARCHAR(100) NOT NULL,

    PasswordHash NVARCHAR(255) NOT NULL,

    Role NVARCHAR(20) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Users_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Users
        PRIMARY KEY (UserID),

    CONSTRAINT UQ_Users_Email
        UNIQUE (Email),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO


/*
====================================================================
4. CREATE EVENTS TABLE
====================================================================
*/

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) NOT NULL,

    OrganizerID INT NOT NULL,

    EventName NVARCHAR(150) NOT NULL,

    Description NVARCHAR(500) NOT NULL,

    EventDate DATE NOT NULL,

    Location NVARCHAR(150) NOT NULL,

    EventType NVARCHAR(20) NOT NULL,

    RegistrationDeadline DATE NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Events_CreatedAt
        DEFAULT SYSDATETIME(),

    DistanceKM DECIMAL(6,2) NOT NULL,

    CONSTRAINT PK_Events
        PRIMARY KEY (EventID),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (OrganizerID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_EventType
        CHECK (EventType IN ('Run', 'Walk', 'Cycle')),

    CONSTRAINT CK_Events_Distance
        CHECK (DistanceKM > 0),

    CONSTRAINT CK_Events_RegistrationDeadline
        CHECK (RegistrationDeadline <= EventDate)
);
GO


/*
====================================================================
5. CREATE CATEGORIES TABLE
====================================================================
*/

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,

    EventID INT NOT NULL,

    CategoryName NVARCHAR(100) NOT NULL,

    DistanceKM DECIMAL(6,2) NULL,

    MaxParticipants INT NULL,

    EntryFee DECIMAL(10,2) NOT NULL
        CONSTRAINT DF_Categories_EntryFee
        DEFAULT 0.00,

    CONSTRAINT PK_Categories
        PRIMARY KEY (CategoryID),

    CONSTRAINT FK_Categories_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKM IS NULL OR DistanceKM > 0),

    CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaxParticipants IS NULL OR MaxParticipants > 0),

    CONSTRAINT CK_Categories_EntryFee
        CHECK (EntryFee >= 0)
);
GO


/*
====================================================================
6. CREATE ROUTES TABLE
====================================================================
*/

CREATE TABLE Routes
(
    RouteID INT IDENTITY(1,1) NOT NULL,

    EventID INT NOT NULL,

    RouteName NVARCHAR(150) NOT NULL,

    DistanceKM DECIMAL(6,2) NOT NULL,

    ElevationGainM INT NULL,

    RouteDescription NVARCHAR(500) NULL,

    MapURL NVARCHAR(500) NULL,

    CONSTRAINT PK_Routes
        PRIMARY KEY (RouteID),

    CONSTRAINT FK_Routes_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT UQ_Routes_EventID
        UNIQUE (EventID),

    CONSTRAINT CK_Routes_Distance
        CHECK (DistanceKM > 0),

    CONSTRAINT CK_Routes_Elevation
        CHECK (ElevationGainM IS NULL OR ElevationGainM >= 0)
);
GO


/*
====================================================================
7. CREATE ENTRIES TABLE
====================================================================
*/

CREATE TABLE Entries
(
    EntryID INT IDENTITY(1,1) NOT NULL,

    UserID INT NOT NULL,

    CategoryID INT NOT NULL,

    EntryDate DATETIME2 NOT NULL
        CONSTRAINT DF_Entries_EntryDate
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Entries
        PRIMARY KEY (EntryID),

    CONSTRAINT FK_Entries_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Entries_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT UQ_Entries_User_Category
        UNIQUE (UserID, CategoryID)
);
GO


/*
====================================================================
8. CREATE RESULTS TABLE
====================================================================
*/

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) NOT NULL,

    EntryID INT NOT NULL,

    FinishTime TIME(0) NOT NULL,

    OverallPosition INT NOT NULL,

    CategoryPosition INT NOT NULL,

    ResultStatus NVARCHAR(20) NOT NULL,

    RecordedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Results_RecordedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Results
        PRIMARY KEY (ResultID),

    CONSTRAINT FK_Results_Entries
        FOREIGN KEY (EntryID)
        REFERENCES Entries(EntryID),

    CONSTRAINT UQ_Results_EntryID
        UNIQUE (EntryID),

    CONSTRAINT CK_Results_OverallPosition
        CHECK (OverallPosition > 0),

    CONSTRAINT CK_Results_CategoryPosition
        CHECK (CategoryPosition > 0),

    CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN
        (
            'Finished',
            'DNF',
            'DNS',
            'Disqualified'
        ))
);
GO


/*
====================================================================
9. INSERT USERS
====================================================================

2 Organisers
2 Participants
====================================================================
*/

INSERT INTO Users
(
    FirstName,
    LastName,
    Email,
    PasswordHash,
    Role
)
VALUES
(
    'Thabo',
    'Mokoena',
    'thabo.mokoena@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_001',
    'Organiser'
),
(
    'Lerato',
    'Dlamini',
    'lerato.dlamini@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_002',
    'Organiser'
),
(
    'Sipho',
    'Nkosi',
    'sipho.nkosi@example.com',
    'HASHED_PASSWORD_PARTICIPANT_001',
    'Participant'
),
(
    'Nomsa',
    'Mthembu',
    'nomsa.mthembu@example.com',
    'HASHED_PASSWORD_PARTICIPANT_002',
    'Participant'
);
GO


/*
====================================================================
10. INSERT EVENTS
====================================================================

3 Events

Event 1: Run
Event 2: Walk
Event 3: Cycle
====================================================================
*/

INSERT INTO Events
(
    OrganizerID,
    EventName,
    Description,
    EventDate,
    Location,
    EventType,
    RegistrationDeadline,
    DistanceKM
)
VALUES
(
    1,
    'Durban Sunrise Run',
    'A community road running event along the Durban beachfront.',
    '2026-10-10',
    'Durban, KwaZulu-Natal',
    'Run',
    '2026-10-01',
    10.00
),
(
    2,
    'Soweto Community Walk',
    'A family-friendly community walking event through Soweto.',
    '2026-11-07',
    'Soweto, Gauteng',
    'Walk',
    '2026-10-30',
    10.00
),
(
    1,
    'Cape Town Coastal Cycle',
    'A recreational road cycling event along the Cape Town coastline.',
    '2026-12-05',
    'Cape Town, Western Cape',
    'Cycle',
    '2026-11-25',
    21.00
);
GO


/*
====================================================================
11. INSERT CATEGORIES
====================================================================

Every event has multiple categories.
====================================================================
*/

INSERT INTO Categories
(
    EventID,
    CategoryName,
    DistanceKM,
    MaxParticipants,
    EntryFee
)
VALUES

-- Durban Sunrise Run
(
    1,
    'Under 20',
    5.00,
    200,
    80.00
),
(
    1,
    'Senior 10km',
    10.00,
    500,
    150.00
),
(
    1,
    'Veteran 10km',
    10.00,
    300,
    150.00
),

-- Soweto Community Walk
(
    2,
    'Junior Walk',
    5.00,
    150,
    50.00
),
(
    2,
    'Senior Walk',
    10.00,
    400,
    100.00
),

-- Cape Town Coastal Cycle
(
    3,
    'Junior Cycle',
    10.00,
    150,
    120.00
),
(
    3,
    'Senior Cycle',
    21.00,
    500,
    250.00
);
GO


/*
====================================================================
12. INSERT ROUTES
====================================================================

One route is associated with each event.
====================================================================
*/

INSERT INTO Routes
(
    EventID,
    RouteName,
    DistanceKM,
    ElevationGainM,
    RouteDescription,
    MapURL
)
VALUES
(
    1,
    'Durban Beachfront Route',
    10.00,
    85,
    'Flat coastal route starting and finishing near the Durban beachfront.',
    'https://example.com/routes/durban-sunrise'
),
(
    2,
    'Soweto Community Route',
    10.00,
    120,
    'Community route passing through key areas of Soweto.',
    'https://example.com/routes/soweto-community'
),
(
    3,
    'Cape Town Coastal Route',
    21.00,
    250,
    'Coastal cycling route with scenic views and moderate elevation.',
    'https://example.com/routes/cape-town-coastal'
);
GO


/*
====================================================================
13. INSERT EVENT ENROLMENTS
====================================================================

UserID 3 = Sipho Nkosi
UserID 4 = Nomsa Mthembu

Each Entry connects:
Participant -> Category -> Event
====================================================================
*/

INSERT INTO Entries
(
    UserID,
    CategoryID
)
VALUES
(
    3,
    2
),
(
    4,
    1
),
(
    3,
    5
),
(
    4,
    5
),
(
    3,
    7
);
GO


/*
====================================================================
14. INSERT RESULTS
====================================================================

Results are associated with Entries.
====================================================================
*/

INSERT INTO Results
(
    EntryID,
    FinishTime,
    OverallPosition,
    CategoryPosition,
    ResultStatus
)
VALUES
(
    1,
    '00:52:34',
    34,
    12,
    'Finished'
),
(
    2,
    '00:31:18',
    18,
    5,
    'Finished'
),
(
    3,
    '01:24:42',
    45,
    9,
    'Finished'
);
GO


/*
====================================================================
15. BASIC DATA VERIFICATION
====================================================================
*/

SELECT *
FROM Users;
GO

SELECT *
FROM Events;
GO

SELECT *
FROM Categories;
GO

SELECT *
FROM Routes;
GO

SELECT *
FROM Entries;
GO

SELECT *
FROM Results;
GO


/*
====================================================================
16. RELATIONSHIP VERIFICATION
====================================================================

Displays the complete Participant -> Entry -> Category -> Event
relationship.
====================================================================
*/

SELECT
    E.EntryID,
    U.FirstName + ' ' + U.LastName AS Participant,
    EV.EventName,
    C.CategoryName,
    E.EntryDate
FROM Entries AS E
INNER JOIN Users AS U
    ON E.UserID = U.UserID
INNER JOIN Categories AS C
    ON E.CategoryID = C.CategoryID
INNER JOIN Events AS EV
    ON C.EventID = EV.EventID
ORDER BY E.EntryID;
GO


/*
====================================================================
17. RESULTS VERIFICATION
====================================================================
*/

SELECT
    R.ResultID,
    U.FirstName + ' ' + U.LastName AS Participant,
    EV.EventName,
    C.CategoryName,
    R.FinishTime,
    R.OverallPosition,
    R.CategoryPosition,
    R.ResultStatus
FROM Results AS R
INNER JOIN Entries AS E
    ON R.EntryID = E.EntryID
INNER JOIN Users AS U
    ON E.UserID = U.UserID
INNER JOIN Categories AS C
    ON E.CategoryID = C.CategoryID
INNER JOIN Events AS EV
    ON C.EventID = EV.EventID
ORDER BY R.ResultID;
GO


/*
====================================================================
18. ROW COUNT VERIFICATION
====================================================================
*/

SELECT 'Users' AS TableName, COUNT(*) AS RecordCount
FROM Users

UNION ALL

SELECT 'Events', COUNT(*)
FROM Events

UNION ALL

SELECT 'Categories', COUNT(*)
FROM Categories

UNION ALL

SELECT 'Routes', COUNT(*)
FROM Routes

UNION ALL

SELECT 'Entries', COUNT(*)
FROM Entries

UNION ALL

SELECT 'Results', COUNT(*)
FROM Results;
GO


/*
====================================================================
                     END OF SCRIPT
====================================================================
*/