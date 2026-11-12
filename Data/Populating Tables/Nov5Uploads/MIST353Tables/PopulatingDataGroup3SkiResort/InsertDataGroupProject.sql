SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;

DROP TABLE IF EXISTS dbo.UserPreferences;
DROP TABLE IF EXISTS dbo.SkiResortExplorerUser;

-- MIST353F26 Group 3 - Ski Resort Explorer
-- Builds the tables from the Lucidchart class diagram.
-- Run against: mist353f26group3 (check the bottom bar - NOT master)

-- Drop in child-first order so foreign keys don't block anything
IF OBJECT_ID('dbo.ResortComparisonResort', 'U') IS NOT NULL DROP TABLE dbo.ResortComparisonResort;
IF OBJECT_ID('dbo.ResortComparison', 'U') IS NOT NULL DROP TABLE dbo.ResortComparison;
IF OBJECT_ID('dbo.Favorite', 'U') IS NOT NULL DROP TABLE dbo.Favorite;
IF OBJECT_ID('dbo.Booking', 'U') IS NOT NULL DROP TABLE dbo.Booking;
IF OBJECT_ID('dbo.UserPreference', 'U') IS NOT NULL DROP TABLE dbo.UserPreference;
IF OBJECT_ID('dbo.UserPreferences', 'U') IS NOT NULL DROP TABLE dbo.UserPreferences;
IF OBJECT_ID('dbo.RunProfile', 'U') IS NOT NULL DROP TABLE dbo.RunProfile;
IF OBJECT_ID('dbo.SkiResortExplorerUser', 'U') IS NOT NULL DROP TABLE dbo.SkiResortExplorerUser;
IF OBJECT_ID('dbo.Resort', 'U') IS NOT NULL DROP TABLE dbo.Resort;
GO

CREATE TABLE dbo.Resort (
    ResortID INT NOT NULL IDENTITY(1,1),
    ResortName NVARCHAR(100) NOT NULL,
    ResortCity NVARCHAR(50) NULL,
    ResortState NVARCHAR(50) NULL,
    ResortCountry NVARCHAR(50) NULL,
    ResortZipCode NVARCHAR(10) NULL,
    ResortStreetAddress NVARCHAR(150) NULL,
    ResortVerticalDrop INT NULL,
    ResortTrailCount INT NULL,
    ResortSkiableAcres INT NULL,
    ResortLiftCount INT NULL,
    ResortAverageSnowFall DECIMAL(6,2) NULL,
    ResortPrice DECIMAL(10,2) NULL,
    CONSTRAINT PK_Resort PRIMARY KEY (ResortID),
    CONSTRAINT UQ_Resort UNIQUE (ResortName, ResortState)
);
GO

-- RunProfile + RunTypeQty: how many runs of each terrain type a resort has
CREATE TABLE dbo.RunProfile (
    RunProfileID INT NOT NULL IDENTITY(1,1),
    ResortID INT NOT NULL,
    TerrainType NVARCHAR(50) NOT NULL,
    NumOfRuns INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_RunProfile PRIMARY KEY (RunProfileID),
    CONSTRAINT UQ_RunProfile UNIQUE (ResortID, TerrainType),
    CONSTRAINT FK_RunProfile_Resort FOREIGN KEY (ResortID) REFERENCES dbo.Resort(ResortID)
);
GO

-- "User" is a reserved word in SQL Server, so the table keeps the group's existing name
CREATE TABLE dbo.SkiResortExplorerUser (
    UserID INT NOT NULL IDENTITY(1,1),
    UserFirstName NVARCHAR(50) NOT NULL,
    UserLastName NVARCHAR(50) NOT NULL,
    UserEmail NVARCHAR(100) NOT NULL,
    UserPassword NVARCHAR(255) NOT NULL,
    UserState NVARCHAR(50) NULL,
    UserStreet NVARCHAR(150) NULL,
    UserZipCode NVARCHAR(10) NULL,
    CONSTRAINT PK_SkiResortExplorerUser PRIMARY KEY (UserID),
    CONSTRAINT UQ_SkiResortExplorerUser_Email UNIQUE (UserEmail)
);
GO

-- 0..1 per user: the weights used to rank resorts
CREATE TABLE dbo.UserPreference (
    PreferenceID INT NOT NULL IDENTITY(1,1),
    UserID INT NOT NULL,
    PriceWeight INT NOT NULL DEFAULT 0,
    SnowfallWeight INT NOT NULL DEFAULT 0,
    TerrainWeight INT NOT NULL DEFAULT 0,
    RunsAvailableWeight INT NOT NULL DEFAULT 0,
    DistanceFromHomeWeight INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_UserPreference PRIMARY KEY (PreferenceID),
    CONSTRAINT UQ_UserPreference_User UNIQUE (UserID),
    CONSTRAINT FK_UserPreference_User FOREIGN KEY (UserID) REFERENCES dbo.SkiResortExplorerUser(UserID)
);
GO

CREATE TABLE dbo.Booking (
    BookingID INT NOT NULL IDENTITY(1,1),
    ResortID INT NOT NULL,
    UserID INT NOT NULL,
    BookingDate DATETIME2 NOT NULL,
    GuestCount INT NOT NULL DEFAULT 1,
    TotalCost DECIMAL(10,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT PK_Booking PRIMARY KEY (BookingID),
    CONSTRAINT FK_Booking_Resort FOREIGN KEY (ResortID) REFERENCES dbo.Resort(ResortID),
    CONSTRAINT FK_Booking_User FOREIGN KEY (UserID) REFERENCES dbo.SkiResortExplorerUser(UserID),
    CONSTRAINT CK_Booking_Status CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled'))
);
GO

CREATE TABLE dbo.Favorite (
    FavoriteID INT NOT NULL IDENTITY(1,1),
    UserID INT NOT NULL,
    ResortID INT NOT NULL,
    DateAdded DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Favorite PRIMARY KEY (FavoriteID),
    CONSTRAINT UQ_Favorite UNIQUE (UserID, ResortID),
    CONSTRAINT FK_Favorite_User FOREIGN KEY (UserID) REFERENCES dbo.SkiResortExplorerUser(UserID),
    CONSTRAINT FK_Favorite_Resort FOREIGN KEY (ResortID) REFERENCES dbo.Resort(ResortID)
);
GO

-- A user's saved comparison...
CREATE TABLE dbo.ResortComparison (
    ComparisonID INT NOT NULL IDENTITY(1,1),
    UserID INT NOT NULL,
    DateCreated DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ResortComparison PRIMARY KEY (ComparisonID),
    CONSTRAINT FK_ResortComparison_User FOREIGN KEY (UserID) REFERENCES dbo.SkiResortExplorerUser(UserID)
);
GO

-- ...and the resorts in it (the diagram's List<Resort>)
CREATE TABLE dbo.ResortComparisonResort (
    ComparisonID INT NOT NULL,
    ResortID INT NOT NULL,
    CONSTRAINT PK_ResortComparisonResort PRIMARY KEY (ComparisonID, ResortID),
    CONSTRAINT FK_RCR_Comparison FOREIGN KEY (ComparisonID) REFERENCES dbo.ResortComparison(ComparisonID),
    CONSTRAINT FK_RCR_Resort FOREIGN KEY (ResortID) REFERENCES dbo.Resort(ResortID)
);
GO

