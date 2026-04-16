with source as (
    select * from {{ source('raw', 'src_fx_rate_cleaned') }}
),

cleaned as (
    select
        rate_type,
        currency currency_code,
        date::date as rate_date,
        value::numeric as exchange_rate,
        current_timestamp as dbt_loaded_at
        
    from source
    where value is not null
)

select * from cleaned