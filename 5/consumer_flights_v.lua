local os = require('os')
local log = require('log')
local tnt_kafka = require('kafka')
local json = require('json')

local table_names = {
   "hub_aircrafts",
   "hub_airports",
   "hub_flights",
   "hub_tickets",
   "link_flights_aircrafts",
   "link_flights_airports",
   "link_flights_tickets",
   "sat_aircrafts_main",
   "sat_aircrafts_seats",
   "sat_airports_main",
   'sat_bookings_main',
   'sat_flights_main',
   'sat_tickets_boarding_passes',
   'sat_tickets_main'
}
local topic_name = "Data_Vault.booking_raw_vault."

require('cdc_space')

local consumer, err = tnt_kafka.Consumer.create({
    brokers = "localhost:9092",
    options ={["group.id"] = "new_group"}
})

if err ~= nil then
    print(err)
    os.exit(1)
end

for table_name in table_names do
    local err = consumer:subscribe({ "Data_Vault.booking_raw_vault.jiratest" })
    if err ~= nil then
        print(err)
        os.exit(1)
    end
end
local err = consumer:subscribe({ "Data_Vault.booking_raw_vault.jiratest" })
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
    
    local key = json.decode(msg:key()).id
    if after == nil then
    	cdc_test:delete{key}
    else
    	if next(cdc_test:select{key}) == nil then
	    cdc_test:insert{key, after.id, after.name}
	else
	    cdc_test:update(key, {{'=', 2, after.id}, {'=', 3, after.name}})
	end
    	
    end
end

consumer:close()
