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
	
	# Generate wild, unhinged moment-to-moment chaos during town progression
	if minutes_passed >= 15:
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
			"Across the bay, a forklift doing high-speed donuts on grease-slick concrete crashes straight through a stack of empty 55-gallon oil drums, sending pigeons scattering and workers diving for cover!",
			"High above the floor, an industrial crane cable snaps with a gunshot crack, swinging a 10-ton steel die inches over the catwalk before smashing violently into a steel girder!",
			"Harold Voss kicks open his booth door brandishing a fire extinguisher and a double espresso, shrieking at two mechanics who just accidentally set the secondary breaker panel on fire!",
			"A surveillance drone with a blinking red lens buzzes low through the stamping bay; press operators throw heavy combination wrenches at it until it zips out the roof exhaust vent!"
		],
		"diner": [
			"The diner jukebox short-circuits with a shower of sparks, blasting thrash metal at maximum volume while the kitchen deep fryer erupts into a four-foot grease inferno!",
			"A flatbed tow truck with smoking brakes skids sideways through the icy gravel lot, obliterating two newspaper stands before wedging itself against the steel dumpster!",
			"Two off-duty pressmen and an angry repo bounty hunter get into a wild fistfight over a stolen catalytic converter, sending plates of hash browns flying across the counter!",
			"State troopers burst into the diner with shotguns unholstered, arresting an unhinged courier who was trying to stash crates of racing nitrous behind the pie display!"
		],
		"hospital": [
			"A patient strapped into a motorized wheelchair with a modified motorcycle battery roars down the linoleum hallway at 25 mph, pursued by three screaming orderlies!",
			"The trauma bay automatic doors slam open as a high-speed police pursuit terminates right in the ambulance bay, tires smoking and sirens deafening the emergency room!",
			"The St. Anne's PA system screeches in panic: 'Code Red in the boiler room! The auxiliary diesel tank is leaking into the laundry chute!'",
			"A private investigator in a cheap fedora gets body-slammed onto a gurney by hospital security after trying to bug Nate's recovery room with a wiretap!"
		],
		"station": [
			"A confiscated crate of black-market fireworks in the evidence cage suddenly starts popping and shooting colorful sparks across the ceiling, sending officers scrambling under desks!",
			"Investigator Cole's office door flies open as federal marshals in tactical armor wheel in five impounded server towers seized from Harold Voss's shell company!",
			"The police dispatch switchboard lights up like a pinball machine—half the county is reporting an unlicensed armored bulldozer tearing down the old rail line!",
			"An emergency dispatcher barks over the intercom that a tanker carrying twenty thousand gallons of industrial silicone has overturned on the county bridge!"
		],
		"home": [
			"Outside the kitchen window, Rebecca Shaw test-fires a propane-powered potato cannon across the creek, scoring a direct hit on a rogue surveillance drone that spirals into the trees!",
			"A speeding county utility van clips your mailbox into kindling; the driver tosses out a pre-stamped apology envelope and burns rubber down the road!",
			"The kitchen scanner screams with frantic chatter as the county sheriff reports three prize-winning Angus bulls escaped a trailer and are charging oncoming traffic!",
			"A black unmarked helicopter sweeps a blinding spotlight across your roof and tree line for five terrifying seconds before banking sharply toward the mountains!"
		],
		"road": [
			"A supercharged muscle car with flames spitting from straight pipes roars past you at 100 mph, pursued by three state police interceptors in hot pursuit!",
			"A livestock hauler jackknifes across the bridge, dumping fifty squealing greased pigs across both lanes and forcing you to swerve into the gravel shoulder!",
			"You swerve hard to avoid a burning sectional sofa that flew off a moving trailer, sparks peppering your windshield as you punch the four-wheel drive!",
			"High-voltage power lines whip violently across the road like electric whips, exploding in blinding blue flashes against the asphalt as emergency crews drop flares!"
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
