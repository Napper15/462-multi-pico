ruleset manage_fleet {
	meta {
        name "Manage fleet"
		description << Multi-pico managing the fleet >>
		author "Michael K."
		logging on
        use module Subscriptions
        shares vehicles, get_all
    }
    global{
        vehicles = function(){
            ent:vehicles
            }
        }
    rule create_vehicle {
        select when car new_vehicle
        pre{
            vehicle_id = event:attr("vehicle_id")
            exists = ent:vehicles >< vehicle_id
            eci = meta:eci
        }
        if exists then
            send_directive("vehicle_ready") 
                with vehicle_id = vehicle_id
        fired {}
        else {
            raise pico event "new_child_request"
                attributes { 
                    "dname" : nameFromID(vehicle_id),
                    "vehicle_id" : vehicle_id,
                    "eci" : eci
                }
        }
    }
   
    rule delete_vehicle {
        select when car uneeded_vehicle
        pre {
            vehicle_id = event:attr("vehicle_id")
            exists = ent:vehicles >< vehicle_id
            eci = meta:eci
            vehicle_to_delete = childFromID(vehicle_id)
        }
        if exists then
            send_directive("vehicle_deleted")
                with vehicle_id = vehicle_id
        fired{}
        else {
            raise pico event "delete_child_request"
                attributes child_to_delete;
            ent:vehicles{[vehicle_id]} := null
        }
    }
}