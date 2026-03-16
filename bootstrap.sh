#!/usr/bin/env bash
set -e

# Wait for Docker daemon to be ready (critical for docker compose later)
echo "Waiting for Docker daemon to be ready..."
for i in {1..60}; do
  if docker version >/dev/null 2>&1; then
    echo "Docker is ready!"
    break
  fi
  echo "Docker not ready yet... retrying in 2s ($i/60)"
  sleep 2
done

if ! docker version >/dev/null 2>&1; then
  echo "ERROR: Docker daemon did not start after 120 seconds. Cannot continue."
  echo "Check creation logs for docker-in-docker feature errors."
  exit 1
fi

# Ensure uv is installed globally
if ! command -v uv &> /dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # Source the updated profile (uv adds to ~/.bashrc or similar)
  source ~/.bashrc || true
fi

# Clear and recreate venv in repo root
echo "[INFO] Creating fresh venv in .venv..."
uv venv /workspaces/Data-Engineering-ZoomCamp/.venv --clear

# Sync dependencies into the venv
echo "[INFO] Syncing dependencies..."
uv sync --python /workspaces/Data-Engineering-ZoomCamp/.venv/bin/python

# Activate venv for the rest of the session (and future terminals via .bashrc if needed)
source /workspaces/Data-Engineering-ZoomCamp/.venv/bin/activate

# Verification
echo "[VERIFY] Active Python: $(which python)"
python --version
echo "[VERIFY] Docker version:"
docker --version
docker compose version