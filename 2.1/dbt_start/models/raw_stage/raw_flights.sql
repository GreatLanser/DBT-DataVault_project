SELECT f.flight_id
     , acd.aircraft_code
     , apd_arrival.airport_code AS arrival_airport_code
     , apd_departure.airport_code AS departure_airport_code
     , f.flight_no
     , f.scheduled_departure
     , f.scheduled_arrival
     , f.status
     , f.actual_departure
     , f.actual_arrival
  FROM {{ source('raw', 'flights')}}            AS f
  LEFT JOIN {{ source('raw', 'aircrafts_data') }}    AS acd
    ON f.aircraft_code = acd.aircraft_code
  LEFT JOIN {{ source('raw', 'airports_data') }}     AS apd_arrival
    ON f.arrival_airport = apd_arrival.airport_code
  LEFT JOIN {{ source('raw', 'airports_data') }}     AS apd_departure
    ON f.departure_airport = apd_departure.airport_code
 WHERE f.scheduled_departure BETWEEN TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY')
                         AND TO_DATE('{{ var('load_date') }}', 'DD.MM.YYYY') + INTERVAL '1 month 1 day'
    OR {{ var('full_load') }}