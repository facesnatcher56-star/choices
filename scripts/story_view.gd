extends Control
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
const StoryTheme = preload("res://scripts/story_theme.gd")
const Finances = preload("res://scripts/finances.gd")
const NarrativePacer = preload("res://scripts/narrative_pacer.gd")
const INK = StoryTheme.INK
const MUTED = StoryTheme.MUTED
const GOLD = StoryTheme.GOLD

var world = World.new()
var director = Director.new()
var pacer = NarrativePacer.new()
var continue_button: Button
var beat_indicator: Label
var page = 0
var choice_box: VBoxContainer
var narrative: RichTextLabel
var title_label: Label
var context_label: Label
var finance_label: Label
var finance_sidebar: VBoxContainer
var schedule_day_label: Label
var schedule_clock_label: Label
var schedule_period_badge: Label
var schedule_anchor_title: Label
var schedule_free_label: Label
var schedule_condition_badge: Label
var finance_cash_label: Label
var finance_debt_label: Label
var finance_credit_label: Label
var finance_bills_container: VBoxContainer
var finance_settled_container: VBoxContainer
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
var show_practical = false
var newest_story_paragraph = 0
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
	finance_sidebar.custom_minimum_size.x = 240
	finance_sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# 0. Schedule & Commitment Card
	var panel_schedule = PanelContainer.new()
	panel_schedule.add_theme_stylebox_override("panel", StoryTheme.card_style(Color("0f1519"), Color("223038"), 8))
	panel_schedule.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	finance_sidebar.add_child(panel_schedule)

	var sched_vbox = VBoxContainer.new()
	sched_vbox.add_theme_constant_override("separation", 6)
	panel_schedule.add_child(sched_vbox)

	var sched_top_hdr = HBoxContainer.new()
	sched_vbox.add_child(sched_top_hdr)
	var sched_title = label("SCHEDULE", 13, StoryTheme.GOLD, 700)
	sched_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sched_top_hdr.add_child(sched_title)

	schedule_period_badge = Label.new()
	schedule_period_badge.add_theme_font_override("font", StoryTheme.font_ui(600))
	schedule_period_badge.add_theme_font_size_override("font_size", 10)
	schedule_period_badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("1b252c"), Color("32434e"), 3))
	schedule_period_badge.add_theme_color_override("font_color", StoryTheme.ACCENT)
	sched_top_hdr.add_child(schedule_period_badge)

	var time_box = VBoxContainer.new()
	time_box.add_theme_constant_override("separation", 1)
	sched_vbox.add_child(time_box)

	schedule_day_label = label("DAY 1 · MONDAY", 12, MUTED, 600)
	time_box.add_child(schedule_day_label)

	schedule_clock_label = label("02:10 AM", 24, INK, 700)
	time_box.add_child(schedule_clock_label)

	var sched_sep1 = ColorRect.new()
	sched_sep1.custom_minimum_size = Vector2(0, 1)
	sched_sep1.color = Color("1e2a31")
	sched_vbox.add_child(sched_sep1)

	var commit_box = VBoxContainer.new()
	commit_box.add_theme_constant_override("separation", 2)
	sched_vbox.add_child(commit_box)

	var commit_hdr = label("NEXT COMMITMENT", 11, MUTED, 600)
	commit_box.add_child(commit_hdr)

	schedule_anchor_title = label("Night Shift · 21:00", 13, INK, 600)
	schedule_anchor_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	commit_box.add_child(schedule_anchor_title)

	schedule_free_label = label("18h 50m free time", 12, StoryTheme.ACCENT, 600)
	commit_box.add_child(schedule_free_label)

	var sched_sep2 = ColorRect.new()
	sched_sep2.custom_minimum_size = Vector2(0, 1)
	sched_sep2.color = Color("1e2a31")
	sched_vbox.add_child(sched_sep2)

	var cond_box = HBoxContainer.new()
	sched_vbox.add_child(cond_box)
	var cond_hdr = label("CONDITION", 11, MUTED, 600)
	cond_hdr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cond_box.add_child(cond_hdr)

	schedule_condition_badge = Label.new()
	schedule_condition_badge.add_theme_font_override("font", StoryTheme.font_ui(600))
	schedule_condition_badge.add_theme_font_size_override("font_size", 10)
	cond_box.add_child(schedule_condition_badge)

	# 1. Main Financial Overview Card
	var panel_overview = PanelContainer.new()
	panel_overview.add_theme_stylebox_override("panel", StoryTheme.card_style(Color("0f1519"), Color("223038"), 8))
	panel_overview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	finance_sidebar.add_child(panel_overview)

	var overview_vbox = VBoxContainer.new()
	overview_vbox.add_theme_constant_override("separation", 8)
	panel_overview.add_child(overview_vbox)

	var top_hdr = HBoxContainer.new()
	overview_vbox.add_child(top_hdr)
	var f_title = label("FINANCES", 13, StoryTheme.GOLD, 700)
	f_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hdr.add_child(f_title)

	var cash_box = VBoxContainer.new()
	cash_box.add_theme_constant_override("separation", 1)
	overview_vbox.add_child(cash_box)
	var cash_sub = label("AVAILABLE CASH", 12, MUTED, 600)
	cash_box.add_child(cash_sub)
	finance_cash_label = label("$420", 28, INK, 700)
	cash_box.add_child(finance_cash_label)

	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color("1e2a31")
	overview_vbox.add_child(sep1)

	var debt_box = VBoxContainer.new()
	debt_box.add_theme_constant_override("separation", 2)
	overview_vbox.add_child(debt_box)
	var debt_hdr = HBoxContainer.new()
	debt_box.add_child(debt_hdr)
	var debt_sub = label("TOTAL DEBT", 12, MUTED, 600)
	debt_sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	debt_hdr.add_child(debt_sub)
	finance_credit_label = label("Limit $2,500", 11, Color("6c7d84"), 400)
	debt_hdr.add_child(finance_credit_label)

	finance_debt_label = label("$0", 22, StoryTheme.MUTED, 700)
	debt_box.add_child(finance_debt_label)

	var sep2 = ColorRect.new()
	sep2.custom_minimum_size = Vector2(0, 1)
	sep2.color = Color("1e2a31")
	overview_vbox.add_child(sep2)

	var rates_box = VBoxContainer.new()
	rates_box.add_theme_constant_override("separation", 3)
	overview_vbox.add_child(rates_box)

	var daily_row = HBoxContainer.new()
	rates_box.add_child(daily_row)
	var daily_tag = label("Daily Living", 11, MUTED, 500)
	daily_tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	daily_row.add_child(daily_tag)
	var daily_val = label("-$24 / day", 11, Color("94a3b8"), 600)
	daily_row.add_child(daily_val)

	var shift_row = HBoxContainer.new()
	rates_box.add_child(shift_row)
	var shift_tag = label("Shift Wage", 11, MUTED, 500)
	shift_tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shift_row.add_child(shift_tag)
	var shift_val = label("+$112 / shift", 11, Color("94a3b8"), 600)
	shift_row.add_child(shift_val)

	# 2. Upcoming Obligations Header
	var bills_hdr_box = HBoxContainer.new()
	finance_sidebar.add_child(bills_hdr_box)
	var bills_title = label("UPCOMING BILLS", 13, StoryTheme.GOLD, 700)
	bills_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bills_hdr_box.add_child(bills_title)

	var bills_scroll = ScrollContainer.new()
	bills_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bills_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bills_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	finance_sidebar.add_child(bills_scroll)

	var bills_outer = VBoxContainer.new()
	bills_outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bills_outer.add_theme_constant_override("separation", 10)
	bills_scroll.add_child(bills_outer)

	finance_bills_container = VBoxContainer.new()
	finance_bills_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	finance_bills_container.add_theme_constant_override("separation", 8)
	bills_outer.add_child(finance_bills_container)

	finance_settled_container = VBoxContainer.new()
	finance_settled_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	finance_settled_container.add_theme_constant_override("separation", 4)
	bills_outer.add_child(finance_settled_container)

