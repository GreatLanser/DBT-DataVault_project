{%- set source_model = "stg_aircrafts" -%}
{%- set src_pk = "AIRCRAFT_PK" -%}
{%- set src_hashdiff = "AIRCRAFT_MAIN_HASHDIFF" -%}
{%- set src_payload = ["MODEL", "RANGE"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}


{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}
