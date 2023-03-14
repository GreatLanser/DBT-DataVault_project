{%- set source_model = "stg_seats" -%}
{%- set src_pk = "AIRCRAFT_SEAT_PK" -%}
{%- set src_hashdiff = "AIRCRAFT_SEATS_HASHDIFF" -%}
{%- set src_payload = ["AIRCRAFT_PK", "SEAT_NO", "FARE_CONDITIONS"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}


{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}
