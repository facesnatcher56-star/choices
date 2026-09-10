extends Control
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
const StoryTheme = preload("res://scripts/story_theme.gd")
const Finances = preload("res://scripts/finances.gd")
const INK = StoryTheme.INK
const MUTED = StoryTheme.MUTED
const GOLD = StoryTheme.GOLD

var world = World.new()
var director = Director.new()
var page = 0
var choice_box: VBoxContainer
var narrative: RichTextLabel
var title_label: Label
var context_label: Label
var finance_label: Label
var finance_sidebar: VBoxContainer
var finance_cash_label: Label
var finance_debt_label: Label
var finance_bills_container: VBoxContainer
var page_margin: MarginContainer
var menu_controls: VBoxContainer
var menu_summary: Label
var menu_open = false
var scrim: ColorRect
var status_label: Label
var alternate_button: Button
var save_button: Button
var load_button: Button
var panel: PanelContainer
var panel_title: Label
var panel_text: RichTextLabel
var inspector_picker: OptionButton
var inspector_mode: OptionButton
var body_scroll: ScrollContainer
var live_choices: Array = []
var confirm: ConfirmationDialog

func _ready() -> void:
	theme = StoryTheme.create()
	build_screen()
	refresh()
	if "--capture" in OS.get_cmdline_user_args():
		await get_tree().process_frame
		await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png("res://tests/screen.png")
		get_tree().quit()

func label(text: String, font_size: int, color: Color = INK, weight: int = 400) -> Label:
	var l = Label.new()
	l.text = text
	l.add_theme_font_override("font", StoryTheme.font_ui(weight))
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	return l

func button(text: String, callback: Callable) -> Button:
	var b = Button.new()
	b.text = text
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.pressed.connect(callback)
	return b

func quiet_button(text: String, callback: Callable) -> Button:
	var b = button(text, callback)
	b.add_theme_stylebox_override("normal", StoryTheme.box_style(Color.TRANSPARENT, Color.TRANSPARENT, 3))
	b.add_theme_stylebox_override("hover", StoryTheme.box_style(Color("172126"), Color.TRANSPARENT, 3))
	b.add_theme_stylebox_override("pressed", StoryTheme.box_style(Color("1d2c31"), Color.TRANSPARENT, 3))
	b.add_theme_color_override("font_color", MUTED)
	return b

func build_finance_sidebar() -> void:
	finance_sidebar.custom_minimum_size.x = 210
	finance_sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var f_title = label("FINANCES", 11, StoryTheme.GOLD, 700)
	finance_sidebar.add_child(f_title)

	var cash_box = VBoxContainer.new()
	cash_box.add_theme_constant_override("separation", 2)
	finance_sidebar.add_child(cash_box)
	var cash_sub = label("AVAILABLE CASH", 10, MUTED, 600)
	cash_box.add_child(cash_sub)
	finance_cash_label = label("$420", 24, INK, 700)
	cash_box.add_child(finance_cash_label)

	var debt_box = VBoxContainer.new()
	debt_box.add_theme_constant_override("separation", 2)
	finance_sidebar.add_child(debt_box)
	var debt_sub = label("TOTAL DEBT", 10, MUTED, 600)
	debt_box.add_child(debt_sub)
	finance_debt_label = label("$0", 18, StoryTheme.MUTED, 700)
	debt_box.add_child(finance_debt_label)

	var sep = ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color("1c282e")
	finance_sidebar.add_child(sep)

	var bills_title = label("UPCOMING BILLS", 10, StoryTheme.GOLD, 600)
	finance_sidebar.add_child(bills_title)

	var bills_scroll = ScrollContainer.new()
	bills_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bills_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bills_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	finance_sidebar.add_child(bills_scroll)

	finance_bills_container = VBoxContainer.new()
	finance_bills_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	finance_bills_container.add_theme_constant_override("separation", 10)
	bills_scroll.add_child(finance_bills_container)

