from get_db_connection import get_db_connection


def get_all_teams_by_conference(conference: str):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)  # rows come back as {"UniversityName": ..., "TeamName": ...}

    # fetch all teams for the given conference
    cursor.execute(
        "EXEC procGetAllTeamsInAConference @ConferenceName = %s",
        (conference,),
    )
    teams = cursor.fetchall()

    cursor.close()
    conn.close()
    return teams

teams = get_all_teams_by_conference("Big 12")

#convert the list of teams to a list of dicionaries
teams_list = []
for each_team in teams:
    teams_list.append({
        "UniversityName": each_team["UniversityName"],
        "TeamName": each_team["TeamName"],
        "Conference": each_team["ConferenceName"],
    })

print(teams_list)