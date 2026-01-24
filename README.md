# Data-Engineering-ZoomCamp
Docker-Workshop-Codespaces
# HOMEWORK

QUESTION 3
For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile? -
# Answer - 8007
# SQL 
SELECT COUNT(*) AS short_trips
FROM green_tripdata_2025_11
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;

# QUESTION 4
Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).
Use the pick up time for your calculations.
# Answer - 2025-11-14
# SQL
SELECT DATE(lpep_pickup_datetime) AS pickup_day,
       MAX(trip_distance) AS longest_trip
FROM green_tripdata_2025_11
WHERE trip_distance < 100
GROUP BY pickup_day
ORDER BY longest_trip DESC
LIMIT 1;

# QUESTION 5
Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?
# Answer - East Harlem North
# SQL 
SELECT z.zone AS pickup_zone,
       SUM(t.total_amount) AS total_sum
FROM green_tripdata_2025_11 t
JOIN taxi_zone_lookup z
  ON t.PULocationID = z.locationid
WHERE DATE(t.lpep_pickup_datetime) = '2025-11-18'
GROUP BY z.zone
ORDER BY total_sum DESC
LIMIT 1;

# QUESTION 6
For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?
Note: it's tip , not trip. We need the name of the zone, not the ID.
# Answer - Yorkville West
# SQL
SELECT dz.zone AS dropoff_zone,
       MAX(t.tip_amount) AS largest_tip
FROM green_tripdata_2025_11 t
JOIN taxi_zone_lookup pz
  ON t.PULocationID = pz.locationid
JOIN taxi_zone_lookup dz
  ON t.DOLocationID = dz.locationid
WHERE pz.zone = 'East Harlem North'
  AND t.lpep_pickup_datetime >= '2025-11-01'
  AND t.lpep_pickup_datetime < '2025-12-01'
GROUP BY dz.zone
ORDER BY largest_tip DESC
LIMIT 1;

