extends RefCounted
## Fictional town calendar: the accident is early Monday, after a Sunday night shift.
const DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

static func stamp(minute: int) -> String:
	return "%s %02d:%02d" % [DAYS[(minute / 1440) % 7], (minute / 60) % 24, minute % 60]

static func within(minute: int, duration: int, start: int, end: int, weekdays: bool = false) -> bool:
	if weekdays and (minute / 1440) % 7 >= 5:
		return false
	var clock = minute % 1440
	return clock >= start and clock + duration <= end

static func person_available(actor: String, minute: int, duration: int) -> bool:
	match actor:
		"cole": return minute >= 1440 + 9 * 60 and within(minute, duration, 9 * 60, 17 * 60, true)
		"erin": return within(minute, duration, 6 * 60, 22 * 60)
		"chloe":
			return within(minute, duration, 15 * 60, 21 * 60) or within(minute, duration, 7 * 60, 21 * 60) and (minute / 1440) % 7 >= 5
		"nate": return within(minute, duration, 10 * 60, 20 * 60)
		"luis": return within(minute, duration, 14 * 60, 20 * 60)
		"matt": return within(minute, duration, 11 * 60, 14 * 60) or within(minute, duration, 18 * 60, 21 * 60)
		"harold": return within(minute, duration, 8 * 60, 17 * 60, true)
		"rebecca": return within(minute, duration, 17 * 60, 21 * 60) or within(minute, duration, 10 * 60, 21 * 60) and (minute / 1440) % 7 >= 5
	return within(minute, duration, 8 * 60, 21 * 60)

static func place_open(place: String, minute: int, duration: int = 0) -> bool:
	match place:
		"station": return within(minute, duration, 9 * 60, 17 * 60, true)
		"diner": return within(minute, duration, 6 * 60, 22 * 60)
		"plant": return within(minute, duration, 6 * 60, 24 * 60) or within(minute, duration, 0, 6 * 60)
	return true # Home, roads, and emergency hospital access.

static func encounter_open(w, key: String, e: Dictionary, minute: int, duration: int = 35) -> bool:
	if int(minute / 1440) < e.day:
		return false
	if not person_available(e.actor, minute, duration) or not place_open(e.place, minute, duration):
		return false
	if e.actor == "erin" and w.flag("job_started") and (minute / 1440) % 7 < 5 and not within(minute, duration, 17 * 60, 22 * 60):
		return false
	if key == "loyalty":
		return within(minute, duration, 8 * 60, 17 * 60, true)
	if key == "harold_cornered":
		return within(minute, duration, 12 * 60, 14 * 60, true)
	return true

static func action_open(w, c: Dictionary, minute: int, catalogue: Dictionary) -> bool:
	var id: String = c.id
	var duration: int = c.minutes
	if id.begins_with("encounter_"):
		var key = id.trim_prefix("encounter_")
		return encounter_open(w, key, catalogue[key], minute + duration)
	if id.begins_with("travel_"):
		return place_open(id.trim_prefix("travel_"), minute + duration)
	var actor: String = {"family": "erin", "visit": "nate", "matt": "matt", "luis": "luis", "investigate": "cole", "correct": "cole", "submit_recording": "cole"}.get(id, "")
	if actor == "erin" and w.flag("job_started") and (minute / 1440) % 7 < 5 and not within(minute, duration, 17 * 60, 22 * 60):
		return false
	if not actor.is_empty() and not person_available(actor, minute, duration):
		return false
	match id:
		"records", "truck_diy", "truck_shop", "job": return within(minute, duration, 8 * 60, 17 * 60, true)
		"work", "overtime":
			# Night shift starts Sunday–Thursday, 21:00–23:00; it may finish next day.
			var weekday = (minute / 1440) % 7
			return weekday in [6, 0, 1, 2, 3] and minute % 1440 >= 21 * 60 and minute % 1440 <= 23 * 60
		"neighbor": return within(minute, duration, 8 * 60, 21 * 60)
		"drive": return within(minute, duration, 7 * 60, 21 * 60)
	return true

