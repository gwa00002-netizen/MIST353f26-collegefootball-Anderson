f object_id('WeeklyPredictionResults', 'U') is not null drop table WeeklyPredictionResults;
if object_id('GamePrediction', 'U') is not null drop table GamePrediction;
if object_id('PlayerPosition', 'U') is not null drop table PlayerPosition;
if object_id('ReturnerStats', 'U') is not null drop table ReturnerStats;
if object_id('PunterStats', 'U') is not null drop table PunterStats;
if object_id('KickerStats', 'U') is not null drop table KickerStats;
if object_id('DefenderStats', 'U') is not null drop table DefenderStats;
if object_id('RBStats', 'U') is not null drop table RBStats;
if object_id('QBStats', 'U') is not null drop table QBStats;
if object_id('PlayerStats', 'U') is not null drop table PlayerStats;
if object_id('Player', 'U') is not null drop table Player;
if object_id('Position', 'U') is not null drop table Position;
if object_id('Roster', 'U') is not null drop table Roster;
if object_id('Coach', 'U') is not null drop table Coach;
if object_id('Game', 'U') is not null drop table Game;
if object_id('Stadium', 'U') is not null drop table Stadium;
if object_id('AppUser', 'U') is not null drop table AppUser;
if object_id('Team', 'U') is not null drop table Team;
go
 
 
create table Team(
    TeamId int identity(1,1) not null,
    TeamName char(50) not null,
    UniversityName varchar(50) not null,
    CurrentTeamRecord varchar(10) null,
    constraint PK_Team primary key (TeamId),
    constraint UQ_TeamName unique (TeamName)
);
go
 
create table Stadium(
    StadiumId int identity(1,1) not null,
    StadiumName char(50) not null,
    StadiumAddress varchar(50) not null,
    StadiumCapacity int not null,
    StadiumGrassType char(20) not null,
    TeamId int not null,
    constraint PK_Stadium primary key (StadiumId),
    constraint UQ_StadiumName unique (StadiumName),
    constraint FK_StadiumTeam foreign key (TeamId) references Team(TeamId),
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
    WinningTeamId int null,
    StadiumId int null,
    constraint PK_Game primary key (GameId),
    constraint UQ_GameDateTime unique (HomeTeamId, GameDate, GameTime),
    constraint FK_GameHomeTeam foreign key (HomeTeamId) references Team(TeamId),
    constraint FK_GameAwayTeam foreign key (AwayTeamId) references Team(TeamId),
    constraint FK_GameWinningTeam foreign key (WinningTeamId) references Team(TeamId),
    constraint FK_GameStadium foreign key (StadiumId) references Stadium(StadiumId),
    constraint CK_GameDifferentTeams check (HomeTeamId <> AwayTeamId)
);
go
 
create table Coach(
    CoachId int identity(1,1) not null,
    CoachName varchar(50) not null,
    constraint PK_Coach primary key (CoachId)
);
go
 
create table Roster(
    RosterId int identity(1,1) not null,
    TeamId int not null,
    CoachId int null,
    RosterYear int not null,
    RosterWins int null,
    RosterLosses int null,
    RosterTies int null,
    constraint PK_Roster primary key (RosterId),
    constraint UQ_RosterTeamYear unique (TeamId, RosterYear),
    constraint FK_RosterTeam foreign key (TeamId) references Team(TeamId),
    constraint FK_RosterCoach foreign key (CoachId) references Coach(CoachId)
);
go
 
create table Position(
    PositionId int identity(1,1) not null,
    PositionName char(20) not null,
    constraint PK_Position primary key (PositionId),
    constraint UQ_PositionName unique (PositionName),
    constraint CK_PositionName check (PositionName in ('Quarterback', 'Running Back', 'Wide Receiver', 'Tight End', 'Offensive Lineman', 'Defensive Lineman', 'Linebacker', 'Cornerback', 'Safety', 'Kicker', 'Punter', 'Returner'))
);
go
 
