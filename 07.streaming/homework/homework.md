# Module 7: Streaming – Homework

## Approach
- **Redpanda** → Kafka-compatible broker for producing/consuming taxi trip events
- **PyFlink** → streaming jobs with tumbling and session windows
- **Postgres** → sink for aggregated results
- Workflow: producer sends parquet data → Flink jobs aggregate → results queried in Postgres

# Module 7: Streaming – Homework

This document contains the solved homework for Module 7 using Green Taxi data from October 2025.

## Homework Summary – Answers

| Question | Answer |
|----------|--------|
| Q1. Redpanda version | `v25.3.9` |
| Q2. Time to send full dataset | **10 seconds** (closest option) |
| Q3. Trips with `trip_distance > 5` | **8,506** |
| Q4. Top `PULocationID` in 5‑min window | **74** |
| Q5. Longest session window trip count | **81** |
| Q6. Hour with largest total tip | **2025‑10‑16 18:00:00** |

---

## Prerequisites
- Docker and Docker Compose
- Python virtual environment at repo root (`.venv`)
- Python packages: `pandas`, `pyarrow`, `kafka-python`
- Workshop stack available in `07-streaming/class_materials/workshop/`

---

## Setup

From `07-streaming/class_materials/workshop/`:

`bash
docker compose build
docker compose up -d
`
For stale containers/volumes:
`bash
docker compose down -v
docker compose build
docker compose up -d
`
## Answers

**1. Redpanda version**  
Run inside container:  
`docker exec -it pyflink-pipeline-redpanda-1 rpk version`  
**rpk version: v25.3.9
Redpanda Cluster ... v25.3.9
**


**2. Producer runtime**  
Producer sending parquet data to `green-trips` topic took ~3.47 seconds.  
Closest option: **10 seconds**

**3. Trips with distance > 5 km**  
`count = 0
for message in consumer:
    trip = message.value
    if float(trip.get("trip_distance", 0) or 0) > 5.0:
        count += 1
`
Consumer counted:  
**8,506 trips**

**4. Tumbling window – busiest pickup location**  
Query on `pickup_aggregated`:  
`CREATE TABLE events (
  lpep_pickup_datetime VARCHAR,
  PULocationID INT,
  event_timestamp AS TO_TIMESTAMP(lpep_pickup_datetime, 'yyyy-MM-dd HH:mm:ss'),
  WATERMARK FOR event_timestamp AS event_timestamp - INTERVAL '5' SECOND
) WITH (...);
`
Aggregation query:
`SELECT
  window_start,
  PULocationID,
  COUNT(*) AS num_trips
FROM TABLE(
  TUMBLE(TABLE events, DESCRIPTOR(event_timestamp), INTERVAL '5' MINUTES)
)
GROUP BY window_start, PULocationID;
`
**PULocationID 74** had the most trips in a single 5‑minute window

**5. Session window – longest streak**  
Query on `longest_streak_aggregated`:  
Longest session contained **81 trips** (PULocationID 74)

**6. Tumbling window – largest tip amount**  
Query on `aggregated_tips_per_hour`: 
`SELECT
  window_start,
  window_end,
  PULocationID,
  COUNT(*) AS num_trips
FROM TABLE(
  SESSION(TABLE events PARTITION BY PULocationID,
          DESCRIPTOR(event_timestamp),
          INTERVAL '5' MINUTES)
)
GROUP BY window_start, window_end, PULocationID;
`
Highest total tips: **2025‑10‑16 18:00:00** with ~**524.96**

Finished Module 7 – streaming pipelines running end‑to‑end!
