extends RefCounted
const Seed = preload("res://scripts/seed.gd")
var data: Dictionary
var rng = RandomNumberGenerator.new()

func _init(seed_number: int = 0) -> void:
	rng.seed = seed_number if seed_number != 0 else int(Time.get_unix_time_from_system())
	data = Seed.create(rng.seed)
	record("Nate was found unconscious beside a bypassed machine guard. The person responsible is unknown.", ["daniel", "harold", "luis"], "direct observation", false, "important")
	record("Luis noticed a blank inspection line in the maintenance log before the shift.", ["luis"], "personal observation", false, "important", "luis")
	story("Line 4's forty-ton hydraulic stamping press is still cycling with a deafening, rhythmic shudder—temperamental German iron that has been threatening to eat an operator since the Carter administration. On the cold concrete floor, twenty-six-year-old Nate Bell is crumpled beneath the housing, motionless. Arterial blood pools dark between the floor drains, soaking through his shredded sleeve where the hydraulic pinch point caught him. A length of stiff copper bailing wire holds the safety guard pinned wide open—the kind of graveyard-shift shortcut guys use to hit company piece-rates without losing their lunch break.\n\nNate is breathing—shallow, wet, ragged gasps. The air reeks of scorched hydraulic oil, iron, and burnt insulation. Behind you, the fire door slams against cinderblock. Harold Voss, your plant manager, steps onto the mezzanine floor, chest heaving and sweat glistening on his temples. Harold hasn't turned a wrench in twenty years, but he can smell an OSHA lawsuit from across the county. His eyes dart straight to the twisted wire on the guard before he even looks down at Nate’s mangled arm.\n\n‘Jesus Christ,’ Harold whispers, his voice shaking with furious panic. ‘That guard wasn’t bypassed when I left tonight.’\n\nYour phone is gripped tight in your hand. You're Daniel Mercer, night shift supervisor, nine years in this rust-bucket plant, and it is 2:10 in the morning.")

func player() -> Dictionary:
	return data.characters[data.player]

func flag(key: String) -> bool:
	return bool(data.flags.get(key, false))

func record(fact: String, witnesses: Array, source: String = "direct observation", possibly_false: bool = false, level: String = "working", subject: String = "") -> String:
	var id = "E%06d" % (data.events.size() + 1)
	var actual_witnesses: Array = []
	for who in witnesses:
		if data.characters.has(who) and data.characters[who].alive and not actual_witnesses.has(who):
			actual_witnesses.append(who)
	data.events.append({"id": id, "timestamp": data.minute, "fact": fact, "witnesses": actual_witnesses, "source": source, "is_claim": possibly_false, "subject": subject})
	for who in actual_witnesses:
		data.knowledge.append({"fact": fact, "character": who, "source": id + " / " + source, "confidence": 0.65 if possibly_false else 1.0, "timestamp": data.minute, "possibly_false": possibly_false})
		data.memories.append({"event": id, "character": who, "text": fact, "timestamp": data.minute, "level": level, "subject": subject})
		var key = who + ":" + subject
		if data.relationships.has(key):
			data.relationships[key].memories.append(id)
	return id

func witnesses(location: String) -> Array:
	var result: Array = []
	for id in data.characters:
		if data.characters[id].alive and data.characters[id].location == location and data.characters[id].health > 30:
			result.append(id)
	return result

func knows(who: String, fragment: String) -> bool:
	return data.knowledge.any(func(k): return k.character == who and fragment in k.fact)

func knowledge_for(who: String) -> Array:
	return data.knowledge.filter(func(k): return k.character == who)

func memories_for(who: String, subject: String = "") -> Array:
	var all: Array = data.memories.filter(func(m): return m.character == who and (subject.is_empty() or m.subject == subject))
	return all.slice(-12)

func relationship(who: String, target: String, dimension: String, delta: int) -> void:
	var key = who + ":" + target
	if data.relationships.has(key):
		data.relationships[key][dimension] = clampi(int(data.relationships[key][dimension]) + delta, 0, 100)

