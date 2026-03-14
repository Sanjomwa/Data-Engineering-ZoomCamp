#!/usr/bin/env bash
set -e

# Ensure uv is installed globally
if ! command -v uv &> /dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  source ~/.bashrc
fi

# Clear and recreate venv in /tmp
echo "[INFO] Creating fresh venv in /tmp/.venv..."
uv venv /tmp/.venv --clear

# Sync dependencies into /tmp/.venv
echo "[INFO] Syncing dependencies..."
uv sync --python /tmp/.venv/bin/python

# Activate venv for this session
source /tmp/.venv/bin/activate

# Verification messages
echo "[VERIFY] Active Python interpreter: $(which python)"
echo "[VERIFY] Python version: $(python --version)"
echo "[VERIFY] uv cache directory: $(ls /tmp/uv-cache || echo 'No uv cache yet')"
echo "[VERIFY] pip cache directory: $(ls /tmp/pip-cache || echo 'No pip cache yet')"

# Optional cleanup if /vscode gets tight
echo "[CLEANUP] Clearing old VS Code logs..."
rm -rf ~/.vscode-remote/data/logs/* || true