func update_finance_sidebar() -> void:
	var p = world.player()
	var cash = int(p.finances.get("cash", 0))
	var debt = int(p.finances.get("debt", 0))
	finance_cash_label.text = "$%d" % cash
	finance_debt_label.text = "$%d" % debt
	if debt > 0:
		finance_debt_label.add_theme_color_override("font_color", StoryTheme.WARN)
	else:
		finance_debt_label.add_theme_color_override("font_color", MUTED)

	for c in finance_bills_container.get_children():
		c.queue_free()

	var bills = Finances.ensure_bills(world)
	var current_day = int(world.data.minute / 1440) + 1
	var has_bills = false
	for id in bills:
		var b = bills[id]
		var status = b.get("status", "unpaid")
		var amount = int(b.get("amount", 0))
		var due_day = int(b.get("due_day", 1))

		var item = VBoxContainer.new()
		item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item.add_theme_constant_override("separation", 2)

		var title_lbl = Label.new()
		title_lbl.text = b.get("title", id.capitalize())
		title_lbl.add_theme_font_override("font", StoryTheme.font_ui(600))
		title_lbl.add_theme_font_size_override("font_size", 12)
		title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var detail_lbl = Label.new()
		detail_lbl.add_theme_font_override("font", StoryTheme.font_ui(400))
		detail_lbl.add_theme_font_size_override("font_size", 11)
		detail_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		if status in ["unpaid", "overdue"]:
			has_bills = true
			if due_day < current_day or status == "overdue":
				title_lbl.add_theme_color_override("font_color", StoryTheme.WARN)
				detail_lbl.text = "OVERDUE  ·  $%d" % amount
				detail_lbl.add_theme_color_override("font_color", StoryTheme.WARN)
			elif due_day == current_day:
				title_lbl.add_theme_color_override("font_color", StoryTheme.GOLD)
				detail_lbl.text = "Due today  ·  $%d" % amount
				detail_lbl.add_theme_color_override("font_color", StoryTheme.GOLD)
			else:
				title_lbl.add_theme_color_override("font_color", INK)
				detail_lbl.text = "Due Day %d  ·  $%d" % [due_day, amount]
				detail_lbl.add_theme_color_override("font_color", MUTED)
			item.add_child(title_lbl)
			item.add_child(detail_lbl)
			finance_bills_container.add_child(item)
		elif status == "pending":
			has_bills = true
			title_lbl.add_theme_color_override("font_color", MUTED)
			detail_lbl.text = "Due Day %d  ·  $%d" % [due_day, amount]
			detail_lbl.add_theme_color_override("font_color", MUTED)
			item.add_child(title_lbl)
			item.add_child(detail_lbl)
			finance_bills_container.add_child(item)

	if not has_bills:
		var empty_lbl = label("No bills pending.", 11, MUTED)
		finance_bills_container.add_child(empty_lbl)

