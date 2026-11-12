IF object_id('TeamCoach', 'U') IS NOT NULL DROP TABLE TeamCoach;
IF object_id('WRStats', 'U') IS NOT NULL DROP TABLE WRStats;
IF object_id('GamePrediction', 'U') IS NOT NULL DROP TABLE GamePrediction;
IF object_id('CoachRoster', 'U') IS NOT NULL DROP TABLE CoachRoster;
IF object_id('Coach', 'U') IS NOT NULL DROP TABLE Coach;
IF object_id('ReturnerStats', 'U') IS NOT NULL DROP TABLE ReturnerStats;
IF object_id('PunterStats', 'U') IS NOT NULL DROP TABLE PunterStats;
IF object_id('KickerStats', 'U') IS NOT NULL DROP TABLE KickerStats;
IF object_id('DefenderStats', 'U') IS NOT NULL DROP TABLE DefenderStats;
IF object_id('RBStats', 'U') IS NOT NULL DROP TABLE RBStats;
IF object_id('QBStats', 'U') IS NOT NULL DROP TABLE QBStats;
IF object_id('PlayerStats', 'U') IS NOT NULL DROP TABLE PlayerStats;
IF object_id('WeeklyPredictionResults', 'U') IS NOT NULL DROP TABLE WeeklyPredictionResults;
IF object_id('Game', 'U') IS NOT NULL DROP TABLE Game;
IF object_id('WeeklyGamesOfInterest', 'U') IS NOT NULL DROP TABLE WeeklyGamesOfInterest;
IF object_id('AppUserTeam') IS NOT NULL DROP TABLE AppUserTeam;
IF object_id('AppUser') IS NOT NULL DROP TABLE AppUser;
IF object_id('Roster') IS NOT NULL DROP TABLE Roster;
IF object_id('Team') IS NOT NULL DROP TABLE Team;
IF object_id('Stadium') IS NOT NULL DROP TABLE Stadium;
IF object_id('PlayerPosition') IS NOT NULL DROP TABLE PlayerPosition;
IF object_id('Player') IS NOT NULL DROP TABLE Player;
IF object_id('Position') IS NOT NULL DROP TABLE Position;
IF object_id('Conference') IS NOT NULL DROP TABLE Conference;

GO

CREATE TABLE Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName NVARCHAR(50) NOT NULL,
    StadiumCity NVARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Stadium PRIMARY KEY (StadiumID),
    CONSTRAINT UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    CONSTRAINT CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

GO

CREATE TABLE Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Conference PRIMARY KEY (ConferenceID),
    CONSTRAINT UQ_Conference UNIQUE (ConferenceName)
);

GO

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName NVARCHAR(50) NOT NULL,
    TeamName NVARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    ConferenceID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_UniversityName UNIQUE (UniversityName),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    CONSTRAINT FK_Team_Conference FOREIGN KEY (ConferenceID) REFERENCES Conference(ConferenceID)
);

GO

CREATE TABLE WeeklyGamesOfInterest(
        WeeklyGamesOfInterestID INT NOT NULL IDENTITY(1,1),
    WeekStartDate DATE,
    CONSTRAINT PK_WeeklyGamesOfInterest PRIMARY KEY (WeeklyGamesOfInterestID),
    CONSTRAINT UQ_WeeklyGamesOfInterest UNIQUE (WeekStartDate)
);

GO

CREATE TABLE Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate DATE NOT NULL,
    GameTime TIME NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
        WeeklyGamesOfInterestID INT NOT NULL,
    CONSTRAINT PK_Game PRIMARY KEY (GameID),
    CONSTRAINT UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    CONSTRAINT FK_Game_WeeklyGamesOfInterest FOREIGN KEY (WeeklyGamesOfInterestID) REFERENCES WeeklyGamesOfInterest(WeeklyGamesOfInterestID)
);

GO

CREATE TABLE AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    AppUserEmail NVARCHAR(50) NOT NULL,
    AppUserPassword NVARCHAR(50) NOT NULL,
    AppUserRole NVARCHAR(50) NOT NULL DEFAULT 'User',
    CONSTRAINT CK_AppUserRole CHECK (AppUserRole IN ('Admin', 'User')),
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserID),
    CONSTRAINT UQ_AppUser UNIQUE (AppUserEmail)
);

GO

CREATE TABLE AppUserTeam (
    AppUserTeamID INT NOT NULL IDENTITY(1,1),
    TeamID INT NOT NULL,
    AppUserID INT NOT NULL,
    CONSTRAINT PK_AppUserTeam PRIMARY KEY (AppUserTeamID),
    CONSTRAINT UQ_AppUserTeam UNIQUE (TeamID, AppUserID),
    CONSTRAINT FK_AppUserTeam_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_AppUserTeam_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

GO

CREATE TABLE WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL DEFAULT GETDATE(),
    NumberOfCorrectPredictions INT NOT NULL DEFAULT 0,
    AppUserID INT NOT NULL,
    CONSTRAINT PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID), 
    CONSTRAINT FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    CONSTRAINT UQ_WeeklyPredictionResults UNIQUE (AppUserID, StartDate)
);

GO

CREATE TABLE Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID),
    CONSTRAINT UQ_Player UNIQUE (PlayerName)
);

GO

