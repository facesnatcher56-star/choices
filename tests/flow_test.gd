extends SceneTree
const World = preload("res://scripts/world.gd")
const Director = preload("res://scripts/director.gd")
const Threads = preload("res://scripts/story_threads.gd")
const Schedule = preload("res://scripts/town_schedule.gd")
var d = Director.new()
var checks = 0
var failures = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func act(w, id: String) -> void:
	check(d.act(w, id), "Accept " + id + ": " + d.last_error)

func has(w, id: String) -> bool:
	return d.choices(w).any(func(c): return c.id == id)

func opening(first: String = "stop", pressure: String = "defer", report: String = "truth"):
	var w = World.new(4321)
	for id in [first, pressure, report, "hide"]:
		act(w, id)
	return w

func at(w, day: int, hour: int, location: String = "home") -> void:
	w.data.minute = day * 1440 + hour * 60
	w.player().location = location
	w.data.scene = "town"

func _initialize() -> void:
	var w = opening("call_luis", "record", "truth")
	check(w.data.story_log[1].text.contains("Luis calls emergency dispatch"), "Delegation honors the selected actor")
	check(w.flag("power_off") and w.flag("quick_help"), "Delegation handles power and help")
	check(w.flag("statement_careful"), "Report records the distinction between observations and assumptions")
	check(w.data.story_log[0].text.contains("vouched") and w.data.story_log[0].text.contains("Luis"), "Opening explains why the injured man and ally matter")
	check(w.data.story_log[2].text.contains("nobody from that office is here tonight"), "No instant investigator at the scene")
	check(w.knowledge_for("cole").is_empty(), "Cole cannot know an unreceived overnight report")
	check(not has(w, "submit_recording") and not has(w, "investigate"), "No early safety interview before office hours")
	check(not has(w, "visit") and not has(w, "family") and not has(w, "matt"), "Ordinary daytime visits wait for opening hours")
	check(has(w, "rest"), "Morning offers rest if still recovering")
	check(w.data.story_log[4].text.contains("streets outside are dark"), "Homecoming preserves the night conversation before sunrise")
	at(w, 0, 10)
	d.npc_turn(w, 0)
	check(w.flag("report_received") and not has(w, "investigate"), "Report receipt does not mean immediate interview")
	at(w, 1, 9)
	act(w, "submit_recording")
	check(w.flag("recording_shared") and w.knows("cole", "voice memo") and w.flag("case_open"), "Tuesday disclosure supports inquiry")

	# Weekday / weekend, opening and closing boundaries, emergency exceptions.
	for day in range(7):
		w = opening()
		at(w, day, 10)
		check(has(w, "investigate") == (day in [1, 2, 3, 4]), "Investigator hours on " + Schedule.DAYS[day])
		check(has(w, "visit"), "Daytime hospital visit on " + Schedule.DAYS[day])
		at(w, day, 3)
		w.player().health = 60
		w.player().location = "hospital"
		check(has(w, "doctor") and not has(w, "visit"), "Emergency care stays available overnight")
		at(w, day, 21, "plant")
		check(has(w, "work") == (day in [6, 0, 1, 2, 3]), "Night-shift start on " + Schedule.DAYS[day])
	w = opening()
	at(w, 1, 16)
	check(not has(w, "investigate"), "90-minute interview must fit before 17:00 closing")
	at(w, 1, 14)
	check(not has(w, "encounter_school"), "Chloe is at school before 15:00")
	at(w, 1, 16)
	check(has(w, "encounter_school"), "After-school conversation has an explicit meeting")
	act(w, "visit")
	check(w.player().location == "hospital", "Visiting Nate cannot teleport home for Chloe")
	act(w, "encounter_school")
	check(w.player().location == "home", "Explicit meeting controls travel")
	var school = d.choices(w)
	check(school.any(func(c): return c.id == "promise" and c.why.contains("word")), "School choice explains the promise at stake")
	act(w, "explain")

	# One-shot records do not remove the ability to return for a shift.
	w = opening()
	at(w, 0, 9, "plant")
	act(w, "records")
	act(w, "travel_home")
	act(w, "travel_plant")
	at(w, 0, 21, "plant")
	check(has(w, "work"), "Return to work is independent of the log visit")
	act(w, "work")
	check(not has(w, "work"), "Cannot take another shift immediately")
	at(w, 2, 21, "plant")
	act(w, "overtime")
	check(not has(w, "work") and not has(w, "overtime"), "Overtime consumes the shift")
	var before = JSON.stringify(w.data)
	check(not d.act(w, "overtime") and JSON.stringify(w.data) == before, "Repeat overtime rejected without mutation")
	at(w, 3, 21, "plant")
	w.data.flags.fired_daniel = true
	check(not has(w, "work") and not has(w, "overtime"), "Firing blocks both shifts")
	w = opening("stop", "defer", "delay")
	at(w, 1, 10)
	act(w, "investigate")
	check(w.flag("statement_completed"), "Deferred incident account can be supplied later")
	at(w, 1, 21, "plant")
	check(has(w, "work"), "Daytime interview does not arbitrarily erase a night shift")
	at(w, 2, 9)
	w.player().finances.cash = 34
	check(not has(w, "nate_rx"), "Prescription cost cannot be silently waived")
	w.player().finances.cash = 35
	act(w, "nate_rx")
	check(w.player().finances.cash == 0 and w.flag("nate_rx_paid"), "Prescription charges stated price")

	# A meaningful dilemma has distinct consequences, not just different adjectives.
	for response in ["named", "protect", "back_off"]:
		w = opening()
		at(w, 1, 14, "diner")
		act(w, "encounter_luis_statement")
		check(w.data.story_log.back().text.contains("first shift as supervisor"), "Luis scene establishes shared history")
		act(w, response)
		check(w.flag("luis_spoke") == (response == "named"), "Only signed testimony reaches Cole")
		at(w, 2, 14)
		Threads.resolve_commitments(w, 2)
		check(w.flag("fired_luis") == (response == "named"), "Witness retaliation is tied to exposure")
		check(w.data.flags.has("outcome_luis_statement"), "Luis's choice receives a follow-up")

	w = opening()
	at(w, 3, 11, "diner")
	act(w, "encounter_matt_van")
	var route = d.choices(w).filter(func(c): return c.id == "ride")[0]
	check(route.minutes > 35, "Saving Matt's cash actually costs more time")
	act(w, "ride")
	at(w, 4, 11)
	Threads.update_daily_threads(w, 4, 3)
	Threads.resolve_commitments(w, 4)
	check(w.flag("matt_contract_saved") and not w.flag("matt_van_impounded"), "Alternative delivery plan saves contract")

	for response in ["celebrate", "practical", "fear", "refuse"]:
		w = opening()
		at(w, 4, 18)
		w.data.flags.job_offered = true
		# This late-week encounter's earliest story day remains Saturday.
		at(w, 5, 18)
		act(w, "encounter_erin_offer")
		act(w, response)
		at(w, 6, 10)
		Threads.resolve_commitments(w, 6)
		check(w.flag("job_accepted"), "Erin makes her decision after " + response)
		check(w.data.flags.outcome_erin_offer.contains("With your support") if response in ["celebrate", "practical"] else w.data.flags.outcome_erin_offer.contains("unresolved"), "Follow-up remembers " + response)

	for response in ["join", "quiet", "wait", "leave"]:
		w = opening()
		at(w, 3, 14, "diner")
		w.data.flags.plant_closed = true
		act(w, "encounter_meeting")
		act(w, response)
		var cash: int = w.player().finances.cash
		at(w, 4, 14)
		Threads.resolve_commitments(w, 4)
		var expected = 112 if response in ["join", "quiet"] else 0
		check(w.player().finances.cash == cash + expected, "Paid-leave response matches decision")
		Threads.resolve_commitments(w, 5)
		check(w.player().finances.cash == cash + expected, "Leave payment happens once")

	for response in ["picket", "mediate", "walk"]:
		w = opening()
		at(w, 6, 14, "plant")
		w.data.flags.plant_closed = true
		act(w, "encounter_strike_vote")
		act(w, response)
		at(w, 7, 14)
		Threads.resolve_commitments(w, 7)
		check(w.flag("picket_held") == (response == "picket"), "Picket consequence matches " + response)
		check(w.flag("mediation_requested") == (response == "mediate"), "Mediation consequence matches " + response)

	for evidence in [false, true]:
		w = opening()
		at(w, 6, 10)
		check(not has(w, "encounter_the_reckoning"), "Review respects Sunday office closure")
		at(w, 7, 10)
		w.data.flags.case_open = evidence
		w.data.flags.evidence_shared = evidence
		act(w, "encounter_the_reckoning")
		act(w, "later")
		check(not w.flag("week_complete") and has(w, "encounter_the_reckoning"), "Review can be deferred")
		act(w, "encounter_the_reckoning")
		act(w, "listen")
		check(w.flag("week_complete"), "Review completes narrative chapter")
		check(not w.flag("case_closed") and w.flag("case_open") == evidence, "Chapter ending does not invent a concluded investigation")
		check(w.data.flags.week_summary.contains("photograph") == evidence, "Summary reflects supplied evidence")
		check(w.data.flags.week_summary.contains("still open") if evidence else w.data.flags.week_summary.contains("No formal safety findings"), "Review states the actual inquiry status")
		check(w.save_world("res://tests/flow_checkpoint.json") == OK, "Review saves")
		var loaded = World.new(99)
		check(loaded.load_world("res://tests/flow_checkpoint.json") == OK and loaded.data.flags.week_summary == w.data.flags.week_summary, "Review survives reload")

	w = opening()
	at(w, 0, 3)
	var snapshot = JSON.stringify(w.data)
	for i in 10:
		d.choices(w)
	check(snapshot == JSON.stringify(w.data), "Schedule browsing does not advance or mutate the world")
	check(not d.act(w, "investigate") and snapshot == JSON.stringify(w.data), "Closed-office action is rejected without time or state changes")
	var wait = d.choices(w).filter(func(c): return c.id == "wait_open")[0]
	act(w, "wait_open")
	check(w.data.minute == 180 + wait.minutes, "Waiting jumps to the advertised opening")
	print("FLOW TESTS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
