{{ config(materialized='table') }}
 
with source as (
    select distinct currency_code
    from {{ ref('stg_fx_rates') }}
),
 
final as (
    select
        {{ dbt_utils.generate_surrogate_key(['currency_code']) }}   as currency_key,
        currency_code,
        case currency_code
            when 'IDR' then 'Indonesian Rupiah'
            when 'PHP' then 'Philippine Peso'
            when 'SGD' then 'Singapore Dollar'
            when 'EUR' then 'Euro'
            when 'HKD' then 'Hong Kong Dollar'
            else currency_code
        end                                                         as currency_name,
        'USD'                                                       as base_currency
    from source
)
 
select * from final
 