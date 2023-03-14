SELECT CAST(UPPER(MD5(NULLIF(UPPER(TRIM(CAST(acd.aircraft_code AS VARCHAR))), ''))) AS BYTEA) AS AIRCRAFT_PK
     , s.fare_conditions
     , s.seat_no
  FROM {{ source('raw', 'aircrafts_data') }}    AS acd
  LEFT JOIN {{ source('raw', 'seats') }}        AS s
    ON s.aircraft_code = acd.aircraft_code