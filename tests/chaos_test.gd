extends SceneTree
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
var failures = 0

func check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		printerr(message)

func _initialize() -> void:
	var endings: Array = []
	for path in [[0, 0, 0, 0, 1, 0, 0, 0], [1, 0, 1, 0, 1, 0, 0, 0], [0, 1, 2, 1, 0, 1, 1, 1], [2, 2, 2, 2, 2, 2, 2, 2]]:
		var w = World.new(4321)
		var d = Director.new()
		for id in ["stop", "photo", "truth", "tell"]:
			check(d.act(w, id), "Opening failed")
		for step in range(8):
			check(d.act(w, "chaos_next"), "Chapter unavailable")
			check(w.data.scene == "chaos", "Chapter not entered")
			check(w.save_world("res://tests/chaos_save.json") == OK, "Save failed")
			var restored = World.new(99)
			check(restored.load_world("res://tests/chaos_save.json") == OK, "Mid-chapter load failed")
			check(d.choices(restored) == d.choices(w), "Choices changed after load")
			w = restored
			var before: int = w.data.minute
			check(not d.act(w, "chaos_99"), "Invalid branch accepted")
			check(w.data.minute == before, "Invalid branch advanced time")
			check(d.act(w, "chaos_%d" % path[step]), "Branch failed")
			check(int(w.data.flags.chaos_chapter) == step + 1, "Chapter replayed")
		endings.append(w.data.flags.get("chaos_ending", ""))
		check(not d.choices(w).any(func(c): return c.id == "chaos_next"), "Finished arc replayable")
	check(endings[0].begins_with("THE TOWN THAT BIT BACK"), "Combined ending missing")
	check(endings[1].begins_with("THE PAPERWORK APOCALYPSE"), "Evidence ending missing")
	check(endings[2].begins_with("REPUBLIC OF THE ROOSTER"), "Solidarity ending missing")
	check(endings[3].begins_with("EVERYTHING MUST GO"), "Sellout ending missing")
	var broke = World.new(123)
	var director = Director.new()
	broke.data.scene = "chaos"
	broke.data.flags.chaos_chapter = 4
	broke.player().finances.cash = 0
	check(not director.choices(broke).any(func(c): return c.id == "chaos_2"), "Unaffordable generator offered")
	print("CHAOS TESTS: %d failures" % failures)
	quit(1 if failures else 0)