func build_screen() -> void:
	page_margin = MarginContainer.new()
	page_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	page_margin.add_theme_constant_override("margin_top", 24)
	page_margin.add_theme_constant_override("margin_bottom", 24)
	add_child(page_margin)

	var h_layout = HBoxContainer.new()
	h_layout.add_theme_constant_override("separation", 36)
	page_margin.add_child(h_layout)

	finance_sidebar = VBoxContainer.new()
	finance_sidebar.custom_minimum_size.x = 210
	finance_sidebar.add_theme_constant_override("separation", 16)
	h_layout.add_child(finance_sidebar)
	build_finance_sidebar()

	var root = VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 16)
	h_layout.add_child(root)

	var header = VBoxContainer.new()
	header.add_theme_constant_override("separation", 6)
	root.add_child(header)

	var top_bar = HBoxContainer.new()
	header.add_child(top_bar)
	var brand = label("ONE BAD WEEK", 11, StoryTheme.GOLD, 700)
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(brand)
	finance_label = label("", 12, MUTED)
	finance_label.hide()
	top_bar.add_child(finance_label)
	var menu_btn = quiet_button("Menu", show_panel.bind("menu"))
	menu_btn.add_theme_font_override("font", StoryTheme.font_ui(600))
	top_bar.add_child(menu_btn)

	context_label = label("", 13, MUTED)
	context_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	header.add_child(context_label)

	var header_rule = ColorRect.new()
	header_rule.custom_minimum_size = Vector2(0, 1)
	header_rule.color = Color("1c282e")
	header.add_child(header_rule)

	var scroll_wrapper = Control.new()
	scroll_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll_wrapper)

	body_scroll = ScrollContainer.new()
	body_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	body_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_wrapper.add_child(body_scroll)

	var body_margin = MarginContainer.new()
	body_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_margin.add_theme_constant_override("margin_top", 16)
	body_margin.add_theme_constant_override("margin_bottom", 44)
	body_margin.add_theme_constant_override("margin_right", 16)
	body_scroll.add_child(body_margin)

	var body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 22)
	body_margin.add_child(body)

	var top_fade = TextureRect.new()
	top_fade.texture = StoryTheme.create_fade_texture(true)
	top_fade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	top_fade.anchor_left = 0
	top_fade.anchor_right = 1
	top_fade.anchor_top = 0
	top_fade.anchor_bottom = 0
	top_fade.offset_top = 0
	top_fade.offset_bottom = 28
	top_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scroll_wrapper.add_child(top_fade)

	var bottom_fade = TextureRect.new()
	bottom_fade.texture = StoryTheme.create_fade_texture(false)
	bottom_fade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bottom_fade.anchor_left = 0
	bottom_fade.anchor_right = 1
	bottom_fade.anchor_top = 1
	bottom_fade.anchor_bottom = 1
	bottom_fade.offset_top = -24
	bottom_fade.offset_bottom = 0
	bottom_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scroll_wrapper.add_child(bottom_fade)

	title_label = label("", 28, INK)
	title_label.add_theme_font_override("font", StoryTheme.font_serif(700))
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_child(title_label)

	narrative = RichTextLabel.new()
	narrative.bbcode_enabled = true
	narrative.fit_content = true
	narrative.scroll_active = false
	narrative.selection_enabled = true
	narrative.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	narrative.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	narrative.add_theme_font_override("normal_font", StoryTheme.font_serif(400))
	narrative.add_theme_font_override("bold_font", StoryTheme.font_serif(700))
	narrative.add_theme_font_override("italics_font", StoryTheme.font_serif(400, true))
	narrative.add_theme_font_override("bold_italics_font", StoryTheme.font_serif(700, true))
	narrative.add_theme_font_size_override("normal_font_size", 20)
	narrative.add_theme_font_size_override("bold_font_size", 20)
	narrative.add_theme_font_size_override("italics_font_size", 20)
	narrative.add_theme_font_size_override("bold_italics_font_size", 20)
	narrative.add_theme_constant_override("line_separation", 7)
	body.add_child(narrative)

	var breath = Control.new()
	breath.custom_minimum_size.y = 8
	body.add_child(breath)

	choice_box = VBoxContainer.new()
	choice_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_box.add_theme_constant_override("separation", 8)
	body.add_child(choice_box)

	alternate_button = quiet_button("Other approaches", next_page)
	alternate_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	alternate_button.add_theme_font_size_override("font_size", 14)
	alternate_button.hide()
	body.add_child(alternate_button)

	status_label = label("", 12, MUTED)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.hide()
	root.add_child(status_label)

	build_panel()
	confirm = ConfirmationDialog.new()
	confirm.title = "Begin a new story?"
	confirm.dialog_text = "This replaces the automatic checkpoint. Your manual save is kept."
	confirm.confirmed.connect(func():
		world = World.new()
		page = 0
		panel.hide()
		refresh()
		body_scroll.scroll_vertical = 0
		autosave())
	add_child(confirm)
	resized.connect(layout_page)
	layout_page()

