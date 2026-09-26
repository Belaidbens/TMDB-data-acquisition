#!/usr/bin/env bash
set -e

VENV_DIR=".venv"

echo "==> Checking Python 3.13..."
if ! command -v python3.13 >/dev/null 2>&1; then
    echo "ERROR: python3.13 was not found."
    echo "Install Python 3.13, then run this script again."
    exit 1
fi

echo "==> Creating virtual environment in ${VENV_DIR}..."
python3.13 -m venv "$VENV_DIR"

echo "==> Activating virtual environment..."
source "$VENV_DIR/bin/activate"

echo "==> Upgrading pip..."
python -m pip install --upgrade pip

echo "==> Installing project dependencies..."
python -m pip install -r requirements.txt

echo
echo "==> Environment ready."
echo "Activate it later with:"
echo "    source ${VENV_DIR}/bin/activate"
echo
echo "Python version:"
python --version

echo
echo "Key package versions:"
python - <<'PY'
import pandas
import numpy
import duckdb
import requests
import bs4
import matplotlib
import seaborn
import sklearn
import mlxtend

print("pandas:", pandas.__version__)
print("numpy:", numpy.__version__)
print("duckdb:", duckdb.__version__)
print("requests:", requests.__version__)
print("beautifulsoup4:", bs4.__version__)
print("matplotlib:", matplotlib.__version__)
print("seaborn:", seaborn.__version__)
print("scikit-learn:", sklearn.__version__)
print("mlxtend:", mlxtend.__version__)
PY
