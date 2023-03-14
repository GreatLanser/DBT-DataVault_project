{%- set yaml_metadata -%}

source_model: 'raw_tickets'
derived_columns:
  RECORD_SOURCE: '!RAW_TICKETS'
hashed_columns:
  TICKET_PK: 'TICKET_NO'
  FLIGHT_PK: 'FLIGHT_ID'
  FLIGHT_TICKET_PK:
    - 'FLIGHT_ID'
    - 'TICKET_NO'
  TICKET_MAIN_HASHDIFF:
    is_hashdiff: true
    columns:
    - 'PASSENGER_ID'
    - 'PASSENGER_NAME'
    - 'CONTACT_DATA'
  TICKET_BOOKING_HASHDIFF:
    is_hashdiff: true
    columns:
    - 'BOOK_REF'
    - 'BOOK_DATE'
    - 'TOTAL_AMOUNT'
  TICKET_BOARDING_PASS_HASHDIFF:
    is_hashdiff: true
    columns:
    - 'BOARDING_NO'
    - 'SEAT_NO'
    - 'FARE_CONDITIONS'
    - 'AMOUNT'
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

SELECT *
     , TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY') AS LOAD_DATE
     , TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY') - INTERVAL '1 day' AS EFFECTIVE_FROM
FROM staging
