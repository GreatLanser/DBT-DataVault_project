{%- set yaml_metadata -%}

source_model: 'raw_seats'
derived_columns:
  RECORD_SOURCE: '!RAW_SEATS'
hashed_columns:
  AIRCRAFT_SEAT_PK:
    - 'AIRCRAFT_PK'
    - 'SEAT_NO'
  AIRCRAFT_SEATS_HASHDIFF:
    is_hashdiff: true
    columns:
    - 'AIRCRAFT_PK'
    - 'SEAT_NO'
    - 'FARE_CONDITIONS'
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
