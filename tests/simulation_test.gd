extends SceneTree
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
var failures = 0
var checks = 0

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		printerr("FAIL: " + message)

func run(d, w, ids: Array) -> void:
	for id in ids:
		if w.data.scene == "encounter":
			check(d.act(w, d.choices(w)[0].id), "Resolve intervening storylet")
		check(d.act(w, id), "Action accepted: " + id + " / " + d.last_error)

func _initialize() -> void:
	var d = Director.new()
	var w = World.new(1234)
	check(w.data.characters.size() == 30, "Thirty named residents")
	check(w.knowledge_for("erin").is_empty(), "Erin starts without factory knowledge")
	var old = JSON.stringify(w.data)
	for i in 20:
		d.choices(w)
	check(JSON.stringify(w.data) == old, "Browsing choices is read-only")
	check(not d.act(w, "made_up_action"), "Unknown actions rejected")
	check(JSON.stringify(w.data) == old, "Rejected action cannot mutate state")
	run(d, w, ["photo", "witness", "lie", "tell"])
	check(w.knows("erin", "knowingly misled"), "Disclosure informs Erin of lie")
	check(not w.knows("chloe", "misled"), "Chloe cannot inherit private disclosure")
	check(not w.knows("cole", "knowingly gave"), "Cole cannot know Daniel’s intent")
	check(w.knowledge_for("cole").any(func(k): return k.possibly_false), "Cole’s received claim has uncertainty")
	check(w.data.relationships["erin:daniel"].trust < 38, "Erin can love Daniel and lose trust")
	run(d, w, ["rest", "rest", "investigate", "rest", "rest", "rest", "rest", "rest", "rest", "rest"])
	check(w.flag("luis_spoke"), "Witness acts autonomously")
	check(w.flag("case_open"), "Evidence starts investigation")
	check(w.flag("plant_closed"), "Earlier evidence leads to closure days later")
	check(not w.knows("daniel", "filled an inspection"), "Private log alteration is not omniscient")
	check(w.knows("erin", "sent an application"), "Erin pursues private agenda")
	check(not w.knows("daniel", "sent an application"), "Player cannot read private agenda")
	check(w.data.memories.any(func(m): return m.level == "archived"), "Older routine memories archive")
	var path = "res://tests/roundtrip.json"
	check(w.save_world(path) == OK, "Save succeeds")
	var loaded = World.new(999)
	check(loaded.load_world(path) == OK, "Load succeeds")
	check(JSON.parse_string(JSON.stringify(w.data)) == loaded.data, "All state survives JSON round trip")
	check(w.rng.randi() == loaded.rng.randi(), "Random state survives save/load")
	run(d, w, ["rest"])
	run(d, loaded, ["rest"])
	check(JSON.parse_string(JSON.stringify(w.data)) == JSON.parse_string(JSON.stringify(loaded.data)), "Loaded world continues identically")
	check(w.save_world(path) == OK, "Existing save replaced atomically")
	var bad: Dictionary = JSON.parse_string(JSON.stringify(w.data))
	bad.characters.erin.health = "not a number"
	check(not loaded.valid_save(bad), "Malformed character values rejected")
	bad = JSON.parse_string(JSON.stringify(w.data))
	bad.relationships.erase("erin:daniel")
	check(not loaded.valid_save(bad), "Missing relationships rejected")
	var corrupt = FileAccess.open("res://tests/corrupt.json", FileAccess.WRITE)
	corrupt.store_string('{"schema": 1}')
	corrupt.close()
	old = JSON.stringify(loaded.data)
	check(loaded.load_world("res://tests/corrupt.json") == ERR_FILE_CORRUPT, "Corrupt save rejected")
	check(JSON.stringify(loaded.data) == old, "Failed load preserves current story")
	var secret = World.new(7)
	run(d, secret, ["ambulance", "defer", "truth", "hide"])
	check(not secret.knows("erin", "Nate"), "Concealment preserves Erin’s ignorance")
	check(secret.data.characters.nate.health > 40, "Prompt response improves Nate’s condition")
	var accusation = World.new(12)
	run(d, accusation, ["stop", "refuse", "blame", "partial", "rest", "rest", "rest", "visit"])
	check(accusation.knows("nate", "suggested Nate"), "Rumor follows explicit source chain")
	check("Cole told me" in accusation.data.story_log.back().text, "Old allegation returns in conversation")
	var inherited = false
	for seed_number in range(1, 30):
		var risk_world = World.new(seed_number)
		run(d, risk_world, ["stop", "defer", "truth", "partial"])
		for i in 12:
			d.setup_danger(risk_world, "fire", "Test hazard")
			check(d.act(risk_world, "risk"), "Warned danger can resolve")
			if risk_world.data.player != "daniel":
				check(not risk_world.data.characters.daniel.alive, "Death persists")
				check(risk_world.data.events.size() > 5, "History preserved after succession")
				check(risk_world.player().alive, "Successor is alive")
				check(not d.choices(risk_world).is_empty(), "Successor can continue")
				check(not risk_world.knows(risk_world.data.player, "private intention"), "Successor has own perspective")
				inherited = true
				break
		if inherited:
			break
	check(inherited, "Permadeath resolves to a playable successor")
	for hazard in ["industrial", "road", "fire", "electrical", "fall", "chemical", "collapse", "medical"]:
		var safe_world = World.new(123)
		d.setup_danger(safe_world, hazard, "Hazard test")
		check(d.act(safe_world, "safe"), "Safe exit available for " + hazard)
		check(safe_world.player().alive and safe_world.player().health == 100, "Safe exit prevents harm for " + hazard)
	for seed_number in range(5):
		var sim = World.new(seed_number + 100)
		for step in 160:
			var options: Array = d.choices(sim)
			check(not options.is_empty(), "Available action in long run")
			if options.is_empty():
				break
			var choice: Dictionary = options[sim.rng.randi_range(0, options.size() - 1)]
			check(d.act(sim, choice.id), "Long-run action remains valid")
		check(sim.data.minute > 10080, "Simulation runs beyond one week")
	# Financial system assertions: context, trade-offs, and timing
	var fw = World.new(4321)
	const Finances = preload("res://scripts/finances.gd")
	check(Finances.available_cash(fw) == 420, "Starting cash initialized")
	check(Finances.total_debt(fw) == 0, "Starting debt initialized with zero debt")
	check(Finances.bills_due(fw) == 80, "Initial bills due is $80 heating bill")
	check(Finances.status_line(fw) == "Available $420  ·  Debt $0  ·  Bills due $80", "Minimal status line formatted correctly")
	run(d, fw, ["photo", "witness", "truth", "tell"])
	check(d.choices(fw).any(func(c): return c.id == "bills_credit"), "Credit card payment alternative available")
	check(d.act(fw, "bills_credit"), "Pay bill with credit card succeeds")
	check(Finances.bills_due(fw) == 0, "Heating bill cleared via credit")
	check(Finances.total_debt(fw) == 80, "Debt increased by $80 on credit card")
	check(Finances.available_cash(fw) == 420, "Cash preserved when using credit card")
	fw.player().finances.cash = 0
	fw.data.scene = "encounter"
	fw.data.flags.encounter = "school"
	var school_choices = d.choices(fw)
	check(school_choices.size() >= 4, "All encounter choices offered even with $0 cash (no hard lock)")
	check(d.act(fw, "pay"), "Pay choice resolves gracefully with $0 cash into credit/owed balance")
	check(fw.player().finances.debt == 125, "Shortfall converted to debt instead of hard-locking")
	print("SIMULATION TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
