SELECT PULocationID, num_trips
FROM pickup_aggregated
ORDER BY num_trips DESC
LIMIT 3;