func layout_page() -> void:
	var total_content = 1046
	var gutter = maxi(24, int((size.x - total_content) / 2))
	page_margin.add_theme_constant_override("margin_left", gutter)
	page_margin.add_theme_constant_override("margin_right", gutter)
	if panel.visible:
		layout_overlay()

func layout_overlay() -> void:
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var gutter = maxi(24, int((size.x - (520 if menu_open else 920)) / 2))
	panel.offset_left = gutter
	panel.offset_right = -gutter
	panel.offset_top = maxi(24, int((size.y - 690) / 2)) if menu_open else 40
	panel.offset_bottom = -panel.offset_top

func build_panel() -> void:
	scrim = ColorRect.new()
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scrim.color = Color(0.015, 0.025, 0.035, 0.88)
	scrim.hide()
	scrim.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			panel.hide())
	add_child(scrim)
	panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", StoryTheme.box_style(Color("101b22"), Color("2c3a40"), 10))
	panel.visible = false
	add_child(panel)
	panel.visibility_changed.connect(func(): scrim.visible = panel.visible)
	var v = VBoxContainer.new()
	panel.add_child(v)
	var h = HBoxContainer.new()
	v.add_child(h)
	panel_title = label("", 22, INK, 700)
	panel_title.add_theme_font_override("font", StoryTheme.font_serif(700))
	panel_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(panel_title)
	h.add_child(quiet_button("Close", func(): panel.hide()))
	menu_controls = VBoxContainer.new()
	v.add_child(menu_controls)
	menu_summary = label("", 15, MUTED)
	menu_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_controls.add_child(menu_summary)
	for item in [["People", "people"], ["What I know", "knowledge"], ["Story so far", "history"]]:
		var b = quiet_button(item[0], show_panel.bind(item[1]))
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		menu_controls.add_child(b)
	menu_controls.add_child(HSeparator.new())
	var saves = HBoxContainer.new()
	menu_controls.add_child(saves)
	save_button = quiet_button("Save story", save_manual)
	load_button = quiet_button("Resume checkpoint", resume_game)
	saves.add_child(save_button)
	saves.add_child(load_button)
	menu_controls.add_child(quiet_button("Load manual save", load_manual))
	menu_controls.add_child(quiet_button("New story", func(): confirm.popup_centered()))
	menu_controls.add_child(label("1–9  Choose action    ·    Tab  Focus\nEsc  Menu    ·    F3  World inspector", 12, MUTED))
	var filters = HBoxContainer.new()
	v.add_child(filters)
	inspector_picker = OptionButton.new()
	inspector_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for id in world.data.characters:
		inspector_picker.add_item(world.data.characters[id].name)
		inspector_picker.set_item_metadata(inspector_picker.item_count - 1, id)
	inspector_picker.item_selected.connect(func(_i): render_debug())
	filters.add_child(inspector_picker)
	inspector_mode = OptionButton.new()
	for mode in ["Knowledge & memories", "Character & agendas", "Relationships", "Canonical world", "Events & intentions", "Choice validation"]:
		inspector_mode.add_item(mode)
	inspector_mode.item_selected.connect(func(_i): render_debug())
	filters.add_child(inspector_mode)
	panel_text = RichTextLabel.new()
	panel_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_text.selection_enabled = true
	panel_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel_text.add_theme_font_override("normal_font", StoryTheme.font_ui(400))
	panel_text.add_theme_font_size_override("normal_font_size", 15)
	v.add_child(panel_text)