func advance(minutes: int) -> void:
	data.minute += minutes
	data.turn += 1
	player().fatigue = mini(100, int(player().fatigue) + maxi(1, int(minutes / 40)))
	for m in data.memories:
		if m.level == "working" and data.minute - m.timestamp > 1440:
			m.level = "archived"

func story(text: String) -> void:
	data.story_log.append({"minute": data.minute, "player": data.player, "location": player().location, "text": text})

func clock_text() -> String:
	var minute = int(data.minute) % 1440
	return "DAY %02d   /   %02d:%02d" % [int(data.minute / 1440) + 1, int(minute / 60), minute % 60]

func save_world(path: String = "user://world.json") -> Error:
	# RNG state is a string: JSON floating-point numbers cannot preserve 64 bits.
	data.rng_state = str(rng.state)
	var file = FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	file.close()
	return DirAccess.rename_absolute(path + ".tmp", path)

func load_world(path: String = "user://world.json") -> Error:
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not valid_save(parsed):
		return ERR_FILE_CORRUPT
	data = parsed
	rng.state = int(data.rng_state)
	return OK

func valid_save(d: Variant) -> bool:
	if not d is Dictionary or d.get("schema") != 1:
		return false
	for key in ["flags", "characters", "relationships", "objects", "locations"]:
		if not d.get(key) is Dictionary:
			return false
	for key in ["events", "knowledge", "memories", "story_log", "intentions", "deaths"]:
		if not d.get(key) is Array:
			return false
	for key in ["minute", "turn", "seed"]:
		if not (d.get(key) is float or d.get(key) is int):
			return false
	if not d.get("rng_state") is String or not d.rng_state.is_valid_int():
		return false
	if not d.get("scene") in ["accident", "pressure", "statement", "homecoming", "town", "danger", "encounter", "ended"] or not d.characters.has(d.get("player", "")) or d.story_log.is_empty():
		return false
	if d.scene == "encounter" and not preload("res://scripts/encounters.gd").new().catalogue().has(d.flags.get("encounter", "")):
		return false
	if d.scene == "danger" and not d.flags.get("hazard", "") in ["fire", "electrical", "fall", "chemical", "industrial", "collapse", "road", "medical"]:
		return false
	for id in data.characters:
		if not d.characters.has(id):
			return false
	for p in d.characters.values():
		if not p is Dictionary:
			return false
		for key in data.characters.daniel:
			if not p.has(key):
				return false
		for key in ["name", "id", "occupation", "location"]:
			if not p[key] is String:
				return false
		for key in ["age", "health", "fatigue"]:
			if not number(p[key]) or p[key] < 0:
				return false
		for key in ["goals", "fears", "secrets", "beliefs", "possessions"]:
			if not p[key] is Array:
				return false
		if not p.alive is bool or not p.personality is Dictionary:
			return false
		if not d.locations.has(p.location) or not p.finances is Dictionary or not p.finances.get("cash") is float and not p.finances.get("cash") is int:
			return false
		if not number(p.finances.get("debt")):
			return false
	for key in data.relationships:
		if not d.relationships.get(key) is Dictionary:
			return false
		for dimension in data.relationships[key]:
			var value = d.relationships[key].get(dimension)
			if dimension == "memories":
				if not value is Array:
					return false
			elif not number(value) or value < 0 or value > 100:
				return false
	for id in ["guard", "phone", "maintenance_log"]:
		if not d.objects.get(id) is Dictionary or not d.objects[id].has_all(["owner", "location", "condition", "history"]):
			return false
	for intent in d.intentions:
		if not intent is Dictionary or not intent.has_all(["actor", "action", "due", "why", "status"]) or not d.characters.has(intent.actor) or not number(intent.due):
			return false
	for e in d.events:
		if not e is Dictionary or not e.has_all(["id", "timestamp", "fact", "witnesses"]):
			return false
	for k in d.knowledge:
		if not k is Dictionary or not k.has_all(["fact", "character", "source", "confidence", "timestamp", "possibly_false"]):
			return false
	for m in d.memories:
		if not m is Dictionary or not m.has_all(["event", "character", "text", "timestamp", "level", "subject"]):
			return false
	for entry in d.story_log:
		if not entry is Dictionary or not entry.has_all(["minute", "player", "location", "text"]):
			return false
	return true

func number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))
