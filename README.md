# Danacita

A data ingestion and analytics repository for Danacita.

## Overview

- `ingest/`: Python scripts and notebooks for loading raw source files.
- `danacita_analytics/`: dbt project for transforming source data and building analytics models.
- `data/`: raw input files used by ingestion scripts.
- `logs/`: runtime logs and build outputs.

## Requirements

- Python 3.11 or newer
- dbt 1.x with `dbt-core` and `dbt-postgres`
- `pandas`, `openpyxl`
- A configured Postgres target and a dbt profile named `danacita_analytics`

## Setup

1. Create and activate a virtual environment:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```
2. Install project dependencies from `pyproject.toml`:
   ```bash
   python -m pip install --upgrade pip
   python -m pip install .
   ```
3. Configure your dbt profile at `~/.dbt/profiles.yml` for the `danacita_analytics` profile.

## Data ingestion

The repository includes two ingestion scripts:

- `python ingest/ingest_fx.py`
  - Reads `data/fx rate data (updated every EOM).xlsx`
  - Cleans, reshapes, and writes `danacita_analytics/seeds/src_fx_rate_cleaned.csv`
- `python ingest/ingest_loan_book.py`
  - Reads `data/loanbook_onlyforreference.xlsx`
  - Writes `danacita_analytics/seeds/src_loanbook.csv`

> If the raw source files move, update the `FILE_PATH` constants in the scripts.

## dbt analytics project

From the `danacita_analytics/` directory, run:

```bash
cd danacita_analytics
dbt seed
dbt run
dbt test
```

For documentation generation and inspection:

```bash
cd danacita_analytics
dbt docs generate
dbt docs serve
```

## Notebooks

- `ingest/loanbook.ipynb`
- `ingest/inget.ipynb`

Use these notebooks for exploratory analysis and development.

## Repository structure

- `ingest/` - ingestion scripts and notebooks
- `data/` - raw Excel source files
- `danacita_analytics/` - dbt project
- `logs/` - logs and generated output files

## Next steps

- Add a `profiles.yml` example or template
- Extend dbt models and tests
- Add a dedicated `docs/` site if needed
