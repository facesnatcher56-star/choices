extends SceneTree

class TestView extends "res://scripts/story_view.gd":
	func autosave() -> void:
		assert(world.save_world("res://tests/visual_checkpoint.json") == OK)

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var view = TestView.new()
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/screen.png")
	view.show_panel("menu")
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/menu.png")
	view.show_panel("debug")
	view.inspector_picker.select(1)
	view.inspector_mode.select(1)
	view.render_debug()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/inspector.png")
	view.panel.hide()
	for id in ["stop", "witness", "truth", "tell"]:
		view.director.act(view.world, id)
	view.refresh()
	await process_frame
	await process_frame
	view.body_scroll.scroll_vertical = int(view.body_scroll.get_v_scroll_bar().max_value)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/home_choices.png")
	view.choose("bills")
	await process_frame
	await process_frame
	await create_timer(0.45).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/new_outcome.png")
	view.body_scroll.scroll_vertical = int(view.body_scroll.get_v_scroll_bar().max_value)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/after_bills.png")
	for id in ["rest", "rest", "rest"]:
		if view.world.data.scene == "encounter":
			break
		view.director.act(view.world, id)
	view.refresh()
	await process_frame
	await process_frame
	view.body_scroll.scroll_vertical = int(view.body_scroll.get_v_scroll_bar().max_value)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/later_scene.png")
	print("Visual captures written to tests/.")
	view.queue_free()
	await process_frame
	quit()
