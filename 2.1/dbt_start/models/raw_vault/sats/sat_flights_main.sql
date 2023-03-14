{%- set source_model = "stg_flights" -%}
{%- set src_pk = "FLIGHT_PK" -%}
{%- set src_hashdiff = "FLIGHT_MAIN_HASHDIFF" -%}
{%- set src_payload = [
      "FLIGHT_NO"
    , "SCHEDULED_DEPARTURE"
    , "SCHEDULED_ARRIVAL"
    , "STATUS"
    , "ACTUAL_DEPARTURE"
    , "ACTUAL_ARRIVAL"
] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}


{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}