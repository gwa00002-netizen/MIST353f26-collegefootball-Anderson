
if object_id('TeamCoach', 'U') is not null drop table TeamCoach;
if object_id('Coach', 'U') is not null drop table Coach;
if object_id('GamePrediction', 'U') is not null drop table GamePrediction;
if object_id('WeeklyPredictionResults', 'U') is not null drop table WeeklyPredictionResults;
if object_id('AppUser', 'U') is not null drop table AppUser;
if object_id('ReturnerStats', 'U') is not null drop table ReturnerStats;
if object_id('PunterStats', 'U') is not null drop table PunterStats;
if object_id('KickerStats', 'U') is not null drop table KickerStats;
if object_id('DefenderStats', 'U') is not null drop table DefenderStats;
if object_id('RBStats', 'U') is not null drop table RBStats;
if object_id('QBStats', 'U') is not null drop table QBStats;
if object_id('PlayerStats', 'U') is not null drop table PlayerStats;
if object_id('Position', 'U') is not null drop table Position;
if object_id('Player', 'U') is not null drop table Player;
if object_id('Roster', 'U') is not null drop table Roster;
if object_id('AppUser', 'U') is not null drop table AppUser;
if object_id('Game', 'U') is not null drop table Game;
if object_id('Stadium', 'U') is not null drop table Stadium;
if object_id('Team', 'U') is not null drop table Team;
if object_id('Conference', 'U') is not null drop table Conference;
go
create table Conference(
    ConferenceId int identity(1,1) not null,
    ConferenceName char(50) not null,
    CONSTRAINT UQ_ConferenceName unique (ConferenceName),
    constraint PK_Conference primary key (ConferenceId),
)
go
create table Team(
    TeamId int identity(1,1) not null,
    TeamName char(50) not null,
    ConferenceId int not null,
    UniversityName varchar(50) not null,
    CurrentTeamRecord varchar(10) null,
    foreign key (ConferenceId) references Conference(ConferenceId),
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
    RosterWins int not null,
    RosterLosses int not null,
    RosterTies int not null,
    foreign key (TeamId) references Team(TeamId),
    constraint PK_Roster primary key (RosterId),
);
go
create table Player(
    PlayerId int identity(1,1) not null,
    PlayerName char(50) not null,
    PlayerDOB date not null,
    constraint PK_Player primary key (PlayerId),
    constraint UQ_PlayerName unique (PlayerName, PlayerDOB),
);
go
create table Position(
    PositionId int identity(1,1) not null,
    PositionName char(50) not null,
    constraint PK_Position primary key (PositionId),
    constraint UQ_PositionName unique (PositionName),
    constraint CK_PositionName check (PositionName in ('QB', 'RB', 'WR', 'TE', 'OL', 'DL', 'LB', 'CB', 'S', 'K', 'P', 'R'))
)
create table PlayerStats(
    PlayerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_PlayerStats primary key (PlayerStatsId),
    constraint UQ_PlayerRoster unique (PlayerId, RosterId)
);
go
create table QBStats(
    QBStatsId int not null,
    PassingAttempts int not null,
    PassingCompletions int not null,
    PassingYards int not null,
    PassingTouchdowns int not null,
    Interceptions int not null,
    constraint PK_QBStats primary key (QBStatsId),
    constraint FK_QBStats_PlayerStats foreign key (QBStatsId) references PlayerStats(PlayerStatsId),
);
go
create table RBStats(
    RBStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    RushingAttempts int not null,
    RushingYards int not null,
    RushingTouchdowns int not null,
    LongestRush int not null,
    Fumbles int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_RBStats primary key (RBStatsId),
);
go
create table DefenderStats(
    DefenderStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    Tackles int not null,
    Sacks int not null,
    Interceptions int not null,
    ForcedFumbles int not null,
    DefensiveTouchdowns int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_DefenderStats primary key (DefenderStatsId),
);
GO
create table KickerStats(
    KickerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    FieldGoalsMade int not null,
    FieldGoalsAttempted int not null,
    ExtraPointsMade int not null,
    ExtraPointsAttempted int not null,
    LongestFieldGoal int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_KickerStats primary key (KickerStatsId),
);
GO
create table PunterStats(
    PunterStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    Punts int not null,
    PuntYards int not null,
    LongestPunt int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_PunterStats primary key (PunterStatsId),
);
GO
create table ReturnerStats(
    ReturnerStatsId int identity(1,1) not null,
    PlayerId int not null,
    RosterId int not null,
    KickReturns int not null,
    KickReturnYards int not null,
    KickReturnLong int not null,
    KickReturnTouchdowns int not null,
    PuntReturns int not null,
    PuntReturnYards int not null,
    PuntReturnTouchdowns int not null,
    PuntReturnLong int not null,
    foreign key (PlayerId) references Player(PlayerId),
    foreign key (RosterId) references Roster(RosterId),
    constraint PK_ReturnerStats primary key (ReturnerStatsId),
);
go
create table AppUser(
    UserId int identity(1,1) not null,
    UserFName char(50) not null,
    UserLName char(50) not null,
    UserDOB date not null,
    UserEmail varchar(50) not null,
    UserRole char(50) not null,
    CONSTRAINT UQ_UserEmail unique (UserEmail),
    constraint PK_AppUser primary key (UserId),
);
go
create table WeeklyPredictionResults(
    WeeklyPredictionResultsId int identity(1,1) not null,
    UserId int not null,
    StartDate date not null,
    TeamId int not null,
    NumberOfCorrectPredictions int not null,
    TotalDifferenceFromPredictedMargins int not null,
    foreign key (TeamId) references Team(TeamId),
    foreign key (UserId) references AppUser(UserId),
    constraint PK_WeeklyPredictionResults primary key (WeeklyPredictionResultsId),
);
go
create table GamePrediction(
    GamePredictionId int identity(1,1) not null,
    UserId int not null,
    GameId int not null,
    PredictionDateTime datetime not null,
    PredictedMargin int not null,
    foreign key (UserId) references AppUser(UserId),
    foreign key (GameId) references Game(GameId),
    constraint PK_GamePrediction primary key (GamePredictionId),
);
GO
create table Coach(
    CoachId int identity(1,1) not null,
    CoachName char(50) not null,    
    constraint PK_Coach primary key (CoachId),
);
GO
create table TeamCoach(
    TeamCoachId int identity(1,1) not null,
    TeamId int not null,
    CoachId int not null,
    CoachRole char(50) not null,
    foreign key (TeamId) references Team(TeamId),
    foreign key (CoachId) references Coach(CoachId),
    constraint PK_TeamCoach primary key (TeamCoachId),
);
