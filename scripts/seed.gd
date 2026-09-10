extends RefCounted
const WorldTruths = preload("res://scripts/world_truths.gd")

static func create(seed_number: int) -> Dictionary:
	var d = {"schema": 1, "seed": seed_number, "rng_state": 0, "minute": 130, "turn": 0, "player": "daniel", "scene": "accident", "flags": {}, "characters": {}, "relationships": {}, "events": [], "knowledge": [], "memories": [], "objects": {}, "story_log": [], "intentions": [], "deaths": [], "locations": {"plant": "Mercer Works", "home": "Mercer house", "hospital": "St. Anne’s Hospital", "station": "Police station", "diner": "Juniper Diner", "road": "County road"}, "truths": WorldTruths.generate(seed_number)}
	var cast = [
		["daniel", "Daniel Mercer", 34, "Night supervisor", "plant", "Keep the family solvent", "Losing his job"],
		["erin", "Erin Mercer", 33, "Bookkeeper", "home", "Repair the marriage; get Chloe to school", "Financial dependence"],
		["chloe", "Chloe Mercer", 15, "Student", "home", "Keep her family together", "Being kept in the dark"],
		["matt", "Matt Mercer", 28, "Delivery driver", "diner", "Repay his brother", "Being useless"],
		["harold", "Harold Voss", 57, "Plant manager", "plant", "Keep the production contract", "An external investigation"],
		["luis", "Luis Ortega", 36, "Machine operator", "plant", "Protect coworkers", "Retaliation"],
		["nate", "Nate Bell", 26, "Machine operator", "plant", "Recover and keep his income", "Permanent injury"],
		["rebecca", "Rebecca Shaw", 41, "Librarian / neighbor", "home", "Help Erin without intruding", "Breaking a confidence"],
		["cole", "Officer Cole", 44, "Investigator", "station", "Establish what happened", "Missing evidence"]]
	var names = ["June Adler", "Sam Brooks", "Ava Chen", "Eli Davis", "Rosa Ellis", "Ben Foster", "Grace Hall", "Owen Irwin", "Maya James", "Paul Kent", "Leah Lane", "Ian Moss", "Nora Nash", "Dean Owens", "Tess Price", "Amir Quinn", "Joy Reed", "Seth Stone", "Ada Turner", "Cal West", "Zoe Young"]
	for i in names.size():
		cast.append(["local_%d" % i, names[i], 25 + i, ["Nurse", "Mechanic", "Shopkeeper", "Teacher", "Plant worker"][i % 5], ["hospital", "plant", "diner", "home"][i % 4], "Maintain a stable life", "Losing security"])
	for row in cast:
		d.characters[row[0]] = {"id": row[0], "name": row[1], "age": row[2], "occupation": row[3], "location": row[4], "alive": true, "health": 100, "fatigue": 20, "conditions": ["exhausted"] if row[0] == "daniel" else [], "personality": {"caution": 0.6, "loyalty": 0.7}, "possessions": [], "finances": {"cash": 420, "debt": 0}, "goals": [row[5]], "fears": [row[6]], "secrets": [], "beliefs": []}
	for a in d.characters:
		for b in d.characters:
			if a != b:
				d.relationships[a + ":" + b] = {"affection": 20, "trust": 40, "attraction": 0, "fear": 0, "respect": 45, "resentment": 5, "dependence": 0, "familiarity": 10, "memories": []}
	d.characters.daniel.finances.debt = 0
	d.characters.daniel.finances["credit_limit"] = 2500
	d.flags["bills"] = {"heating": {"title": "Overdue heating bill", "amount": 80, "due_day": 1, "status": "unpaid"}, "school": {"title": "Chloe's school field trip", "amount": 45, "due_day": 4, "status": "pending"}}
	d.characters.daniel.possessions = ["phone"]
	d.characters.nate.health = 28
	d.characters.erin.secrets = ["Considering a job two towns away"]
	d.relationships["erin:daniel"].merge({"affection": 78, "trust": 38, "resentment": 44, "dependence": 65, "familiarity": 95}, true)
	d.relationships["chloe:daniel"].merge({"affection": 85, "trust": 65, "dependence": 90, "familiarity": 95}, true)
	d.relationships["luis:daniel"].merge({"affection": 60, "trust": 65, "familiarity": 85}, true)
	d.relationships["nate:daniel"].merge({"resentment": 65, "trust": 20, "familiarity": 70}, true)
	d.objects = {"guard": {"owner": "plant", "location": "plant", "condition": "bypassed with wire", "history": []}, "maintenance_log": {"owner": "plant", "location": "plant", "condition": "intact", "history": []}, "phone": {"owner": "daniel", "location": "daniel", "condition": "working", "history": []}}
	return d
