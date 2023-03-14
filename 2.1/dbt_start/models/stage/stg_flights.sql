{%- set yaml_metadata -%}

source_model: 'raw_flights'
derived_columns:
  RECORD_SOURCE: '!RAW_FLIGHTS'
hashed_columns:
  ARRIVAL_AIRPORT_PK: 'ARRIVAL_AIRPORT_CODE'
  DEPARTURE_AIRPORT_PK: 'DEPARTURE_AIRPORT_CODE'
  AIRCRAFT_PK: 'AIRCRAFT_CODE'
  FLIGHT_PK: 'FLIGHT_ID'
  FLIGHT_AIRCRAFT_PK:
    - 'AIRCRAFT_CODE'
    - 'FLIGHT_ID'
  FLIGHT_AIRPORT_PK:
    - 'FLIGHT_ID'
    - 'DEPARTURE_AIRPORT_CODE'
    - 'ARRIVAL_AIRPORT_CODE'
  FLIGHT_MAIN_HASHDIFF:
    is_hashdiff: true
    columns:
    - 'FLIGHT_NO'
    - 'SCHEDULED_DEPARTURE'
    - 'SCHEDULED_ARRIVAL'
    - 'STATUS'
    - 'ACTUAL_DEPARTURE'
    - 'ACTUAL_ARRIVAL'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

WITH staging AS (
{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
)

SELECT *,
       TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY') AS LOAD_DATE
     , TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY') - INTERVAL '1 day' AS EFFECTIVE_FROM
FROM staging
