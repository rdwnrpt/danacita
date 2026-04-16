with source as (
    select * from {{ source('raw', 'src_loanbook') }}
),

cleaned as (
    select
        snapshot_date::date as snapshot_date,
        loan_id,
        requested_principal::numeric as requested_principal,
        outstanding_balance::numeric as outstanding_balance,
        status,
        
        case 
            when outstanding_balance is null then 0
            else outstanding_balance
        end as outstanding_balance_clean,
        
        case 
            when status = 'Submission' then 1
            when status = 'Activated' then 2
            when status = 'Closed' then 3
        end as status_order,
        
        current_timestamp as dbt_loaded_at
        
    from source
)

select * from cleaned