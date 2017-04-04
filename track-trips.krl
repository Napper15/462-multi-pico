ruleset track_trips {
	meta {
		name "track trips"
		description << Part 1 Pico Track Trips >>
		author "Michael K."
		logging on
	}

	rule process_trip {
		select when echo message
		pre{
			mileage = event:attr("mileage")
		}
		send_directive("trip") with
		trip_length = "#{mileage}"
	}
}	
