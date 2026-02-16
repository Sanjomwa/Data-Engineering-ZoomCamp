```markdown
# Module 4: Analytics Engineering – Homework

## Approach
- **Local DuckDB** (dev target) → fast development, testing, debugging, lineage checks
- **BigQuery** (prod target) → final production build and verified answers
- Hybrid workflow: dev for speed, prod for correctness

## Answers

**1. dbt Lineage and Execution**  
`dbt run --select int_trips_unioned` builds:  
**int_trips_unioned only**  
(Upstream models not rebuilt unless `+` is used)

**2. dbt Tests**  
When new value appears outside `accepted_values` list:  
**dbt will fail the test, returning a non-zero exit code**

**3. Count of records in fct_monthly_zone_revenue**  
**12,998**

**4. Best performing zone for Green taxis in 2020**  
**East Harlem North**

**5. Total trips for Green taxis in October 2019**  
**384,624**

**6. Count of records in stg_fhv_tripdata**  
**43,244,693**  
(Model filters dispatching_base_num IS NOT NULL and renames PU/DOlocationID)

## Learning in Public
X thread:  
https://x.com/sam_njogu9/status/... (link to first post of the thread after you publish)

## Repo
https://github.com/sam-njogu/Data-Engineering-Zoomcamp/tree/main/04-analytics-engineering

---
Finished Module 4 – excited for the next one!
