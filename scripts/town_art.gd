extends Control
## Small original vector illustration drawn locally; no downloaded assets.
func _ready() -> void:
	custom_minimum_size = Vector2(0, 105)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, size.y / 145.0))
	var s = Vector2(size.x, 145)
	draw_rect(Rect2(Vector2.ZERO, s), Color("101e28"))
	for i in range(32):
		var x = fmod(i * 83.7 + 21.0, s.x)
		var y = fmod(i * 23.3 + 10.0, s.y * 0.6)
		draw_circle(Vector2(x, y), 0.9, Color(0.65, 0.73, 0.73, 0.30))
	draw_circle(Vector2(s.x * 0.81, 33), 15, Color("b5c6c5"))
	draw_circle(Vector2(s.x * 0.81 + 7, 29), 15, Color("101e28"))
	for i in range(20):
		var x = i * s.x / 19.0
		var h = 25 + (i * 17 % 29)
		draw_rect(Rect2(x, s.y - h - 10, s.x / 18, h + 10), Color("142a33"))
	# Factory, sawtooth roof, chimney, and a single illuminated entrance.
	var start = s.x * 0.09
	var width = s.x * 0.62
	draw_rect(Rect2(start, 85, width, 60), Color("09131b"))
	for i in range(4):
		var x = start + i * width / 4
		draw_colored_polygon(PackedVector2Array([Vector2(x, 85), Vector2(x + width / 4, 61), Vector2(x + width / 4, 85)]), Color("09131b"))
	draw_rect(Rect2(start + width * 0.14, 34, 15, 55), Color("09131b"))
	draw_rect(Rect2(start + width * 0.14 - 2, 32, 19, 5), Color("21333b"))
	for i in range(12):
		var x = start + 18 + i * (width - 28) / 12
		draw_rect(Rect2(x, 103, 13, 9), Color("8c7750") if i % 3 == 0 else Color("253840"))
	draw_rect(Rect2(start + width - 39, 119, 18, 26), Color("c29b5c"))
	draw_colored_polygon(PackedVector2Array([Vector2(start + width - 39, 145), Vector2(start + width - 21, 145), Vector2(start + width + 6, s.y), Vector2(start + width - 70, s.y)]), Color(0.7, 0.5, 0.25, 0.12))
	draw_line(Vector2(0, s.y - 1), Vector2(s.x, s.y - 1), Color("36434a"), 1)
