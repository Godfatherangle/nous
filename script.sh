#!/bin/bash
# Atropos Setup Script for Mac/Linux
# Fully automated setup + tests + sync with main branch

set -e  # Exit on error

echo "========================================"
echo "Atropos Contribution Setup Script"
echo "========================================"
echo ""

# Check if GitHub username is provided
if [ -z "$1" ]; then
    echo "ERROR: Please provide your GitHub username"
    echo "Usage: ./setup-atropos.sh YOUR-GITHUB-USERNAME"
    exit 1
fi

GITHUB_USER="$1"
REPO_URL="https://github.com/$GITHUB_USER/Atropos.git"

# Detect Python command
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "ERROR: Python is not installed."
    exit 1
fi

echo "[1/8] Checking Git..."
command -v git >/dev/null || { echo "Git not installed"; exit 1; }

echo "[2/8] Checking Python..."
$PYTHON_CMD --version

echo "[3/8] Cloning repository..."
if [ -d "Atropos" ]; then
    cd Atropos
else
    git clone "$REPO_URL"
    cd Atropos
fi

echo "[4/8] Creating virtual environment..."
[ -d ".venv" ] || $PYTHON_CMD -m venv .venv

echo "[5/8] Activating virtual environment..."
source .venv/bin/activate

echo "[6/8] Installing dependencies..."
pip install -e ".[dev]"

echo "[7/8] Installing pre-commit hooks..."
pre-commit install || echo "pre-commit install skipped"

echo "[8/8] Running tests..."
pytest

echo "Syncing with main branch..."
git checkout main
git pull origin main

echo "========================================"
echo "Automation Complete ✅"
echo "========================================"
