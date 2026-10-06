if object_id('Team', 'U') is not null drop table Team;
if object_id('Stadium', 'U') is not null drop table Stadium;    
if object_id('Game', 'U') is not null drop table Game;
if object_id('AppUser', 'U') is not null drop table AppUser;
if object_id('Roster', 'U') is not null drop table Roster;
if object_id('Player', 'U') is not null drop table Player;
if object_id('PlayerStats', 'U') is not null drop table PlayerStats;
if object_id('QBStats', 'U') is not null drop table QBStats;
if object_id('RBStats', 'U') is not null drop table RBStats;
if object_id('DefenderStats', 'U') is not null drop table DefenderStats;
if object_id('KickerStats', 'U') is not null drop table KickerStats;
if object_id('PunterStats', 'U') is not null drop table PunterStats
if object_id('ReturnerStats', 'U') is not null drop table ReturnerStats;
go
create table Team(
    TeamId int identity(1,1) not null,
    TeamName char(50) not null,
    UniversityName varchar(50) not null,
    CurrentTeamRecord varchar(10) null,
    CONSTRAINT UQ_TeamName unique (TeamName),
    constraint PK_Team primary key (TeamId),
);
go
create table Stadium(
    StadiumId int identity(1,1) not null,
    StadiumName char(50) not null,
    StadiumAddress varchar(50) not null,
    StadiumCapacity int not null,
    StadiumGrassType char(20) not null,
    TeamId int not null,
    foreign key (TeamId) references Team(TeamId),
    CONSTRAINT UQ_StadiumName unique (StadiumName),
    constraint PK_Stadium primary key (StadiumId),
    constraint CK_TypeOfGrass check (StadiumGrassType in ('Artificial Turf', 'Grass'))
);
go
create table Game(
    GameId int identity(1,1) not null,
    GameDate date not null,
    GameTime time not null,
    HomeScore int null,
    AwayScore int null,
    HomeTeamId int not null,
    AwayTeamId int not null,
    StadiumId int null,
    foreign key (HomeTeamId) references Team(TeamId),
    foreign key (AwayTeamId) references Team(TeamId),
    foreign key (StadiumId) references Stadium(StadiumId),
    CONSTRAINT FK_GameHomeTeam foreign key (HomeTeamId) references Team(TeamId),
    CONSTRAINT FK_GameAwayTeam foreign key (AwayTeamId) references Team(TeamId),
    constraint UQ_GameDateTime unique (HomeTeamId, GameDate, GameTime),
    constraint PK_Game primary key (GameId),
);
go
create table Roster(
    RosterId int identity(1,1) not null,
    TeamId int not null,
    RosterYear int not null,
    RosterWins int null,
    RosterLosses int null,
    RosterTies int null,
    foreign key (TeamId) references Team(TeamId),
    constraint PK_Roster primary key (RosterId),
);
go
create table Player(
    PlayerId int identity(1,1) not null,
    PlayerName char(50) not null,
    PlayerPosition char(20) not null,
    PlayerHeight varchar(10) not null,
    PlayerWeight int not null,
    PlayerDOB date not null,
    RosterId int not null,
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_Player primary key (PlayerId),
);
go
create table PlayerStats(
    PlayerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    PassingYards int null,
    RushingYards int null,
    ReceivingYards int null,
    Touchdowns int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_PlayerStats primary key (PlayerStatsId),
);
go
create table QBStats(
    QBStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    PassingAttempts int null,
    PassingCompletions int null,
    PassingYards int null,
    PassingTouchdowns int null,
    Interceptions int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_QBStats primary key (QBStatsId),
);
go
create table RBStats(
    RBStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    RushingAttempts int null,
    RushingYards int null,
    RushingTouchdowns int null,
    LongestRush int null,
    Fumbles int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_RBStats primary key (RBStatsId),
);
go
create table DefenderStats(
    DefenderStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    Tackles int null,
    Sacks int null,
    Interceptions int null,
    ForcedFumbles int null,
    DefensiveTouchdowns int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_DefenderStats primary key (DefenderStatsId),
);
GO
create table KickerStats(
    KickerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    FieldGoalsMade int null,
    FieldGoalsAttempted int null,
    ExtraPointsMade int null,
    ExtraPointsAttempted int null,
    LongestFieldGoal int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_KickerStats primary key (KickerStatsId),
);
GO
create table PunterStats(
    PunterStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    Punts int null,
    PuntYards int null,
    LongestPunt int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_PunterStats primary key (PunterStatsId),
);
GO
create table ReturnerStats(
    ReturnerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    KickReturns int null,
    KickReturnYards int null,
    KickReturnLong int null,
    KickReturnTouchdowns int null,
    PuntReturns int null,
    PuntReturnYards int null,
    PuntReturnTouchdowns int null,
    PuntReturnLong int null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_ReturnerStats primary key (ReturnerStatsId),
);




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

/*
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

CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor';


CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
