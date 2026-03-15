{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}
with flattened_outputs as (
select 
    t.hash_key,
    t.block_number,
    t.block_timestamp,
    t.is_coinbase,
    o.value:address::string as output_address,
    o.value:value::float as output_value
    from {{ref("stg_btc")}} t,
Lateral flatten(input => outputs) as o
WHERE o.value:address::string is not null
{% if is_incremental() %}
    and t.block_timestamp > (select max(block_timestamp) from {{ this }})
{% endif %}
)
select 
    hash_key,
    block_number,
    block_timestamp,
    is_coinbase,
    output_address,
    output_value  
 from flattened_outputs
