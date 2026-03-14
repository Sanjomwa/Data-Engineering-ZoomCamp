#!/usr/bin/env bash
set -e

# Ensure uv is installed globally
if ! command -v uv &> /dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  source ~/.bashrc
fi

# Clear and recreate venv in repo
echo "[INFO] Creating fresh venv in .venv..."
uv venv /workspaces/Data-Engineering-ZoomCamp/.venv --clear

# Sync dependencies into .venv
echo "[INFO] Syncing dependencies..."
uv sync --python /workspaces/Data-Engineering-ZoomCamp/.venv/bin/python

# Activate venv
source /workspaces/Data-Engineering-ZoomCamp/.venv/bin/activate

# Verification
echo "[VERIFY] Active Python: $(which python)"
python --version
