extends SceneTree
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
const Nodes = preload("res://scripts/moon_data.gd").NODES
var failures = 0
var checks = 0

class TestView extends "res://scripts/story_view.gd":
	func autosave() -> void:
		world.save_world("res://tests/moon_ui_checkpoint.json")

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func _initialize() -> void:
	call_deferred("exercise")

func exercise() -> void:
	var d = Director.new()
	var fresh = World.new(77)
	check(fresh.data.scene == "moon" and fresh.player().name == "Alex Vale", "New story is default")
	check(fresh.data.story_log[0].text.contains("cake"), "New opening")
	check(fresh.data.intentions.is_empty() and fresh.data.truths.is_empty(), "No legacy simulation")
	for node in Nodes:
		for i in Nodes[node].choices.size():
			var w = World.new(77)
			w.data.flags.moon_node = node
			var row: Dictionary = Nodes[node].choices[i]
			check(Nodes.has(row.next), "Valid destination: " + node)
			check(row.label.split(" ").size() <= 5, "Short choice: " + row.label)
			check(d.act(w, "moon_%d" % i), "Resolve " + node)
			check(w.save_world("res://tests/moon_snapshot.json") == OK, "Save branch")
			var restored = World.new(33)
			check(restored.load_world("res://tests/moon_snapshot.json") == OK, "Restore branch")
			check(restored.data.flags == w.data.flags, "Preserve decisions")
			check(restored.data.characters.cole.name == "The Manager", "No legacy name migration")
			check(d.choices(restored) == d.choices(w), "Preserve options")
			var previous: String = JSON.stringify(w.data)
			check(not d.act(w, "moon_99"), "Reject invalid choice")
			check(JSON.stringify(w.data) == previous, "Invalid choice leaves state intact")
	var visited = {}
	var endings = {}
	var rng = RandomNumberGenerator.new()
	rng.seed = 1701
	for run in 150:
		var w = World.new(77)
		for step in 30:
			visited[w.data.flags.moon_node] = true
			var available: Array = d.choices(w)
			if available.is_empty():
				endings[w.data.flags.moon_node] = true
				break
			check(d.act(w, available[rng.randi_range(0, available.size() - 1)].id), "Full playthrough action")
		check(d.choices(w).is_empty(), "Playthrough ends")
	check(visited.size() == Nodes.size(), "Every scene reached: %d/%d" % [visited.size(), Nodes.size()])
	check(endings.size() == 6, "All six endings reached")
	for flag in ["key_inside", "mox_key", "punch", "none"]:
		var w = World.new(77)
		w.data.flags.moon_node = "key"
		w.data.flags["moon_" + flag] = true
		d.act(w, "moon_0")
		check(w.data.flags.moon_node == ("bed" if flag == "none" else "unlocked"), "Key consequence " + flag)
	var view = TestView.new()
	root.add_child(view)
	await process_frame
	view.finish_beats()
	check(not view.finance_sidebar.visible, "No factory finances")
	check(view.title_label.text == "Your funeral, apparently", "New scene title")
	check(view.choice_box.get_child_count() == 3, "Three simple choices")
	for button in view.choice_box.get_children():
		check(not button.text.contains("\n") and button.tooltip_text.is_empty(), "No outcome hints")
	view.choice_box.get_child(0).pressed.emit()
	await process_frame
	check(view.world.flag("moon_key_inside"), "Real button resolves new choice")
	check(view.world.data.flags.moon_node == "banquet", "Real button advances scene")
	view.show_panel("menu")
	check(not view.menu_summary.text.contains("Cash"), "No obsolete menu stats")
	view.panel.hide()
	view.world.data.flags.moon_node = "sea_end"
	view.refresh()
	view.finish_beats()
	check(view.choice_box.get_child_count() == 0, "Ending has no dangling choices")
	view.queue_free()
	await process_frame
	print("MOON TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
