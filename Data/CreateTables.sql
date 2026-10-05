
/*
IF OBJECT_ID('Game', 'U') IS NOT NULL DROP TABLE Game;
IF OBJECT_ID('Team', 'U') IS NOT NULL DROP TABLE Team;
IF OBJECT_ID('Stadium', 'U') IS NOT NULL DROP TABLE Stadium;

CREATE TABLE Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState VARCHAR(50) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    StadiumLocation VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Stadium PRIMARY KEY (StadiumID),
    CONSTRAINT UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    CONSTRAINT CK_Stadium_FieldType CHECK (TypeOfField IN ('Grass', 'Artificial Turf')),
    CONSTRAINT CK_Stadium_Capacity CHECK (StadiumCapacity > 0)
);

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_UniversityName UNIQUE (UniversityName),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

CREATE TABLE Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate DATE NOT NULL,
    GameTime TIME NOT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    CONSTRAINT PK_Game PRIMARY KEY (GameID),
    CONSTRAINT UQ_Game UNIQUE (GameDate, GameTime, HomeTeamID),
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    CONSTRAINT CK_Game_DifferentTeams CHECK (HomeTeamID <> AwayTeamID)
);

*/


CREATE TABLE Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(100) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID),
    CONSTRAINT UQ_Player UNIQUE (PlayerName, PlayerDateOfBirth)
);

CREATE TABLE Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    RosterYear INT NOT NULL,
    PlayerID INT NOT NULL,
    TeamID INT NOT NULL,
    Position VARCHAR(50) NOT NULL,
    CurrentTeamRecord VARCHAR(10) NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (RosterYear, PlayerID, TeamID),
    CONSTRAINT FK_Roster_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    CONSTRAINT CK_Roster_Year CHECK (RosterYear >= 1869)
);

CREATE TABLE PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    RosterID INT NOT NULL,
    GameID INT NOT NULL,
    Position VARCHAR(50) NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT UQ_PlayerStats UNIQUE (RosterID, GameID, Position),
    CONSTRAINT FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID),
    CONSTRAINT FK_PlayerStats_Game FOREIGN KEY (GameID) REFERENCES Game(GameID)
);

CREATE TABLE QBStats (
    PlayerStatsID INT NOT NULL,
    Attempts INT NOT NULL DEFAULT 0,
    Completions INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    INTs INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_QBStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_QBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_QBStats_Completions CHECK (Completions >= 0 AND Completions <= Attempts),
    CONSTRAINT CK_QBStats_NonNegative CHECK (Attempts >= 0 AND TDs >= 0 AND INTs >= 0)
);

CREATE TABLE RBStats (
    PlayerStatsID INT NOT NULL,
    Carries INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    Fumbles INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_RBStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_RBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_RBStats_NonNegative CHECK (Carries >= 0 AND TDs >= 0 AND Fumbles >= 0)
);

CREATE TABLE DefenderStats (
    PlayerStatsID INT NOT NULL,
    Tackles INT NOT NULL DEFAULT 0,
    Sacks DECIMAL(3,1) NOT NULL DEFAULT 0,
    INTs INT NOT NULL DEFAULT 0,
    ForcedFumbles INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_DefenderStats_NonNegative CHECK (Tackles >= 0 AND Sacks >= 0 AND INTs >= 0 AND ForcedFumbles >= 0 AND TDs >= 0)
);

CREATE TABLE ReturnerStats (
    PlayerStatsID INT NOT NULL,
    KickReturns INT NOT NULL DEFAULT 0,
    KickReturnYards INT NOT NULL DEFAULT 0,
    PuntReturns INT NOT NULL DEFAULT 0,
    PuntReturnYards INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_ReturnerStats_NonNegative CHECK (KickReturns >= 0 AND PuntReturns >= 0 AND TDs >= 0)
);

CREATE TABLE KickerStats (
    PlayerStatsID INT NOT NULL,
    FGAttempts INT NOT NULL DEFAULT 0,
    FGMade INT NOT NULL DEFAULT 0,
    XPAttempts INT NOT NULL DEFAULT 0,
    XPMade INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_KickerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_KickerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_KickerStats_FG CHECK (FGMade >= 0 AND FGMade <= FGAttempts),
    CONSTRAINT CK_KickerStats_XP CHECK (XPMade >= 0 AND XPMade <= XPAttempts),
    CONSTRAINT CK_KickerStats_Long CHECK (Long >= 0)
);

CREATE TABLE PunterStats (
    PlayerStatsID INT NOT NULL,
    Punts INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    Inside20 INT NOT NULL DEFAULT 0,
    Touchbacks INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_PunterStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    CONSTRAINT CK_PunterStats_NonNegative CHECK (Punts >= 0 AND Long >= 0 AND Inside20 >= 0 AND Touchbacks >= 0)
);
/*
CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor';


CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
