# 🚀 Workflow Guide: Running Taxi Pipeline in `/tmp` and Syncing Back to GitHub

## Why This Matters
- `/workspaces` is capped at 32 GB and often fills up (96–100% usage).
- `/tmp` has ~37 GB free, perfect for heavy virtual environments and DuckDB files.
- To avoid space alerts, we **develop in `/tmp`** and **sync back to `/workspaces`** before committing.

---

## Step 1: Move Pipeline to `/tmp`
```bash
mv /workspaces/Data-Engineering-ZoomCamp/workshop/dlt/taxi_pipeline /tmp/
cd /tmp/taxi_pipeline

Step 2: Recreate Environment
```bash
rm -rf .venv
uv init --python 3.11 --directory .
uv add "dlt[workspace]" "dlt[duckdb]" "dlt-mcp[search]"
```
Step 3: Run MCP Server
```bash
uv run python -m dlt_mcp
```
Step 4: Sync Changes Back to Repo
Before committing, copy files from /tmp into your repo workspace:
```bash
rsync -av --exclude '.venv' /tmp/taxi_pipeline/ /workspaces/Data-Engineering-ZoomCamp/workshop/dlt/taxi_pipeline/
```
Step 5: Commit and Push
```bash
cd /workspaces/Data-Engineering-ZoomCamp
git add workshop/dlt/taxi_pipeline
git commit -m "Sync taxi_pipeline changes from /tmp"
git push origin main
```
⚠️ Important Notes
Never commit symlinks (ln -s) — Git will replace files with a pointer.

Always use rsync to copy real files back before committing.

Keep heavy work in /tmp, but ensure GitHub has the actual files.

Optional: Sync Script
Create sync_pipeline.sh in your repo:
```bash
#!/bin/bash
rsync -av --exclude '.venv' /tmp/taxi_pipeline/ /workspaces/Data-Engineering-ZoomCamp/workshop/dlt/taxi_pipeline/
cd /workspaces/Data-Engineering-ZoomCamp
git add workshop/dlt/taxi_pipeline
git commit -m "Sync taxi_pipeline changes from /tmp"
git push origin main
```
Make it executable:
```bashchmod +x sync_pipeline.sh
```
Run it whenever you need to sync:
```bash./sync_pipeline.sh
```
This workflow keeps your development smooth while managing space effectively!
