
from fastapi import FastAPI
From get_all_teams_by_conference import get_all_teams_by_conference
app= FastAPI()

@app.get("/api/teams")
def get_teams(conference:str):
    teams = get_all_teams_by_conference(conference)
    return teams