func refresh() -> void:
	var p: Dictionary = world.player()
	var minute = int(world.data.minute) % 1440
	context_label.text = "%s  ·  %s  ·  Day %d, %02d:%02d" % [p.name, world.data.locations[p.location], int(world.data.minute / 1440) + 1, int(minute / 60), minute % 60]
	finance_label.text = Finances.status_line(world)
	update_finance_sidebar()
	status_label.hide()
	title_label.text = {"accident": "Before the sirens", "pressure": "A consistent story", "statement": "For the record", "homecoming": "The kitchen light", "danger": "A moment to step back", "town": "Life goes on"}.get(world.data.scene, "The story continues")
	if world.data.scene == "encounter":
		title_label.text = director.encounters.catalogue()[world.data.flags.encounter].title

	# Flowing continuous narrative stream with color-coded dialogue and easy-on-the-eyes prose
	var stream: Array[String] = []
	for i in range(world.data.story_log.size()):
		var entry: Dictionary = world.data.story_log[i]
		if entry.has("action") and not str(entry.action).is_empty():
			stream.append("[color=" + StoryTheme.GOLD_COLOR + "]› [i]" + entry.action + "[/i][/color]\n")
		var formatted: String = StoryTheme.format_narrative(entry.text)
		stream.append(formatted)
	narrative.text = "\n\n".join(stream)

	for c in choice_box.get_children():
		choice_box.remove_child(c)
		c.queue_free()

	live_choices = director.choices(world)

	# Present all active choices cleanly without quiz-style pagination, clipping, or hover popups
	for i in range(live_choices.size()):
		var c: Dictionary = live_choices[i]
		var b = Button.new()
		b.text = "›  " + c.label
		b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_override("font", StoryTheme.font_ui(400))
		b.add_theme_font_size_override("font_size", 16)
		b.add_theme_color_override("font_color", INK)
		b.add_theme_color_override("font_hover_color", Color("fff7e6"))
		b.add_theme_color_override("font_focus_color", Color("fff7e6"))
		b.add_theme_stylebox_override("normal", StoryTheme.choice_style(Color("0f181e"), Color("1e2c34")))
		b.add_theme_stylebox_override("hover", StoryTheme.choice_style(Color("162630"), StoryTheme.GOLD))
		b.add_theme_stylebox_override("pressed", StoryTheme.choice_style(Color("1c303c"), StoryTheme.GOLD))
		b.add_theme_stylebox_override("focus", StoryTheme.choice_style(Color("0f181e"), StoryTheme.GOLD))
		b.pressed.connect(choose.bind(c.id))
		choice_box.add_child(b)
	alternate_button.hide()

func duration(minutes: int) -> String:
	return "%dm" % minutes if minutes < 60 else "%dh %02dm" % [int(minutes / 60), minutes % 60]

func choose(id: String) -> void:
	if panel.visible or confirm.visible:
		return
	if not director.act(world, id):
		status_label.text = director.last_error
		status_label.show()
		return
	page = 0
	refresh()
	scroll_down()
	autosave()