CREATE TABLE Position(
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Position PRIMARY KEY (PositionID),
    CONSTRAINT UQ_Position UNIQUE (PositionName),
    CONSTRAINT CK_Position CHECK (PositionName IN ('QB', 'RB', 'WR', 'TE', 'OL', 'DL', 'LB', 'CB', 'S', 'K', 'P'))
);

GO

CREATE TABLE PlayerPosition (
    PlayerPositionID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_PlayerPosition PRIMARY KEY (PlayerPositionID),
    CONSTRAINT UQ_PlayerPosition UNIQUE (PlayerID, PositionID),
    CONSTRAINT FK_PlayerPosition_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerPosition_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

GO
 
CREATE TABLE Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    RosterYear INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (TeamID, RosterYear),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

GO

CREATE TABLE PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT UQ_PlayerStats UNIQUE (PlayerID, RosterID),
    CONSTRAINT FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

GO

CREATE TABLE QBStats(
    QBStatsID INT NOT NULL,
    PassingAttempts INT NOT NULL DEFAULT 0,
    PassingCompletions INT NOT NULL DEFAULT 0,
    PassingYards INT NOT NULL DEFAULT 0,
    PassingTouchdowns INT NOT NULL DEFAULT 0,
    Interceptions INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_QBStats PRIMARY KEY (QBStatsID),
    CONSTRAINT FK_QBStats_PlayerStats FOREIGN KEY (QBStatsID) 
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE RBStats(
    RBStatsId INT NOT NULL,
    RushingAttempts INT NOT NULL DEFAULT 0,
    RushingYards INT NOT NULL DEFAULT 0,
    RushingTouchdowns INT NOT NULL DEFAULT 0,
    LongestRush INT NOT NULL DEFAULT 0,
    Fumbles INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_RBStats PRIMARY KEY (RBStatsId),
    CONSTRAINT FK_RBStats_PlayerStats FOREIGN KEY (RBStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE WRStats(
    WRStatsId INT NOT NULL,
    Receptions INT NOT NULL DEFAULT 0,
    ReceivingYards INT NOT NULL DEFAULT 0,
    ReceivingTouchdowns INT NOT NULL DEFAULT 0,
    LongestReception INT NOT NULL DEFAULT 0,
    Fumbles INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_WRStats PRIMARY KEY (WRStatsId),
    CONSTRAINT FK_WRStats_PlayerStats FOREIGN KEY (WRStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE DefenderStats(
    DefenderStatsId INT NOT NULL,
    Tackles INT NOT NULL DEFAULT 0,
    Sacks INT NOT NULL DEFAULT 0,
    Interceptions INT NOT NULL DEFAULT 0,
    ForcedFumbles INT NOT NULL DEFAULT 0,
    DefensiveTouchdowns INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (DefenderStatsId),
    CONSTRAINT FK_DefenderStats_PlayerStats FOREIGN KEY (DefenderStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE KickerStats(
    KickerStatsId INT NOT NULL,
    FieldGoalsMade INT NOT NULL DEFAULT 0,
    FieldGoalsAttempted INT NOT NULL DEFAULT 0,
    ExtraPointsMade INT NOT NULL DEFAULT 0,
    ExtraPointsAttempted INT NOT NULL DEFAULT 0,
    LongestFieldGoal INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_KickerStats PRIMARY KEY (KickerStatsId),
    CONSTRAINT FK_KickerStats_PlayerStats FOREIGN KEY (KickerStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE PunterStats(
    PunterStatsId INT NOT NULL,
    Punts INT NOT NULL DEFAULT 0,
    PuntYards INT NOT NULL DEFAULT 0,
    LongestPunt INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PunterStatsId),
    CONSTRAINT FK_PunterStats_PlayerStats FOREIGN KEY (PunterStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE ReturnerStats(
    ReturnerStatsId INT NOT NULL,
    KickReturns INT NOT NULL DEFAULT 0,
    KickReturnYards INT NOT NULL DEFAULT 0,
    KickReturnLong INT NOT NULL DEFAULT 0,
    KickReturnTouchdowns INT NOT NULL DEFAULT 0,
    PuntReturns INT NOT NULL DEFAULT 0,
    PuntReturnYards INT NOT NULL DEFAULT 0,
    PuntReturnTouchdowns INT NOT NULL DEFAULT 0,
    PuntReturnLong INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (ReturnerStatsId),
    CONSTRAINT FK_ReturnerStats_PlayerStats FOREIGN KEY (ReturnerStatsId)
        REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
    CONSTRAINT UQ_Coach UNIQUE (CoachName)
);

GO

CREATE TABLE CoachRoster (
    CoachRosterID INT NOT NULL IDENTITY(1,1),
    CoachID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_CoachRoster PRIMARY KEY (CoachRosterID),
    CONSTRAINT UQ_CoachRoster UNIQUE (CoachID, RosterID),
    CONSTRAINT FK_CoachRoster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID),
    CONSTRAINT FK_CoachRoster_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

GO

CREATE TABLE GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    GameID INT NOT NULL,
    AppUserID INT NOT NULL,
    PredictedWinnerTeamID INT NOT NULL,
    PredictedMargin INT NOT NULL,
    PredictionDateTime DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
    CONSTRAINT UQ_GamePrediction UNIQUE (GameID, AppUserID),
    CONSTRAINT FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    CONSTRAINT FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    CONSTRAINT FK_GamePrediction_PredictedWinnerTeam FOREIGN KEY (PredictedWinnerTeamID) REFERENCES Team(TeamID)
);