func update_finance_sidebar() -> void:
	finance_sidebar.visible = world.data.scene != "moon"
	if world.data.scene == "moon":
		return
	var sched = preload("res://scripts/town_schedule.gd").schedule_anchor(world)
	if schedule_day_label:
		schedule_day_label.text = str(sched.get("day_text", "DAY 1 · MONDAY"))
	if schedule_clock_label:
		schedule_clock_label.text = str(sched.get("clock_text", "02:10"))
	if schedule_period_badge:
		schedule_period_badge.text = " " + str(sched.get("period", "NIGHT")) + " "
	if schedule_anchor_title:
		var atime = str(sched.get("anchor_time", ""))
		schedule_anchor_title.text = str(sched.get("anchor_title", "")) + (" · " + atime if atime != "--:--" else "")
	if schedule_free_label:
		schedule_free_label.text = str(sched.get("free_text", ""))
		if sched.get("is_overdue", false):
			schedule_free_label.add_theme_color_override("font_color", StoryTheme.WARN)
		else:
			schedule_free_label.add_theme_color_override("font_color", StoryTheme.ACCENT)
	if schedule_condition_badge:
		var ftag = str(sched.get("fatigue_tag", "Well-rested"))
		var fatigue = int(sched.get("fatigue", 0))
		schedule_condition_badge.text = " " + ftag.to_upper() + " "
		if fatigue > 75:
			schedule_condition_badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("3b1816"), StoryTheme.WARN, 3))
			schedule_condition_badge.add_theme_color_override("font_color", StoryTheme.WARN)
		elif fatigue > 50:
			schedule_condition_badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("382914"), StoryTheme.GOLD, 3))
			schedule_condition_badge.add_theme_color_override("font_color", StoryTheme.GOLD)
		else:
			schedule_condition_badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("16241d"), Color("388e3c"), 3))
			schedule_condition_badge.add_theme_color_override("font_color", Color("81c784"))

	var p = world.player()
	var cash = int(p.finances.get("cash", 0))
	var debt = int(p.finances.get("debt", 0))
	var limit = Finances.credit_limit(world)
	finance_cash_label.text = "$%d" % cash
	finance_debt_label.text = "$%d" % debt
	if finance_credit_label:
		finance_credit_label.text = "Limit $%d" % limit
	if debt > 0:
		finance_debt_label.add_theme_color_override("font_color", StoryTheme.WARN)
	else:
		finance_debt_label.add_theme_color_override("font_color", MUTED)

	for c in finance_bills_container.get_children():
		c.queue_free()
	for c in finance_settled_container.get_children():
		c.queue_free()

	var bills = Finances.ensure_bills(world)
	var current_day = int(world.data.minute / 1440) + 1
	var has_pending = false
	var has_settled = false

	for id in bills:
		var b = bills[id]
		var status = b.get("status", "unpaid")
		var amount = int(b.get("amount", 0))
		var due_day = int(b.get("due_day", 1))

		if status in ["unpaid", "overdue", "pending"]:
			has_pending = true
			var is_overdue = (due_day < current_day or status == "overdue")
			var is_today = (due_day == current_day and not is_overdue)

			var card = PanelContainer.new()
			var border_color = StoryTheme.WARN if is_overdue else (StoryTheme.GOLD if is_today else Color("1e2a31"))
			card.add_theme_stylebox_override("panel", StoryTheme.card_style(Color("0e1418"), border_color, 6))
			card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			var card_vbox = VBoxContainer.new()
			card_vbox.add_theme_constant_override("separation", 5)
			card.add_child(card_vbox)

			var title_lbl = Label.new()
			title_lbl.text = b.get("title", id.capitalize())
			title_lbl.add_theme_font_override("font", StoryTheme.font_ui(600))
			title_lbl.add_theme_font_size_override("font_size", 14)
			title_lbl.add_theme_color_override("font_color", INK if not is_overdue else StoryTheme.WARN)
			title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			card_vbox.add_child(title_lbl)

			var sub_row = HBoxContainer.new()
			sub_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			card_vbox.add_child(sub_row)

			var badge = Label.new()
			badge.add_theme_font_override("font", StoryTheme.font_ui(600))
			badge.add_theme_font_size_override("font_size", 11)
			if is_overdue:
				badge.text = " OVERDUE "
				badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("3b1816"), StoryTheme.WARN, 3))
				badge.add_theme_color_override("font_color", StoryTheme.WARN)
			elif is_today:
				badge.text = " DUE TODAY "
				badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("2e2413"), StoryTheme.GOLD, 3))
				badge.add_theme_color_override("font_color", StoryTheme.GOLD)
			else:
				badge.text = " DUE DAY %d " % due_day
				badge.add_theme_stylebox_override("normal", StoryTheme.pill_style(Color("161f25"), Color("2d3d47"), 3))
				badge.add_theme_color_override("font_color", MUTED)
			badge.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			sub_row.add_child(badge)

			var space = Control.new()
			space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			sub_row.add_child(space)

			var amt_lbl = Label.new()
			amt_lbl.text = "$%d" % amount
			amt_lbl.add_theme_font_override("font", StoryTheme.font_ui(700))
			amt_lbl.add_theme_font_size_override("font_size", 15)
			amt_lbl.add_theme_color_override("font_color", StoryTheme.WARN if is_overdue else (StoryTheme.GOLD if is_today else INK))
			sub_row.add_child(amt_lbl)

			finance_bills_container.add_child(card)

		elif status == "paid":
			has_settled = true
			var settled_row = HBoxContainer.new()
			settled_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			var check_lbl = Label.new()
			check_lbl.text = "✓ " + str(b.get("title", id.capitalize()))
			check_lbl.add_theme_font_override("font", StoryTheme.font_ui(500))
			check_lbl.add_theme_font_size_override("font_size", 12)
			check_lbl.add_theme_color_override("font_color", Color("688a64"))
			check_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			check_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			settled_row.add_child(check_lbl)

			var paid_val = Label.new()
			paid_val.text = "Paid"
			paid_val.add_theme_font_override("font", StoryTheme.font_ui(500))
			paid_val.add_theme_font_size_override("font_size", 11)
			paid_val.add_theme_color_override("font_color", Color("688a64"))
			settled_row.add_child(paid_val)

			finance_settled_container.add_child(settled_row)

	if not has_pending:
		var empty_lbl = label("No active bills pending.", 12, MUTED)
		finance_bills_container.add_child(empty_lbl)

	if has_settled:
		var settled_title = label("SETTLED OBLIGATIONS", 11, Color("5b7458"), 700)
		finance_settled_container.add_child(settled_title)
		finance_settled_container.move_child(settled_title, 0)

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
	var brand = label("PLEASE DO NOT FEED THE MOON", 16, StoryTheme.GOLD, 700)
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(brand)
	finance_label = label("", 16, MUTED)
	finance_label.hide()
	top_bar.add_child(finance_label)
	var menu_btn = quiet_button("Menu", show_panel.bind("menu"))
	menu_btn.add_theme_font_override("font", StoryTheme.font_ui(600))
	top_bar.add_child(menu_btn)

	context_label = label("", 18, MUTED)
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
	body_margin.add_theme_constant_override("margin_top", 20)
	body_margin.add_theme_constant_override("margin_bottom", 48)
	body_margin.add_theme_constant_override("margin_left", 8)
	body_margin.add_theme_constant_override("margin_right", 16)
	body_scroll.add_child(body_margin)

	var body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 22)
	body_margin.add_child(body)

	title_label = label("", 34, INK)
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
	narrative.add_theme_font_size_override("normal_font_size", 24)
	narrative.add_theme_font_size_override("bold_font_size", 24)
	narrative.add_theme_font_size_override("italics_font_size", 24)
	narrative.add_theme_font_size_override("bold_italics_font_size", 24)
	narrative.add_theme_constant_override("line_separation", 14)
	narrative.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and continue_button.visible:
			advance_narrative_beat())
	body.add_child(narrative)

	var breath = Control.new()
	breath.custom_minimum_size.y = 8
	body.add_child(breath)

	beat_indicator = Label.new()
	beat_indicator.add_theme_font_override("font", StoryTheme.font_ui(600))
	beat_indicator.add_theme_font_size_override("font_size", 12)
	beat_indicator.add_theme_color_override("font_color", StoryTheme.GOLD)
	beat_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	beat_indicator.hide()
	body.add_child(beat_indicator)

	continue_button = Button.new()
	continue_button.text = "Continue  ▾"
	continue_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	continue_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	continue_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	continue_button.add_theme_font_override("font", StoryTheme.font_ui(600))
	continue_button.add_theme_font_size_override("font_size", 22)
	continue_button.add_theme_color_override("font_color", INK)
	continue_button.add_theme_color_override("font_hover_color", Color("fff7e6"))
	continue_button.add_theme_color_override("font_focus_color", Color("fff7e6"))
	continue_button.add_theme_stylebox_override("normal", StoryTheme.choice_style(Color("131e24"), StoryTheme.GOLD))
	continue_button.add_theme_stylebox_override("hover", StoryTheme.choice_style(Color("1a2b34"), StoryTheme.GOLD))
	continue_button.add_theme_stylebox_override("pressed", StoryTheme.choice_style(Color("223642"), StoryTheme.GOLD))
	continue_button.add_theme_stylebox_override("focus", StoryTheme.choice_style(Color("131e24"), StoryTheme.GOLD))
	continue_button.pressed.connect(advance_narrative_beat)
	continue_button.hide()
	body.add_child(continue_button)

	choice_box = VBoxContainer.new()
	choice_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_box.add_theme_constant_override("separation", 8)
	body.add_child(choice_box)

	alternate_button = quiet_button("Other approaches", next_page)
	alternate_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	alternate_button.add_theme_font_size_override("font_size", 18)
	alternate_button.hide()
	body.add_child(alternate_button)

	status_label = label("", 16, MUTED)
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
	var total_content = 1180
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
	context_label.text = "%s  ·  %s  ·  Day %d, %s" % [p.name, world.data.locations[p.location], int(world.data.minute / 1440) + 1, preload("res://scripts/town_schedule.gd").stamp(world.data.minute)]
	finance_label.text = "" if world.data.scene == "moon" else Finances.status_line(world)
	update_finance_sidebar()
	status_label.hide()
	title_label.text = {"accident": "Before the sirens", "pressure": "A consistent story", "statement": "For the record", "homecoming": "The kitchen light", "danger": "A moment to step back", "town": "Life goes on"}.get(world.data.scene, "The story continues")
	if world.data.scene == "encounter":
		title_label.text = director.encounters.catalogue()[world.data.flags.encounter].title
	if world.data.scene == "moon":
		title_label.text = preload("res://scripts/moon_data.gd").NODES[world.data.flags.moon_node].title
		context_label.text = "Alex Vale  ·  The Hotel Nobody"

	# Paced narrative delivery (2-3 sentences at a time)
	var last_entry: Dictionary = world.data.story_log.back() if not world.data.story_log.is_empty() else {}
	var action_header = ""
	if last_entry.has("action") and not str(last_entry.action).is_empty():
		action_header = "[color=" + StoryTheme.GOLD_COLOR + "]› [i]" + str(last_entry.action) + "[/i][/color]"
	var raw_text: String = str(last_entry.get("text", ""))
	pacer.setup(raw_text, action_header)

	for c in choice_box.get_children():
		choice_box.remove_child(c)
		c.queue_free()

	var all_choices = director.choices(world)
	var has_practical = all_choices.any(func(c): return c.get("secondary", false))
	live_choices = all_choices if show_practical else all_choices.filter(func(c): return not c.get("secondary", false))

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
		b.add_theme_font_size_override("font_size", 22)
		b.add_theme_color_override("font_color", INK)
		b.add_theme_color_override("font_hover_color", Color("fff7e6"))
		b.add_theme_color_override("font_focus_color", Color("fff7e6"))
		b.add_theme_stylebox_override("normal", StoryTheme.choice_style(Color("0f181e"), Color("1e2c34")))
		b.add_theme_stylebox_override("hover", StoryTheme.choice_style(Color("162630"), StoryTheme.GOLD))
		b.add_theme_stylebox_override("pressed", StoryTheme.choice_style(Color("1c303c"), StoryTheme.GOLD))
		b.add_theme_stylebox_override("focus", StoryTheme.choice_style(Color("0f181e"), StoryTheme.GOLD))
		b.pressed.connect(choose.bind(c.id))
		choice_box.add_child(b)
	alternate_button.visible = has_practical
	alternate_button.text = "Hide secondary matters" if show_practical else "Secondary matters"

	render_current_beat()

