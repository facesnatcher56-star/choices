extends RefCounted
## Simulates background NPC lives, daily routines, schedules, and ambient town events.
## Keeps track of the town moving and breathing alongside the player without repetitive loops.

func simulate(w, minutes_passed: int, before_day: int) -> String:
	# NEVER inject ambient background filler during tightly scripted narrative scenes
	if w.data.scene != "town":
		return ""
		
	var hour: int = (int(w.data.minute) % 1440) / 60
	var day: int = int(w.data.minute / 1440)
	var player_loc: String = w.player().location
	
	update_routines(w, hour, day)
	
	# Only generate ambient observations during genuine town progression
	if minutes_passed >= 30 and not w.flag("ambient_introduced_" + player_loc):
		w.data.flags["ambient_introduced_" + player_loc] = true
		var event = ambient_observation(w, hour, day, player_loc)
		if not event.is_empty():
			return event
			
	return ""

func update_routines(w, hour: int, day: int) -> void:
	var plant_closed: bool = w.flag("plant_closed")
	
	for actor in ["cole", "chloe", "erin", "nate", "luis", "harold", "matt", "rebecca"]:
		if actor != w.data.player and w.data.characters[actor].alive:
			w.data.characters[actor].location = preload("res://scripts/town_schedule.gd").routine_location(w, actor, w.data.minute)

	# Town locals: Working their shift rotations
	for id in w.data.characters:
		if not id.begins_with("local_") or id == w.data.player:
			continue
		var p: Dictionary = w.data.characters[id]
		if not p.alive:
			continue
		match p.occupation:
			"Nurse":
				p.location = "hospital" if (hour >= 7 and hour < 19) else "home"
			"Mechanic":
				p.location = "plant" if (not plant_closed and hour >= 6 and hour < 16) else ("diner" if hour < 21 else "home")
			"Shopkeeper":
				p.location = "diner" if (hour >= 8 and hour < 18) else "home"
			"Teacher":
				p.location = "home" if (hour < 8 or hour >= 16) else "diner"
			"Plant worker":
				p.location = "plant" if (not plant_closed and hour >= 6 and hour < 15) else ("diner" if hour >= 15 and hour < 21 else "home")

func ambient_observation(w, hour: int, day: int, loc: String) -> String:
	var pools: Dictionary = {
		"plant": [
			"Across the bay, someone taped a fresh handwritten sign over Line 4: 'DO NOT TOUCH - PENDING REVIEW'. Maintenance spelled 'pending' with two d's.",
			"In the glass supervisor’s booth, Harold is on the landline, holding a roll of Tums in one fist while shouting over the exhaust fans.",
			"A shift forklift clatters past, carrying a pallet of reject stampings. The driver gives you that tight, knowing nod men give each other when corporate is in the building."
		],
		"diner": [
			"Over by the jukebox at the Juniper Diner, two second-shift pressmen are arguing over who pays for coffee, checking the parking lot every time headlights sweep the window.",
			"Behind the counter, the griddle sizzles with bacon grease. A laminated sign on the register reads: 'NO CHECKS, NO CREDIT, NO EXCEPTIONS - WE MEAN YOU, HAROLD'.",
			"The diner radio is tuned to county weather—more freezing rain, naturally. The heater in the corner hums like an angry hornets' nest."
		],
		"hospital": [
			"Down the linoleum hallway of St. Anne's, a muted TV is broadcasting daytime commercials for personal injury attorneys who promise cash for 'industrial negligence'.",
			"A nurse wheels an empty squeaking gurney past, yawning behind her surgical mask. The fluorescent bulbs overhead buzz in a weary B-flat.",
			"Through the double doors of the recovery wing, the sharp reek of floor wax and rubbing alcohol battles with the smell of lukewarm cafeteria coffee."
		],
		"station": [
			"A receptionist sorts employer incident reports into dated folders behind the safety office counter.",
			"An agency car is parked beside the office. A hard hat and inspection equipment sit on the back seat.",
			"On the safety office corkboard, an OSHA compliance poster from 2014 hangs pinned crookedly between lost hound notices and sheriff campaign flyers."
		],
		"home": [
			"In the living room, the refrigerator compressor kicks on with its familiar shuddering rattle. On the kitchen counter, Chloe’s school lunchbox sits beside an overdue heating bill.",
			"Outside the kitchen window, the neighbor’s hound barks twice at a passing delivery van before settling back down into the mud.",
			"The pipes behind the bathroom wall groan as the water heater fires up. A draft creeps under the Mercer front door, carrying the scent of damp pines."
		],
		"road": [
			"A gravel hauler with a rusty tailgate blasts past on County 9, throwing a hail of wet grit against your windshield.",
			"Along the tree line, a rusted billboard for a defunct lumber yard leans at thirty degrees, half-swallowed by kudzu and November rot.",
			"A deer stands frozen on the shoulder in the freezing mist, watching your headlights before vanishing into the hemlocks."
		]
	}
	
	if not pools.has(loc):
		return ""
	var list: Array = pools[loc]
	var last_seen: String = str(w.data.flags.get("last_ambient_" + loc, ""))
	
	# Select an observation that wasn't the one just seen
	for item in list:
		if item != last_seen:
			w.data.flags["last_ambient_" + loc] = item
			return item
			
	return ""
