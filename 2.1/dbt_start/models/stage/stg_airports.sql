{%- set yaml_metadata -%}

source_model: 'raw_airports'
derived_columns:
  RECORD_SOURCE: '!RAW_AIRPORTS'
hashed_columns:
  AIRPORT_PK: 'AIRPORT_CODE'
  AIRPORT_MAIN_HASHDIFF:
    is_hashdiff: TRUE
    columns:
    - 'AIRPORT_NAME'
    - 'CITY'
    - 'LONGITUDE'
    - 'LATITUDE'
    - 'TIMEZONE'
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
