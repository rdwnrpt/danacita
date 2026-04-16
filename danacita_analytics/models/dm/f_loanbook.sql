{{ config(materialized='table') }}

with loanbook as (
    select * from {{ ref('stg_loanbook') }}
),

d_calendar as (
    select date_key, month_end_date
    from {{ ref('d_calendar') }}
),

d_currency as (
    select currency_key, currency_code
    from {{ ref('d_currency') }}
),

fx as (
    select
        currency_code,
        rate_date,
        exchange_rate as fx_rate_to_usd
    from {{ ref('stg_fx_rates') }}
    where rate_type = 'Closing rate' and currency_code = 'IDR'
),

final as (
    select
        -- keys
        d.date_key        as snapshot_date_key,
        dc.currency_key,

        -- loan attributes
        l.loan_id,
        l.status,

        -- amounts in local currency (IDR)
        l.requested_principal,
        l.outstanding_balance,

        -- fx context
        fx.fx_rate_to_usd,

        case
            when l.outstanding_balance is not null
             and fx.fx_rate_to_usd     is not null
             and fx.fx_rate_to_usd     != 0
            then round(l.outstanding_balance / fx.fx_rate_to_usd, 2)
            else null
        end    as outstanding_usd

    from loanbook l

    left join d_calendar d
        on d.date_key = l.snapshot_date

    left join d_currency dc
        on dc.currency_code = 'IDR'

    -- fx rate: match on currency + month-end of snapshot
    left join fx
        on fx.currency_code = 'IDR'
        and fx.rate_date    = d.month_end_date
)

select * from final