extends SceneTree
var failures = 0
var checks = 0

class TestView extends "res://scripts/story_view.gd":
	func autosave() -> void:
		var err = world.save_world("res://tests/ui_checkpoint.json")
		assert(err == OK)

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func _initialize() -> void:
	call_deferred("exercise")

func exercise() -> void:
	var view = TestView.new()
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	check(view.choice_box.get_child_count() == 6, "All scene choices shown directly without quiz pagination")
	var has_tooltip = false
	for btn in view.choice_box.get_children():
		if not btn.tooltip_text.is_empty():
			has_tooltip = true
	check(not has_tooltip, "No tooltip popups on answer hover")
	check(view.narrative.text.contains("Nate") and view.narrative.text.contains("stamping press"), "Narrative stream initialized with scene detail")
	check(not view.menu_controls.is_visible_in_tree(), "Secondary controls hidden while reading")
	check(not view.status_label.visible, "Routine status text hidden while reading")
	view.show_panel("menu")
	check(view.menu_controls.visible and not view.panel_text.visible, "Menu reveals controls only on demand")
	check(view.scrim.visible, "Menu blocks and dims the story")
	var before_menu = view.world.data.minute
	view.choose("ambulance")
	check(view.world.data.minute == before_menu, "Story cannot advance behind an open menu")
	view.panel.hide()
	check(not view.scrim.visible, "Closing the menu restores story focus")
	view.choice_box.get_child(0).pressed.emit()
	check(view.world.data.scene == "pressure", "Button commits action and transitions scene")
	check(view.narrative.text.contains("ambulance") or view.narrative.text.contains("›"), "Chosen action appended into continuous stream")
	check(FileAccess.file_exists("res://tests/ui_checkpoint.json"), "Choice autosaves")
	for mode in ["people", "knowledge", "history", "debug"]:
		view.show_panel(mode)
		check(view.panel.visible and not view.panel_text.text.is_empty(), "Panel renders " + mode)
	for p in view.inspector_picker.item_count:
		view.inspector_picker.select(p)
		for mode in 6:
			view.inspector_mode.select(mode)
			view.render_debug()
			check(not view.panel_text.text.is_empty(), "Inspector handles every resident and mode")
	view.panel.hide()
	view.choose("refuse")
	view.choose("truth")
	view.choose("tell")
	check(view.world.data.scene == "town", "Opening completes in actual view")
	view.load_path("res://tests/ui_checkpoint.json")
	check(view.world.data.scene == "town", "View loads checkpoint")
	view.confirm.confirmed.emit()
	check(view.world.data.scene == "accident" and view.world.data.turn == 0, "New story resets world")
	check(view.get_minimum_size().y <= 900, "UI fits reference height")
	print("UI TESTS: %d checks, %d failures" % [checks, failures])
	view.queue_free()
	await process_frame
	quit(1 if failures else 0)
