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
    SELECT T.UniversityName, T.TeamName
    FROM Conference C
    JOIN Team T ON C.ConferenceID = T.ConferenceID
    WHERE C.ConferenceName = @ConferenceName;
end;
    

execute procGetAllTeamsInAConference @ConferenceName = 'Big 12';