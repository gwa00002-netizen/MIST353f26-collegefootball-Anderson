SELECT * from conference;
SELECT * from stadium;
SELECT * from team;
SELECT * from game;


-- Stored procedure

go

Create or Alter Procedure procGetAllTeamsInAConference
(
    @ConferenceName NVARCHAR(100)
)
as
begin
    SELECT T.UniversityName, T.TeamName, S.StadiumCity, S.StadiumState, C.ConferenceName
    FROM Conference C
    JOIN Team T ON C.ConferenceID = T.ConferenceID
    JOIN Stadium S ON T.StadiumID = S.StadiumID
    WHERE C.ConferenceName = @ConferenceName;
end;
    
    GO

    Create or Alter Procedure procGetAllTeamsByConference
(
    @ConferenceName NVARCHAR(100)
)
as
begin
    SELECT T.UniversityName, T.TeamName
    FROM Conference C
    JOIN Team T ON C.ConferenceID = T.ConferenceID
   -- WHERE C.ConferenceName is null or ConferenceName = (@ConferenceName,ConferenceName);
   where ConferenceName = IsNULL(@ConferenceName, ConferenceName);
end;



    
/*
execute procGetAllTeamsByConference @ConferenceName = 'Big 12';
*/

--create procedure for update game scores next class`