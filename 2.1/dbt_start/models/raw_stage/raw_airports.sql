SELECT apd.airport_code
     , apd.airport_name
     , apd.city
     , apd.coordinates[1]                AS longitude
     , apd.coordinates[0]                AS latitude
     , apd.timezone
  FROM {{ source('raw', 'airports_data')}}  AS apd