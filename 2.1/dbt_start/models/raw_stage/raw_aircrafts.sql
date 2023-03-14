SELECT acd.aircraft_code
     , acd.model
     , acd.range
  FROM {{ source('raw', 'aircrafts_data') }}    AS acd