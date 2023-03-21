local os = require('os')
local tnt_kafka = require('kafka')
local json = require('json')
local pg = require('pg')
require('space')

local conn = pg.connect({host='127.0.0.1', user='postgres', password='postgres', port=5432, db='demo'})

local consumer, err = tnt_kafka.Consumer.create({
    brokers = "localhost:9092",
    options = {
        ["group.id"] = "tarantool_consumer"
    },
    default_topic_options = {
        ["auto.offset.reset"] = "earliest",
    }
})

if err ~= nil then
    print(err)
    os.exit(1)
end

local err = consumer:subscribe({"Data_Vault.bookings_raw_vault.hub_aircrafts", "Data_Vault.bookings_raw_vault.sat_aircrafts_main"})
if err ~= nil then
    print(err)
    os.exit(1)
end

local out, err = consumer:output()
if err ~= nil then
    print(string.format("got fatal error '%s'", err))
    os.exit(1)
end

while true do
    if out:is_closed() then
        os.exit(1)
    end
    
    local msg = out:get()
    if msg ~= nil then
        print(string.format(
            "got msg with topic='%s' partition='%s' offset='%s' key='%s' value='%s'",
            msg:topic(), msg:partition(), msg:offset(), msg:key(), msg:value()
        ))
    end
    
    local value = json.decode(msg:value())
    local after = value.after
    local before = value.before
    
    
    if after == nil then
    	local aircraft_code = before.aircraft_code
        aircrafts:delete{aircraft_code}
    else
    	local aircraft_code = after.aircraft_code
    	local aircrafts_view = conn:execute([[
SELECT ha.aircraft_code
     , sam.model ->> bookings.lang() AS model
     , sam."range"
  FROM bookings_raw_vault.hub_aircrafts ha
  JOIN bookings_raw_vault.sat_aircrafts_main sam
    ON sam.aircraft_pk = ha.aircraft_pk
 WHERE ha.aircraft_code = ']] .. aircraft_code .. [['
 ORDER BY sam."range" DESC;
        ]])[1][1]
    	if next(aircrafts:select{aircraft_code}) == nil then
	    aircrafts:insert{aircraft_code, aircrafts_view.model, aircrafts_view.range}
	else
	    aircrafts:update(aircraft_code, {{'=', 2, aircrafts_view.model}, {'=', 3, aircrafts_view.range}})
	end
    	
    end
end

conn:close()
consumer:close()

