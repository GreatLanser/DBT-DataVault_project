CREATE SCHEMA IF NOT EXISTS bookings_vault;

CREATE VIEW bookings_vault.aircraft
AS 
SELECT ha.aircraft_code
     , sam.model ->> bookings.lang() AS model
     , sam."range"
  FROM bookings_raw_vault.hub_aircrafts ha
  JOIN bookings_raw_vault.sat_aircrafts_main sam
    ON sam.aircraft_pk = ha.aircraft_pk
 ORDER BY sam."range" DESC;
 

CREATE VIEW bookings_vault.airport
AS
SELECT ha.airport_code
     , sam.airport_name ->> bookings.lang() AS airport_name
     , sam.city ->> bookings.lang() AS city
     , point(sam.latitude, sam.longitude) AS coordinates
     , sam.timezone
  FROM bookings_raw_vault.hub_airports ha 
  JOIN bookings_raw_vault.sat_airports_main sam
    ON sam.airport_pk  = ha.airport_pk;


CREATE OR REPLACE VIEW bookings_vault.flights_v
AS 
SELECT hf.flight_id
     , sfm.flight_no
     , sfm.scheduled_departure
     , timezone(departure_sam.timezone, sfm.scheduled_departure) AS scheduled_departure_local
     , sfm.scheduled_arrival
     , timezone(arrival_sam.timezone, sfm.scheduled_arrival) AS scheduled_arrival_local
     , sfm.scheduled_arrival - sfm.scheduled_departure AS scheduled_duration
     , departure_ha.airport_code AS departure_airport
     , departure_sam.airport_name AS departure_airport_name
     , departure_sam.city AS departure_city
     , arrival_ha.airport_code AS arrival_airport
     , arrival_sam.airport_name AS arrival_airport_name
     , arrival_sam.city AS arrival_city
     , sfm.status
     , ha2.aircraft_code
     , sfm.actual_departure
     , timezone(departure_sam.timezone, sfm.actual_departure) AS actual_departure_local
     , sfm.actual_arrival
     , timezone(arrival_sam.timezone, sfm.actual_arrival) AS actual_arrival_local
     , sfm.actual_arrival - sfm.actual_departure AS actual_duration
   FROM bookings_raw_vault.hub_flights hf
   JOIN bookings_raw_vault.sat_flights_main sfm
     ON hf.flight_pk = sfm.flight_pk
   JOIN bookings_raw_vault.link_flights_airports lfa
     ON lfa.flight_pk = hf.flight_pk
   JOIN bookings_raw_vault.hub_airports arrival_ha
     ON arrival_ha.airport_pk = lfa.arrival_airport_pk
   JOIN bookings_raw_vault.sat_airports_main arrival_sam
     ON arrival_sam.airport_pk = arrival_ha.airport_pk
   JOIN bookings_raw_vault.hub_airports departure_ha
     ON departure_ha.airport_pk = lfa.departure_airport_pk
   JOIN bookings_raw_vault.sat_airports_main departure_sam
     ON departure_sam.airport_pk = departure_ha.airport_pk
   JOIN bookings_raw_vault.link_flights_aircrafts lfa2
     ON lfa2.flight_pk = hf.flight_pk
   JOIN bookings_raw_vault.hub_aircrafts ha2
     ON ha2.aircraft_pk = lfa2.aircraft_pk;



CREATE OR REPLACE VIEW bookings_vault.routes
AS
WITH f3 AS (
    SELECT f2.flight_no
         , f2.departure_airport
         , f2.arrival_airport
         , f2.aircraft_code
         , f2.duration
         , array_agg(f2.days_of_week) AS days_of_week
      FROM (
        SELECT f1.flight_no
             , f1.departure_airport
             , f1.arrival_airport
             , f1.aircraft_code
             , f1.duration
             , f1.days_of_week
          FROM (
              SELECT sfm.flight_no
                   , departure_ha.airport_code departure_airport
                   , arrival_ha.airport_code arrival_airport
                   , ha.aircraft_code
                   , sfm.scheduled_arrival - sfm.scheduled_departure AS duration
                   , to_char(sfm.scheduled_departure, 'ID'::text)::integer AS days_of_week
                FROM bookings_raw_vault.hub_flights hf
                JOIN bookings_raw_vault.sat_flights_main sfm
                  ON sfm.flight_pk = hf.flight_pk
                JOIN bookings_raw_vault.link_flights_aircrafts lfa
                  ON lfa.flight_pk = hf.flight_pk
                JOIN bookings_raw_vault.hub_aircrafts ha 
                  ON ha.aircraft_pk = lfa.aircraft_pk
                JOIN bookings_raw_vault.link_flights_airports lfa2
                  ON lfa2.flight_pk = hf.flight_pk
                JOIN bookings_raw_vault.hub_airports arrival_ha
                  ON lfa2.arrival_airport_pk = arrival_ha.airport_pk
                JOIN bookings_raw_vault.sat_airports_main arrival_sam
                  ON arrival_sam.airport_pk = arrival_ha.airport_pk
                JOIN bookings_raw_vault.hub_airports departure_ha
                  ON lfa2.departure_airport_pk = departure_ha.airport_pk 
                JOIN bookings_raw_vault.sat_airports_main departure_sam
                  ON departure_sam.airport_pk = departure_ha.airport_pk
             ) f1
         GROUP BY f1.flight_no
             , f1.departure_airport
             , f1.arrival_airport
             , f1.aircraft_code
             , f1.duration
             , f1.days_of_week
         ORDER BY f1.flight_no
             , f1.departure_airport
             , f1.arrival_airport
             , f1.aircraft_code
             , f1.duration
             , f1.days_of_week
         ) f2
     GROUP BY f2.flight_no
         , f2.departure_airport
         , f2.arrival_airport
         , f2.aircraft_code
         , f2.duration
     )
SELECT f3.flight_no
     , f3.departure_airport
     , dep.airport_name AS departure_airport_name
     , dep.city AS departure_city
     , f3.arrival_airport
     , arr.airport_name AS arrival_airport_name
     , arr.city AS arrival_city
     , f3.aircraft_code
     , f3.duration
     , f3.days_of_week
  FROM f3
  JOIN bookings_raw_vault.hub_airports dep_ha
    ON dep_ha.airport_code = f3.departure_airport
  JOIN bookings_raw_vault.sat_airports_main dep
    ON dep.airport_pk = dep_ha.airport_pk
  JOIN bookings_raw_vault.hub_airports arr_ha
    ON arr_ha.airport_code = f3.arrival_airport
  JOIN bookings_raw_vault.sat_airports_main arr
    ON arr.airport_pk = arr_ha.airport_pk;
