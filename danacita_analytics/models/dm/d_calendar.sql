{{ config(
    materialized='table',
    indexes=[
      {'columns': ['date_key'], 'unique': True}
    ]
) }}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2019-01-01' as date)",
        end_date="cast('2026-12-31' as date)"
    ) }}
),

dates as (
    select
        date_day as date_actual,
        -- to_char(date_day, 'YYYYMMDD')::integer as date_key,
        date_day as date_key,
        extract(year from date_day)::integer as year,
        extract(quarter from date_day)::integer as quarter,
        extract(month from date_day)::integer as month,
        extract(day from date_day)::integer as day,
        extract(dow from date_day)::integer as day_of_week,
        extract(doy from date_day)::integer as day_of_year,
        to_char(date_day, 'Month') as month_name,
        to_char(date_day, 'Day') as day_name,
        to_char(date_day, 'YYYY-MM') as year_month,
        to_char(date_day, 'YYYY-Q') || 'Q' || extract(quarter from date_day)::text as year_quarter,
        case when extract(dow from date_day) in (0, 6) then true else false end as is_weekend,
        date_day = current_date as is_today,
        (date_trunc('month', date_day) + interval '1 month - 1 day')::date    as month_end_date,
        current_timestamp as dbt_loaded_at
    from date_spine
)

select * from dates