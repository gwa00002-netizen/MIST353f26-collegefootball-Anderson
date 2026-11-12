--populating Data
"""
Load the Resort and RunProfile tables for Group 3 from a ski resort API.
 
Same pattern as load_teams.py:
  fetch from API -> cache the JSON -> get-or-create each row -> commit
 
Setup:
    pip install requests pyodbc
    Set the API settings and map_resort() field names in the "API SECTION" below.
"""
import json
import os
 
import pyodbc
import requests
 
# ---------------------------------------------------------------------------
# DATABASE (Group 3) - fill in the password, don't commit it to GitHub
# ---------------------------------------------------------------------------
CONN_STR = (
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=tcp:mist353f26-gorman-server.database.windows.net,1433;"
    "Database=mist353f26group3;"
    "Uid=jgorman04;"
    "Pwd=ADBjp2004;"
    "Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
)
 
# ---------------------------------------------------------------------------
# API SECTION - the only part that depends on which API you pick
# ---------------------------------------------------------------------------
API_KEY = "ivXR2YDLiN2UMFgqkSvq1sLxMgXI6J1xz8+fbxBGHR0DfF0yBuza9HDzCRR1JkjG"
BASE_URL = "https://YOUR_API_BASE_URL"
HEADERS = {"Authorization": f"Bearer {API_KEY}", "Accept": "application/json"}
RESORTS_PATH = "/resorts"   # endpoint that returns the list of resorts
PARAMS = {}                 # e.g. {"country": "US"} if the API supports filtering
 
SAVE_RAW_JSON = True        # keep a local copy so re-runs don't spend API calls
CACHE_FILE = "resorts.json"
 
 
def fetch_resorts():
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE) as f:
            return json.load(f)
 
    resp = requests.get(f"{BASE_URL}{RESORTS_PATH}", headers=HEADERS, params=PARAMS, timeout=30)
    resp.raise_for_status()
    data = resp.json()
 
    if SAVE_RAW_JSON:
        with open(CACHE_FILE, "w") as f:
            json.dump(data, f, indent=2)
    return data
 
 
def map_resort(r):
    """Translate one API record into our Resort columns.
    Change the keys inside r.get("...") to match the API's field names."""
    return {
        "name": (r.get("name") or "Unknown Resort")[:100],
        "city": (r.get("city") or None),
        "state": (r.get("state") or None),
        "country": (r.get("country") or None),
        "zip": (str(r.get("zip")) if r.get("zip") else None),
        "street": (r.get("address") or None),
        "vertical_drop": r.get("verticalDrop"),
        "trail_count": r.get("trails"),
        "skiable_acres": r.get("skiableAcres"),
        "lift_count": r.get("lifts"),
        "avg_snowfall": r.get("averageSnowfall"),
        "price": r.get("ticketPrice"),
        # runs per terrain type, e.g. {"Beginner": 12, "Intermediate": 20, "Advanced": 8}
        "runs_by_terrain": r.get("runsByTerrain") or {},
    }
# ---------------------------------------------------------------------------
 
 
def get_or_create_resort(cur, m):
    cur.execute(
        "SELECT ResortID FROM Resort WHERE ResortName = ? AND ISNULL(ResortState, '') = ISNULL(?, '')",
        m["name"], m["state"],
    )
    row = cur.fetchone()
    if row:
        return row[0], False
    cur.execute(
        "INSERT INTO Resort (ResortName, ResortCity, ResortState, ResortCountry, ResortZipCode, "
        "ResortStreetAddress, ResortVerticalDrop, ResortTrailCount, ResortSkiableAcres, "
        "ResortLiftCount, ResortAverageSnowFall, ResortPrice) "
        "OUTPUT INSERTED.ResortID VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        m["name"], m["city"], m["state"], m["country"], m["zip"], m["street"],
        m["vertical_drop"], m["trail_count"], m["skiable_acres"], m["lift_count"],
        m["avg_snowfall"], m["price"],
    )
    return cur.fetchone()[0], True
 
 
def upsert_run_profile(cur, resort_id, terrain_type, num_runs):
    cur.execute(
        "SELECT RunProfileID FROM RunProfile WHERE ResortID = ? AND TerrainType = ?",
        resort_id, terrain_type,
    )
    row = cur.fetchone()
    if row:
        cur.execute("UPDATE RunProfile SET NumOfRuns = ? WHERE RunProfileID = ?", num_runs, row[0])
    else:
        cur.execute(
            "INSERT INTO RunProfile (ResortID, TerrainType, NumOfRuns) VALUES (?, ?, ?)",
            resort_id, terrain_type, num_runs,
        )
 
 
def main():
    conn = pyodbc.connect(CONN_STR)
    cur = conn.cursor()
 
    resorts = fetch_resorts()
    print(f"{len(resorts)} resorts returned")
 
    for r in resorts:
        m = map_resort(r)
        resort_id, added = get_or_create_resort(cur, m)
 
        for terrain, count in m["runs_by_terrain"].items():
            upsert_run_profile(cur, resort_id, str(terrain)[:50], int(count or 0))
 
        print(f"   {'added' if added else 'skipped'}: {m['name']}")
 
    conn.commit()
    cur.close()
    conn.close()
    print("Done.")
 
 
if __name__ == "__main__":
    main()
 
