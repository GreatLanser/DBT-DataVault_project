{%- set source_model = ["stg_flights"] -%}
{%- set src_pk = "FLIGHT_AIRCRAFT_PK" -%}
{%- set src_fk = ["AIRCRAFT_PK", "FLIGHT_PK"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}