static func schedule_anchor(w) -> Dictionary:
	var minute = int(w.data.minute)
	var day = int(minute / 1440)
	var weekday = day % 7
	var clock = minute % 1440
	var hour = (minute / 60) % 24
	var min_part = minute % 60

	var period = "NIGHT"
	if hour >= 5 and hour < 9:
		period = "EARLY MORNING"
	elif hour >= 9 and hour < 12:
		period = "MORNING"
	elif hour >= 12 and hour < 17:
		period = "AFTERNOON"
	elif hour >= 17 and hour < 21:
		period = "EVENING"

	var who = w.data.player
	var p = w.player()
	var fatigue = int(p.get("fatigue", 0))
	var fatigue_tag = "Well-rested"
	if fatigue > 75:
		fatigue_tag = "Critically Exhausted"
	elif fatigue > 50:
		fatigue_tag = "Exhausted"
	elif fatigue > 25:
		fatigue_tag = "Weary"

	var anchor_title = "Downtime"
	var anchor_time = "--:--"
	var free_mins = 0
	var free_text = "Free time"
	var is_overdue = false

	if who == "daniel":
		var plant_closed = w.flag("plant_closed")
		var fired = w.flag("fired_daniel")
		var worked_today = int(w.data.flags.get("worked_" + who, -1)) == day

		if plant_closed:
			anchor_title = "Plant Suspended"
			anchor_time = "Safety Review"
			free_text = "No shifts scheduled"
		elif fired:
			anchor_title = "Removed from Rota"
			anchor_time = "Notice Given"
			free_text = "No shifts assigned"
		elif worked_today:
			anchor_title = "Shift Completed"
			anchor_time = "Resting"
			free_text = "Shift done for today"
		else:
			var shift_day = weekday in [6, 0, 1, 2, 3]
			if shift_day:
				var shift_start = 21 * 60 # 21:00
				if clock < shift_start:
					anchor_title = "Night Shift at Plant"
					anchor_time = "21:00"
					free_mins = shift_start - clock
					var h_rem = free_mins / 60
					var m_rem = free_mins % 60
					free_text = "%dh %02dm free time" % [h_rem, m_rem]
				elif clock <= 23 * 60:
					anchor_title = "Night Shift"
					anchor_time = "21:00–23:00"
					free_text = "Clock in now"
					is_overdue = false
				else:
					anchor_title = "Night Shift"
					anchor_time = "21:00 Cutoff"
					free_text = "SHIFT MISSED"
					is_overdue = true
			else:
				anchor_title = "Plant Closed (Weekend)"
				anchor_time = "Off-Shift"
				free_text = "No night shift tonight"

	return {
		"day_text": "DAY %d · %s" % [day + 1, DAYS[weekday].to_upper()],
		"clock_text": "%02d:%02d" % [hour, min_part],
		"period": period,
		"anchor_title": anchor_title,
		"anchor_time": anchor_time,
		"free_text": free_text,
		"is_overdue": is_overdue,
		"fatigue": fatigue,
		"fatigue_tag": fatigue_tag
	}

static func filter_actions(w, options: Array, catalogue: Dictionary) -> Array:
	var result: Array = []
	var blocked: Array = []
	for c in options:
		if action_open(w, c, w.data.minute, catalogue):
			result.append(c)
		else:
			blocked.append(c)
	# Only append wait_open if there are NO primary daytime activities available.
	# Never clutter the player's choices with sleep/wait when they have active leads to pursue.
	var active_tasks = result.filter(func(c): return not c.id.begins_with("travel_") and not c.id in ["rest", "bills", "bills_credit"])
	if active_tasks.is_empty() and not blocked.is_empty():
		var next_minute = -1
		for probe in range((int(w.data.minute) / 5 + 1) * 5, int(w.data.minute) + 8 * 1440 + 1, 5):
			for c in blocked:
				if action_open(w, c, probe, catalogue):
					next_minute = probe
					break
			if next_minute >= 0:
				break
		if next_minute >= 0:
			var duration = next_minute - int(w.data.minute)
			var clock = int(w.data.minute) % 1440
			var label_str = ""
			var why_str = ""
			if clock < 6 * 60 or clock >= 21 * 60 or w.player().location == "home":
				label_str = "Turn in and sleep until morning."
				why_str = "Rest in your own bed to clear your head and restore your energy for tomorrow."
			else:
				label_str = "Take a break and rest until later."
				why_str = "Conserve your energy and let the quiet hours pass."
			result.append({"id": "wait_open", "label": label_str, "minutes": duration, "why": why_str})
	return result

static func routine_location(w, actor: String, minute: int) -> String:
	var residence = "home" if actor in ["daniel", "erin", "chloe"] else "home_" + actor
	var hour = (minute / 60) % 24
	var weekday = (minute / 1440) % 7
	match actor:
		"cole": return "station" if person_available(actor, minute, 0) else residence
		"chloe": return "school" if weekday < 5 and hour >= 8 and hour < 15 else residence
		"erin": return "office" if w.flag("job_started") and weekday < 5 and hour >= 8 and hour < 17 else residence
		"nate": return "hospital"
		"luis": return "diner" if hour >= 14 and hour < 20 else ("plant" if hour >= 21 and not w.flag("plant_closed") and not w.flag("fired_luis") else residence)
		"harold": return ("diner" if w.flag("plant_closed") or hour >= 12 and hour < 14 else "plant") if weekday < 5 and hour >= 8 and hour < 17 else residence
		"matt": return "diner" if person_available(actor, minute, 0) else ("road" if hour >= 8 and hour < 18 and weekday < 5 else residence)
		"rebecca": return residence if person_available(actor, minute, 0) else "diner"
	return ""
