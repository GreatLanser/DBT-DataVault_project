box.cfg{
listen=3301
}

aircrafts = box.schema.space.create("aircrafts", {if_not_exists=true})
aircrafts:format({name = "aircraft_code", type = "string"},
                 {name = "model", type = "string"},
                 {name = "range", type = "integer"}                
                 )
aircrafts:create_index('primary', {if_not_exists=true, unique = true, parts = {{field = 1, type = 'string'}}})

airports = box.schema.space.create("airports", {if_not_exists=true})
airports:format({name = "airport_code", type = "string"},
                {name = "airport_name", type = "string"},
                {name = "city", type = "string"},
                {name = "coordinates", type = "string"},
                {name = "timezone", type = "cdata"}                
                )
airports:create_index('primary', {if_not_exists=true, unique = true, parts = {{field = 1, type = 'string'}}})


flights_v = box.schema.space.create("flights_v", {if_not_exists=true})
flights_v:format({name = "flight_id", type = "integer"},
                 {name = "flight_no", type = "string"},
                 {name = "scheduled_departure", type = "cdata"},
                 {name = "scheduled_departure_local", type = "cdata"},
                 {name = "scheduled_arrival", type = "cdata"},
                 {name = "scheduled_arrival_local", type = "cdata"},
                 {name = "scheduled_duration", type = "cdata"},
                 {name = "departure_airport", type = "string"},
                 {name = "departure_airport_name", type = "map"},
                 {name = "departure_city", type = "map"},
                 {name = "arrival_airport", type = "string"},
                 {name = "arrival_airport_name", type = "map"},
                 {name = "arrival_city", type = "map"},
                 {name = "status", type = "string"},
                 {name = "aircraft_code", type = "string"},
                 {name = "actual_departure", type = "cdata"},
                 {name = "actual_departure_local", type = "cdata"},
                 {name = "actual_arrival", type = "cdata"},
                 {name = "actual_arrival_local", type = "cdata"},
                 {name = "actual_duration", type = "cdata"}
                 )
flights_v:create_index('primary', {if_not_exists=true, unique = true, parts = {{field = 1, type = 'string'}}})


routes = box.schema.space.create("routes", {if_not_exists=true})
routes:format({name = "flight_no", type = "string"},
              {name = "departure_airport", type = "string"},
              {name = "departure_airport_name", type = "map"},
              {name = "departure_city", type = "map"},
              {name = "arrival_airport", type = "string"},
              {name = "arrival_airport_name", type = "map"},
              {name = "arrival_city", type = "map"},
              {name = "aircraft_code", type = "string"},
              {name = "duration", type = "cdata"},
              {name = "days_of_week", type = "array"}
              )
routes:create_index('primary', {if_not_exists=true, unique = true, parts = {{field = 1, type = 'string'}}})

