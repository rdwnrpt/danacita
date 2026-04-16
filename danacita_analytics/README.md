# danacita_analytics dbt project

This directory contains the dbt project for Danacita analytics.
It transforms source data from seeds into structured models for reporting and analysis.

## Workflow

1. Populate seed files by running the ingestion scripts from the repository root:
   ```bash
   python ingest/ingest_fx.py
   python ingest/ingest_loan_book.py
   ```
2. Change to the dbt project directory:
   ```bash
   cd danacita_analytics
   ```
3. Load seed data into your warehouse:
   ```bash
   dbt seed
   ```
4. Build the dbt models:
   ```bash
   dbt run
   ```
5. Run tests:
   ```bash
   dbt test
   ```

## Notes

- The dbt profile is configured as `danacita_analytics` in `dbt_project.yml`.
- Update your `~/.dbt/profiles.yml` to point to your Postgres or cloud warehouse.
- Seed data files are stored in `danacita_analytics/seeds/`.

## Useful commands

```bash
dbt clean
dbt docs generate
dbt docs serve
```