func render_current_beat() -> void:
	var beat_text = pacer.current_beat()
	narrative.text = StoryTheme.format_narrative(beat_text)

	if not pacer.is_finished():
		continue_button.show()
		beat_indicator.text = "BEAT %d OF %d  ·  [SPACE / ENTER] TO CONTINUE" % [pacer.beat_number(), pacer.total_beats()]
		beat_indicator.show()
		choice_box.hide()
		alternate_button.hide()
	else:
		continue_button.hide()
		beat_indicator.hide()
		choice_box.show()
		var has_practical = director.choices(world).any(func(c): return c.get("secondary", false))
		alternate_button.visible = has_practical

func advance_narrative_beat() -> void:
	if pacer.advance():
		render_current_beat()
		body_scroll.scroll_vertical = 0
	else:
		render_current_beat()

func finish_beats() -> void:
	pacer.finish_all()
	render_current_beat()

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
	show_practical = false
	refresh()
	scroll_down()
	autosave()

func scroll_down() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	var v_bar = body_scroll.get_v_scroll_bar()
	var target = int(narrative.position.y + narrative.get_paragraph_offset(newest_story_paragraph))
	target = clampi(target, 0, maxi(0, int(v_bar.max_value - v_bar.page)))
	var tween = create_tween()
	if tween:
		tween.tween_property(body_scroll, "scroll_vertical", target, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		body_scroll.scroll_vertical = target

func next_page() -> void:
	show_practical = not show_practical
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
		panel_text.add_theme_font_size_override("normal_font_size", 16)
	else:
		panel_text.add_theme_font_override("normal_font", StoryTheme.font_ui(400))
		panel_text.add_theme_font_size_override("normal_font_size", 19)
	match mode:
		"menu":
			panel_title.text = "Please Do Not Feed the Moon"
			var p: Dictionary = world.player()
			menu_summary.text = "%s · %s, %d\n\nHealth %d   ·   Fatigue %d\nCash $%d   ·   Debt $%d" % [p.name, p.occupation, p.age, p.health, p.fatigue, p.finances.cash, p.finances.debt]
			if world.data.scene == "moon":
				menu_summary.text = "Alex Vale · The Hotel Nobody\n" + str(preload("res://scripts/moon_data.gd").NODES[world.data.flags.moon_node].title)
		"debug":
			panel_title.text = "World inspector · canonical spoilers"
			render_debug()
		"people":
			panel_title.text = "People of the hotel" if world.data.scene == "moon" else "People of Briar Glen"
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
		if continue_button.visible and (event.keycode == KEY_SPACE or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			advance_narrative_beat()
			get_viewport().set_input_as_handled()
		elif choice_box.visible and event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var index = event.keycode - KEY_1
			if index < live_choices.size():
				choose(live_choices[index].id)
				get_viewport().set_input_as_handled()