-- PlayerId is an identity, so SQL Server gives every player their own ID automatically.
-- Two players can share a name, but the same person (same name + same birthday) can't be entered twice.
create table Player(
    PlayerId int identity(1,1) not null,
    PlayerName char(50) not null,
    PlayerHeight varchar(10) not null,
    PlayerWeight int not null,
    PlayerDOB date not null,
    RosterId int not null,
    constraint PK_Player primary key (PlayerId),
    constraint FK_PlayerRoster foreign key (RosterId) references Roster(RosterId),
    constraint UQ_PlayerNameDOB unique (PlayerName, PlayerDOB)
);
go
 
create table PlayerPosition(
    PlayerPositionId int identity(1,1) not null,
    PlayerId int not null,
    PositionId int not null,
    constraint PK_PlayerPosition primary key (PlayerPositionId),
    constraint UQ_PlayerPosition unique (PlayerId, PositionId),
    constraint FK_PlayerPositionPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_PlayerPositionPosition foreign key (PositionId) references Position(PositionId)
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
    constraint PK_PlayerStats primary key (PlayerStatsId),
    constraint FK_PlayerStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_PlayerStatsRoster foreign key (RosterId) references Roster(RosterId)
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
    constraint PK_QBStats primary key (QBStatsId),
    constraint FK_QBStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_QBStatsRoster foreign key (RosterId) references Roster(RosterId)
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
    constraint PK_RBStats primary key (RBStatsId),
    constraint FK_RBStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_RBStatsRoster foreign key (RosterId) references Roster(RosterId)
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
    constraint PK_DefenderStats primary key (DefenderStatsId),
    constraint FK_DefenderStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_DefenderStatsRoster foreign key (RosterId) references Roster(RosterId)
);
go
 
create table KickerStats(
    KickerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    FieldGoalsMade int null,
    FieldGoalsAttempted int null,
    ExtraPointsMade int null,
    ExtraPointsAttempted int null,
    LongestFieldGoal int null,
    constraint PK_KickerStats primary key (KickerStatsId),
    constraint FK_KickerStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_KickerStatsRoster foreign key (RosterId) references Roster(RosterId)
);
go
 
create table PunterStats(
    PunterStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    Punts int null,
    PuntYards int null,
    LongestPunt int null,
    constraint PK_PunterStats primary key (PunterStatsId),
    constraint FK_PunterStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_PunterStatsRoster foreign key (RosterId) references Roster(RosterId)
);
go
 
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
    constraint PK_ReturnerStats primary key (ReturnerStatsId),
    constraint FK_ReturnerStatsPlayer foreign key (PlayerId) references Player(PlayerId),
    constraint FK_ReturnerStatsRoster foreign key (RosterId) references Roster(RosterId)
);
go
 
create table AppUser(
    AppUserId int identity(1,1) not null,
    AppUserName varchar(50) not null,
    Email varchar(100) not null,
    AppUserPassword varchar(255) not null,
    constraint PK_AppUser primary key (AppUserId),
    constraint UQ_AppUserName unique (AppUserName),
    constraint UQ_AppUserEmail unique (Email)
);
go
 
create table GamePrediction(
    GamePredictionId int identity(1,1) not null,
    AppUserId int not null,
    GameId int not null,
    PredictedWinnerTeamId int not null,
    GamePredictionDateTime datetime not null default getdate(),
    constraint PK_GamePrediction primary key (GamePredictionId),
    constraint UQ_GamePredictionUserGame unique (AppUserId, GameId),
    constraint FK_GamePredictionAppUser foreign key (AppUserId) references AppUser(AppUserId),
    constraint FK_GamePredictionGame foreign key (GameId) references Game(GameId),
    constraint FK_GamePredictionTeam foreign key (PredictedWinnerTeamId) references Team(TeamId)
);
go
 
create table WeeklyPredictionResults(
    WPRId int identity(1,1) not null,
    AppUserId int not null,
    StartDate date not null,
    NumberOfCorrectPredictions int not null default 0,
    constraint PK_WeeklyPredictionResults primary key (WPRId),
    constraint UQ_WPRUserWeek unique (AppUserId, StartDate),
    constraint FK_WPRAppUser foreign key (AppUserId) references AppUser(AppUserId)
);
go
 
select table_name
from information_schema.tables
where table_type = 'BASE TABLE'
order by table_name;