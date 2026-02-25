# 🚀 Data Engineering Zoomcamp 2026

Welcome to my **Data Engineering Zoomcamp** repository!  
This repo documents my progress through the Zoomcamp curriculum, with hands-on implementations, experiments, and examiner-friendly notes.  

---

## 📂 Repository Structure

- **01.docker-terraform/**  
  - Docker basics, Codespaces setup, `.gitignore` hygiene  
  - Terraform fundamentals for infrastructure provisioning  
  - Resources:  
    - [Docker for Data Engineering (Alexey Grigorev)](https://www.youtube.com/watch?v=lP8xXebHmuE)  
    - [Terraform Basics](https://www.youtube.com/watch?v=Y2ux7gq3Z0o)

- **02.workflow-orchestration/**  
  - Orchestration with Kestra: scheduling, backfills, reproducible pipelines  
  - Local executions verified via [Kestra UI](http://127.0.0.1/ui/main/executions/zoomcamp)  
  - Resources:  
    - [Scheduling & Backfills](https://www.youtube.com/watch?v=1pu_C_oOAMA)

- **03.data-warehouse/**  
  - BigQuery setup with NYC Taxi datasets  
  - Partitioned tables for cost control  
  - Resources:  
    - [Data Warehouse & BigQuery](https://www.youtube.com/watch?v=jrHljAoD6nM)  
    - [Google Cloud Console – nytaxi dataset](https://console.cloud.google.com/bigquery?project=analytical-engineering-04&ws=!1m4!1m3!3m2!1sanalytical-engineering-04!2snytaxi)

- **04.analytics-engineering/**  
  - dbt models: staging, intermediate, marts  
  - Cloud + local workflows  
  - Resources:  
    - [dbt Cloud](https://auth.cloud.getdbt.com/u/login)

- **05.data-platform/**  
  - End-to-end integration of ingestion, orchestration, warehouse, and analytics with **Bruin**
  - Data platform orchestration and monitoring implemented with **Bruin**  
  - Resources:  
    - [Data Ingestion from APIs (Adrian Brudaru’s workshop)](https://www.youtube.com/watch?v=oLXhBM7nf2Q)

- **workshop/**  
  - API ingestion pipelines using **dlt**  
  - Homework completed with **DuckDB** (`taxi_data_20260223045641.rides`)   
  - Resources:  
    - [dlt Workshop Homework Submission](https://github.com/Sanjomwa/Data-Engineering-ZoomCamp/blob/main/workshop/homework.md)

---

## 🛠️ Tech Stack

| Tool/Framework | Purpose |
|----------------|---------|
| **Docker & Docker Compose** | Containerized workflows, Postgres + pgAdmin setup |
| **Terraform** | Infrastructure as code |
| **Kestra** | Workflow orchestration, scheduling, backfills |
| **BigQuery** | Cloud data warehouse |
| **dbt** | Analytics engineering, transformations |
| **Postgres** | Relational database for ingestion & staging |
| **Bruin** | Data platform orchestration and monitoring |
| **dlt** | API ingestion pipelines (workshop) |
| **DuckDB** | Local analytical database for workshop homework |

---

## ✅ Progress Highlights

- Built reproducible Dockerized environments for Postgres + pgAdmin  
- Provisioned cloud resources with Terraform  
- Scheduled pipelines and verified executions locally with Kestra  
- Ingested NYC Taxi datasets into BigQuery with partitioning for cost efficiency  
- Designed dbt models for staging and analytics layers  
- Completed dlt workshop homework with DuckDB (`taxi_data_20260223045641.rides`)  
- Integrated Bruin for orchestration and monitoring of ingestion pipelines  

---

## 📌 Next Steps

- Expand dbt models with advanced transformations  
- Optimize ingestion workflows for scalability  
- Build dashboards for examiner-ready reporting  
- Document licensing, attribution, and provenance for enrichment datasets  

---

## 📖 References

- [Docker Workshop Codespaces Repo](https://github.com/Sanjomwa/Data-Engineering-ZoomCamp)  
- [DataTalksClub Zoomcamp YouTube Series](https://www.youtube.com/playlist?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)  
- [Google Cloud BigQuery Console](https://console.cloud.google.com/bigquery?project=analytical-engineering-04)  
- [dlt Workshop Homework Submission](https://github.com/Sanjomwa/Data-Engineering-ZoomCamp/blob/main/workshop/homework.md)  

---

### ✨ Author
**Samwel Njogu** Focused on reproducible, examiner-friendly data engineering workflows with ethical framing and cost control.
