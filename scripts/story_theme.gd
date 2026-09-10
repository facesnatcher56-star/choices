extends RefCounted
## Provides the visual theme and typography styles for the reading interface.

const INK = Color("e3e6df")
const PROSE = Color("cad2c5")
const MUTED = Color("8b9c9f")
const GOLD = Color("d4ad72")
const WARN = Color("d97768")

const DIALOGUE_COLOR = "#ffe082"
const ACCENT_COLOR = "#7eb8da"
const GOLD_COLOR = "#d4ad72"
const WARN_COLOR = "#d97768"

## Formats raw story prose with color-coded dialogue and scene transitions for easy reading
static func format_narrative(text: String) -> String:
	var result = text
	# 1. Colorize spoken dialogue in single curly quotes ‘...’, supporting contractions like don’t, wasn’t, Nate’s
	var re_single = RegEx.new()
	re_single.compile("‘((?:[^’\n]|’(?=[a-zA-Z]))+)’")
	result = re_single.sub(result, "[color=" + DIALOGUE_COLOR + "]‘$1’[/color]", true)

	# 2. Colorize spoken dialogue in double curly quotes “...”
	var re_double = RegEx.new()
	re_double.compile("“([^”\n]+)”")
	result = re_double.sub(result, "[color=" + DIALOGUE_COLOR + "]“$1”[/color]", true)

	# 3. Colorize spoken dialogue in standard double quotes "..."
	var re_std_double = RegEx.new()
	re_std_double.compile("\"([^\"\n]+)\"")
	result = re_std_double.sub(result, "[color=" + DIALOGUE_COLOR + "]\"$1\"[/color]", true)

	# 4. Highlight location and scene time headings like "LATER · Mercer house"
	var re_trans = RegEx.new()
	re_trans.compile("(?m)^(LATER[^\n]*)")
	result = re_trans.sub(result, "[color=" + ACCENT_COLOR + "][b]$1[/b][/color]", true)

	return result

static func font_ui(weight: int = 400) -> SystemFont:
	var f = SystemFont.new()
	f.font_names = PackedStringArray(["Segoe UI Variable Text", "Segoe UI", "Inter", "Calibri", "Helvetica Neue", "Arial", "sans-serif"])
	f.font_weight = weight
	f.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_AUTO
	f.antialiasing = TextServer.FONT_ANTIALIASING_LCD
	f.hinting = TextServer.HINTING_LIGHT
	return f

static func font_serif(weight: int = 400, italic: bool = false) -> SystemFont:
	var f = SystemFont.new()
	f.font_names = PackedStringArray(["Georgia", "Charter", "Palatino Linotype", "Constantia", "Cambria", "Times New Roman", "serif"])
	f.font_weight = weight
	if italic:
		f.font_italic = true
	f.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_AUTO
	f.antialiasing = TextServer.FONT_ANTIALIASING_LCD
	f.hinting = TextServer.HINTING_LIGHT
	return f

static func font_mono() -> SystemFont:
	var f = SystemFont.new()
	f.font_names = PackedStringArray(["Cascadia Code", "Consolas", "Courier New", "monospace"])
	f.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_AUTO
	f.antialiasing = TextServer.FONT_ANTIALIASING_LCD
	f.hinting = TextServer.HINTING_LIGHT
	return f

static func box_style(color: Color, border: Color = Color.TRANSPARENT, radius: int = 8) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 16
	s.content_margin_right = 16
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s

static func create_fade_texture(from_top: bool) -> GradientTexture2D:
	var g = Gradient.new()
	if from_top:
		g.colors = PackedColorArray([Color(0.035, 0.05, 0.065, 1.0), Color(0.035, 0.05, 0.065, 0.0)])
	else:
		g.colors = PackedColorArray([Color(0.035, 0.05, 0.065, 0.0), Color(0.035, 0.05, 0.065, 1.0)])
	var tex = GradientTexture2D.new()
	tex.gradient = g
	tex.fill_from = Vector2(0, 0)
	tex.fill_to = Vector2(0, 1)
	tex.width = 16
	tex.height = 32
	return tex

static func choice_style(color: Color, border: Color = Color.TRANSPARENT, radius: int = 6) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = border
	s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 9
	s.content_margin_bottom = 9
	return s

static func create() -> Theme:
	var t = Theme.new()
	var ui_font = font_ui(400)
	var ui_bold = font_ui(700)
	t.default_font = ui_font
	t.default_font_size = 20

	t.set_font("font", "Label", ui_font)
	t.set_color("font_color", "Label", INK)

	t.set_font("normal_font", "RichTextLabel", font_serif(400))
	t.set_font("bold_font", "RichTextLabel", font_serif(700))
	t.set_font("italics_font", "RichTextLabel", font_serif(400, true))
	t.set_font("bold_italics_font", "RichTextLabel", font_serif(700, true))
	t.set_color("default_color", "RichTextLabel", PROSE)

	t.set_font("font", "Button", ui_font)
	t.set_color("font_color", "Button", INK)
	t.set_color("font_hover_color", "Button", Color("fff4d9"))
	t.set_color("font_focus_color", "Button", Color("fff4d9"))
	t.set_stylebox("normal", "Button", box_style(Color("15222b"), Color("30404a")))
	t.set_stylebox("hover", "Button", box_style(Color("23353c"), GOLD))
	t.set_stylebox("pressed", "Button", box_style(Color("30434a"), GOLD))
	t.set_stylebox("focus", "Button", box_style(Color(0, 0, 0, 0), GOLD))

	t.set_stylebox("panel", "PopupMenu", box_style(Color("15222b"), MUTED))
	t.set_color("font_color", "PopupMenu", INK)
	t.set_font("font", "PopupMenu", ui_font)

	t.set_stylebox("normal", "OptionButton", box_style(Color("23353c")))
	t.set_color("font_color", "OptionButton", INK)
	t.set_font("font", "OptionButton", ui_font)

	t.set_constant("separation", "VBoxContainer", 12)
	t.set_constant("separation", "HBoxContainer", 12)
	return t
