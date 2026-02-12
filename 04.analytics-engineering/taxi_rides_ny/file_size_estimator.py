import requests, sys
BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"
total = 0
missing = []
for taxi in ("yellow","green"):
    for year in (2019,2020):
        for month in range(1,13):
            fname = f"{taxi}_tripdata_{year}-{month:02d}.csv.gz"
            url = f"{BASE_URL}/{taxi}/{fname}"
            try:
                r = requests.head(url, allow_redirects=True, timeout=10)
                size = r.headers.get("Content-Length")
                if size:
                    total += int(size)
                else:
                    missing.append(fname)
            except Exception as e:
                missing.append(fname)
print("Estimated bytes:", total)
print("Estimated GB: {:.2f}".format(total/1024**3))
print("Missing Content-Length for files:", missing)
# show available space
import shutil
total_b, used_b, free_b = shutil.disk_usage("/workspaces")
print("Available bytes on /workspaces:", free_b)
print("Available GB:", free_b/1024**3)