func scroll_down() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	var v_bar = body_scroll.get_v_scroll_bar()
	var target = int(v_bar.max_value)
	var tween = create_tween()
	if tween:
		tween.tween_property(body_scroll, "scroll_vertical", target, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		body_scroll.scroll_vertical = target

func next_page() -> void:
	refresh()

func autosave() -> void:
	var err: Error = world.save_world("user://autosave.json")
	if err != OK:
		status_label.text = "Could not save checkpoint: " + error_string(err)
		status_label.show()

func save_manual() -> void:
	var err: Error = world.save_world()
	menu_summary.text = "Story saved." if err == OK else "Save failed: " + error_string(err)

func resume_game() -> void:
	load_path("user://autosave.json" if FileAccess.file_exists("user://autosave.json") else "user://world.json")

func load_manual() -> void:
	load_path("user://world.json")

func load_path(path: String) -> void:
	var err: Error = world.load_world(path)
	if err != OK:
		status_label.text = "Could not load story: " + error_string(err) + ". Your current story is unchanged."
		panel.hide()
		status_label.show()
		return
	page = 0
	panel.hide()
	refresh()
	body_scroll.scroll_vertical = 0

func show_panel(mode: String) -> void:
	menu_open = mode == "menu"
	menu_controls.visible = menu_open
	panel_text.visible = not menu_open
	panel.show()
	layout_overlay()
	panel_text.scroll_to_line(0)
	inspector_picker.visible = mode == "debug"
	inspector_mode.visible = mode == "debug"
	if mode == "debug":
		panel_text.add_theme_font_override("normal_font", StoryTheme.font_mono())
		panel_text.add_theme_font_size_override("normal_font_size", 13)
	else:
		panel_text.add_theme_font_override("normal_font", StoryTheme.font_ui(400))
		panel_text.add_theme_font_size_override("normal_font_size", 15)
	match mode:
		"menu":
			panel_title.text = "One Bad Week"
			var p: Dictionary = world.player()
			menu_summary.text = "%s · %s, %d\n\nHealth %d   ·   Fatigue %d\nCash $%d   ·   Debt $%d" % [p.name, p.occupation, p.age, p.health, p.fatigue, p.finances.cash, p.finances.debt]
		"debug":
			panel_title.text = "World inspector · canonical spoilers"
			render_debug()
		"people":
			panel_title.text = "People of Briar Glen"
			var text = "The people whose lives cross yours.\n\n"
			for id in world.data.characters:
				var p: Dictionary = world.data.characters[id]
				text += p.name + "  ·  " + str(p.age) + "  ·  " + p.occupation + "\n"
				var memories: Array = world.memories_for(world.data.player, id)
				text += (memories.back().text if not memories.is_empty() else "No recorded personal memories yet.") + "\n\n"
			panel_text.text = text
		"knowledge":
			panel_title.text = "What " + world.player().name + " knows"
			var text = "Knowledge belongs to this character, not to the player outside the story.\n\n"
			for k in world.knowledge_for(world.data.player):
				text += k.fact + "\nSource: " + k.source + " · confidence " + str(roundi(k.confidence * 100)) + "%" + (" · may be false" if k.possibly_false else "") + "\n\n"
			for secret in world.player().secrets:
				text += "PRIVATE: " + secret + "\n\n"
			panel_text.text = text
		"history":
			panel_title.text = "The story so far"
			var text = ""
			for entry in world.data.story_log:
				if entry.has("action"):
					text += "CHOICE: " + entry.action + "\n\n"
				text += "DAY %d · %02d:%02d · %s\n%s\n\n────────────────────\n\n" % [int(entry.minute / 1440) + 1, int(entry.minute / 60) % 24, int(entry.minute) % 60, world.data.characters[entry.player].name, entry.text]
			panel_text.text = text

func render_debug() -> void:
	var who: String = inspector_picker.get_selected_metadata()
	var content: Variant
	match inspector_mode.selected:
		0: content = {"knowledge": world.knowledge_for(who), "memories": world.data.memories.filter(func(m): return m.character == who), "semantic_beliefs": world.data.characters[who].beliefs}
		1: content = {"character": world.data.characters[who], "intentions": world.data.intentions.filter(func(i): return i.actor == who)}
		2:
			content = {}
			for key in world.data.relationships:
				if key.begins_with(who + ":"):
					content[key] = world.data.relationships[key]
		3: content = world.data
		4: content = {"events": world.data.events, "intentions": world.data.intentions, "deaths": world.data.deaths}
		5: content = {"available_choices": director.choices(world), "last_action": world.data.flags.get("last_action", {}), "successor_reason": world.data.flags.get("successor_reason", {}), "validator": "Only currently offered stable action IDs can commit. Preconditions are checked again before simulation."}
	panel_text.text = JSON.stringify(content, "  ")

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_F3:
		if panel.visible:
			panel.hide()
		else:
			show_panel("debug")
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE:
		if panel.visible:
			panel.hide()
		else:
			show_panel("menu")
		get_viewport().set_input_as_handled()
	elif not panel.visible and not confirm.visible:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var index = event.keycode - KEY_1
			if index < live_choices.size():
				choose(live_choices[index].id)
				get_viewport().set_input_as_handled()
