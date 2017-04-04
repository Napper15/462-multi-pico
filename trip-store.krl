ruleset trip_store{
        meta {
                name "Trip Store"
                description << Part 3 Pico Trip Store >>
                author "Michael K."
                logging on
		shares get_trips, get_long_trips, get_short_trips
		provides get_trips, get_long_trips, get_short_trips        
	}
        global{
                trips = {}
                long_trips = {}

                get_trips = function(){
                        ent:trips
                }
		get_long_trips = function(){
			ent:long_trips
		}
		get_short_trips = function(){
			ent:trips.filter(function(tip){
				(trip.mileage > 100)
			})
		}

        }
        rule collect_trips{
                select when explicit trip_processed

                pre{
                        trip = {"mileage" : event:attr("mileage") , "timestamp" : time:now()}
                }
                always{
                        ent:trips := ent:trips.append(trip)
                }
        }
        rule collect_long_trips{
                select when explicit found_long_trip

                pre{
                        long_trip = {"mileage" : event:attr("mileage") , "timestamp" : time:now()}
                }
                always{
                        ent:long_trips := ent:long_trips.append(long_trip)
                }
        }
        rule clear_trips{
                select when car trip_reset

                send_directive("message") with
                message = "trips cleared"

                always{
                        ent:long_trips := {}
                }
        }
}
