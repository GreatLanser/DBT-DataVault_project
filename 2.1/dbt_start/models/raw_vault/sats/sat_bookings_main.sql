{%- set source_model = "stg_tickets" -%}
{%- set src_pk = "TICKET_PK" -%}
{%- set src_hashdiff = "TICKET_BOOKING_HASHDIFF" -%}
{%- set src_payload = ["BOOK_REF", "BOOK_DATE", "TOTAL_AMOUNT"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}


{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}
