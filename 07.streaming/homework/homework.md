# Module 7: Streaming – Homework

## Approach
- **Redpanda** → Kafka-compatible broker for producing/consuming taxi trip events
- **PyFlink** → streaming jobs with tumbling and session windows
- **Postgres** → sink for aggregated results
- Workflow: producer sends parquet data → Flink jobs aggregate → results queried in Postgres

## Answers

**1. Redpanda version**  
Run inside container:  
`docker exec -it pyflink-pipeline-redpanda-1 rpk version`  
**v25.3.9**

**2. Producer runtime**  
Producer sending parquet data to `green-trips` topic took ~3.47 seconds.  
Closest option: **10 seconds**

**3. Trips with distance > 5 km**  
Consumer counted:  
**8,506 trips**

**4. Tumbling window – busiest pickup location**  
Query on `pickup_aggregated`:  
**PULocationID 74** had the most trips in a single 5‑minute window

**5. Session window – longest streak**  
Query on `longest_streak_aggregated`:  
Longest session contained **81 trips** (PULocationID 74)

**6. Tumbling window – largest tip amount**  
Query on `aggregated_tips_per_hour`:  
Highest total tips: **2025‑10‑16 18:00:00** with ~**524.96**

Finished Module 7 – streaming pipelines running end‑to‑end!
