extends RefCounted
## Offline action catalogue → validation → simulation → NPC turns → narration.
## Every option has a stable ID and an inspectable precondition. No network code.

var last_error = ""
var encounters = preload("res://scripts/encounters.gd").new()
var scenes = preload("res://scripts/scene_narratives.gd").new()
var npc_sim = preload("res://scripts/npc_sim.gd").new()
const RumorNetwork = preload("res://scripts/rumor_network.gd")
const StoryThreads = preload("res://scripts/story_threads.gd")
const Finances = preload("res://scripts/finances.gd")

func option(id: String, label: String, minutes: int, why: String) -> Dictionary:
	return {"id": id, "label": label, "minutes": minutes, "why": why}

func choices(w) -> Array:
	var a: Array = []
	match w.data.scene:
		"ended":
			return []
		"encounter":
			return encounters.choices(w)
		"accident":
			a = [option("ambulance", "Call an ambulance. Stay with Nate.", 3, "Nate is alive and needs immediate help."), option("stop", "Hit the emergency stop first.", 4, "The machine is running and its stop is accessible."), option("photo", "Photograph the wire before anyone touches it.", 7, "Daniel has a working phone and can see the guard."), option("ask_harold", "Ask Harold what he means.", 9, "Harold is present; responsibility remains unknown."), option("call_luis", "Ask Luis to call while you clear the floor.", 3, "Luis is conscious and present."), option("touch_guard", "Remove the wire, then call for help.", 8, "This changes physical evidence; the mechanism may still move.")]
		"pressure":
			a = [option("refuse", "Tell Harold you will give an honest statement.", 12, "Harold has asked for a consistent account."), option("agree", "Agree to say the guard looked normal.", 12, "You can protect your job by making an unverified claim."), option("why", "Ask why he needs the story settled tonight.", 15, "His request does not establish his responsibility."), option("defer", "Say you need time to think.", 10, "You have not given investigators a statement yet."), option("witness", "Bring Luis into the conversation.", 15, "Luis is nearby; this creates another witness."), option("record", "Open a voice memo and ask him to repeat it.", 15, "Your phone is working; Harold can see you recording.")]
		"statement":
			a = [option("truth", "Describe exactly what you found.", 30, "You observed the bypass but not who installed it."), option("lie", "Say the guard was normal when you checked.", 30, "This is a claim, not established canonical truth."), option("unsure", "Separate what you saw from what you assume.", 40, "Cole can record uncertainty without assigning blame."), option("delay", "Ask to give a fuller statement tomorrow.", 20, "The investigation continues without a complete statement."), option("blame", "Suggest Nate must have bypassed it.", 30, "An unsupported allegation; you did not witness this."), option("evidence", "Offer the photograph and explain when it was taken.", 35, "Only available if you actually took a photograph.")]
			if not w.flag("photo"):
				a = a.filter(func(c): return c.id != "evidence")
		"homecoming":
			a = [option("tell", "Tell Erin about the accident and your statement.", 40, "Erin is present; disclosure gives her new knowledge."), option("partial", "Tell her Nate was hurt. Leave out the rest.", 20, "She will know only what you tell her."), option("hide", "Say it was just a difficult shift.", 10, "Erin has no direct knowledge of the factory."), option("listen", "Ask what happened at home while you were away.", 35, "Her private life continues independently of yours."), option("chloe", "Wake Chloe and explain why you are late.", 25, "An explicit conversation can inform Chloe."), option("sleep", "Admit you cannot talk yet. Get some sleep.", 360, "Rest reduces fatigue but leaves questions unanswered.")]
		"danger":
			a = [option("safe", "Step back and call for help.", 40, "The visible hazard can be avoided."), option("help", "Wait for someone with the right equipment.", 80, "Waiting costs time but avoids direct exposure."), option("risk", "Go ahead despite the danger.", 25, "A warned, probabilistic hazard. Injury can be fatal."), option("leave", "Leave. This is not worth it.", 30, "You can walk away from the hazard.")]
		_:
			a = town_choices(w)
	return a

func town_choices(w) -> Array:
	var a: Array = []
	var day = int(w.data.minute / 1440)
	var who: String = w.data.player
	var loc: String = w.player().location

	var talked_family = w.flag("talked_family_day_" + str(day))
	var visited_nate = w.flag("visited_nate_day_" + str(day))
	var interviewed_cole = w.flag("interviewed_cole_day_" + str(day))
	var talked_matt = w.flag("talked_matt_day_" + str(day))
	var talked_luis = w.flag("talked_luis_day_" + str(day))
	var talked_neighbor = w.flag("talked_neighbor_day_" + str(day))
	var saw_doctor = w.flag("saw_doctor_day_" + str(day))
	var drove_today = w.flag("drove_today_" + str(day))
	var checked_records = w.flag("records_" + who)
	var corrected_lie = w.flag("corrected")
	var reviewed_job = w.flag("job_accepted") or w.flag("job_reviewed")
	var worked_today = int(w.data.flags.get("worked_" + who, -1)) == day

	match loc:
		"home":
			# Rest is always available at home
			a.append(option("rest", "Try to wash up and get some sleep.", 480, "Rest restores health and reduces fatigue in your own bed."))
			if w.data.characters.erin.alive and who != "erin" and not talked_family:
				a.append(option("family", "Stay at the kitchen table and talk with Erin.", 90, "Erin is carrying the weight of the household and Nate’s accident."))
			var bills = Finances.ensure_bills(w)
			if bills.has("heating") and bills.heating.status in ["unpaid", "overdue"] and int(w.data.flags.get("paid_bills_day", -1)) != day:
				if w.player().finances.cash >= 80:
					a.append(option("bills", "Pay the $80 overdue heating bill on the counter.", 20, "Clears the immediate utility notice using cash from your wallet."))
				else:
					a.append(option("bills", "Pay remaining cash ($%d) toward the heating bill." % w.player().finances.cash, 20, "Pays what cash you have; defers the remainder to buy time with the utility."))
				if Finances.available_credit(w) >= 80:
					a.append(option("bills_credit", "Charge the $80 heating bill to the credit card.", 15, "Settles the utility bill immediately; card debt increases to $%d." % (Finances.total_debt(w) + 80)))
			if day >= 2 and not w.flag("truck_fixed") and who == "daniel":
				a.append(option("truck_diy", "Pull a salvage alternator at the scrapyard and install it yourself.", 180, "Saves cash (only $35 parts). Trades 3 hours of daylight and leaves you exhausted."))
				a.append(option("truck_shop", "Pay Jim at the garage $140 to replace the truck alternator.", 60, "Professional repair; costs $140 in cash or credit, but saves your afternoon."))
			if who == "erin" and not reviewed_job:
				a.append(option("job", "Review the out-of-town job application.", 150, "Erin’s private goal to regain financial stability."))
			# Venturing out: focused, realistic plot destinations
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Drive to St. Anne’s Hospital to check if Nate survived.", 90, "Nate is in trauma recovery; a visit lets you see him firsthand."))
			if w.data.characters.cole.alive and who != "cole" and not interviewed_cole:
				if day >= 1 or w.data.minute >= 600 or w.flag("delayed_statement") or (w.knows("daniel", "maintenance log") and not w.flag("log_shared")):
					var work_conflict = not worked_today and not w.flag("plant_closed")
					var why_text = "Cole requested your supervisor deposition on Line 4." + (" Missing today's morning shift forfeits $112 in wages." if work_conflict else "")
					a.append(option("investigate", "Drive to the station for Detective Cole’s follow-up interview.", 90, why_text))
			if w.flag("lied") and not corrected_lie and who == "daniel":
				a.append(option("correct", "Take Cole’s card and drive to the precinct to recant your lie.", 100, "Erin urged you to retract the false statement before official charges are filed."))
			if w.data.characters.matt.alive and who != "matt" and not talked_matt and (day >= 1 or w.flag("matt_called")):
				a.append(option("matt", "Drive down to the Juniper Diner to check on your brother Matt.", 75, "Matt's delivery van broke down on route 9; he called looking for help."))
			if not checked_records and w.player().age >= 18 and day >= 1:
				a.append(option("records", "Drive to Mercer Works to check the maintenance log.", 90, "Inspect the physical records while the office is quiet."))
			if day >= 1 and not drove_today:
				a.append(option("drive", "Take the truck out on the county road to clear your head.", 75, "Fatigue makes driving more dangerous."))

		"diner":
			# Local actions inside the diner
			if w.data.characters.matt.alive and who != "matt" and not talked_matt:
				a.append(option("matt", "Sit down with Matt in his booth.", 75, "Your brother’s problems have not stopped for the investigation."))
			if w.data.characters.luis.alive and who != "luis" and not talked_luis:
				a.append(option("luis", "Buy Luis a coffee and hear him out.", 75, "Luis may share what he knows if he trusts you."))
			if not talked_neighbor:
				a.append(option("neighbor", "Talk with the regular sitting at the counter.", 60, "A local can share an experience, not omniscient town gossip."))
			# Leaving the diner
			a.append(option("rest", "Leave the diner and head home to sleep.", 480, "Rest restores health and reduces fatigue."))
			if w.data.characters.erin.alive and who != "erin" and not talked_family:
				a.append(option("family", "Head home to check in on Erin.", 90, "Return to the house to talk with Erin."))
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Drive over to St. Anne’s to see Nate.", 90, "Head to the hospital."))
			if w.data.characters.cole.alive and who != "cole" and not interviewed_cole:
				a.append(option("investigate", "Drive over to the station to meet Detective Cole.", 90, "Head to the station."))

		"plant":
			# Local actions on plant grounds
			if not w.flag("plant_closed") and not w.flag("fired_" + who) and w.player().age >= 18 and not worked_today:
				a.append(option("work", "Pick up a shift on the factory floor.", 420, "Earns $112 wages. Requires 7 hours; fatigue and plant conditions matter."))
			if not checked_records and w.player().age >= 18:
				a.append(option("records", "Check the supervisor's maintenance log.", 90, "The plant log exists, but its condition may have changed."))
			if day >= 2 and w.player().age >= 18 and not w.flag("plant_closed") and not worked_today:
				a.append(option("overtime", "Take Harold's double shift on the stamping line.", 480, "Pays $160 in cash wages, but adds the exhausted condition and keeps you away from home all night."))
			# Leaving the plant
			a.append(option("rest", "Punch out and head home to sleep.", 480, "Leave the factory floor and sleep."))
			if w.data.characters.erin.alive and who != "erin" and not talked_family:
				a.append(option("family", "Head home to Erin.", 90, "Leave the plant and return home."))
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Drive over to St. Anne’s to check on Nate.", 90, "Check on Nate in recovery."))
			if w.data.characters.matt.alive and who != "matt" and not talked_matt:
				a.append(option("matt", "Drive down to the Juniper Diner.", 75, "Head into town to meet Matt."))

		"hospital":
			# Local actions at the hospital
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Visit Nate in his room.", 90, "Nate is propped up in his hospital bed."))
			if w.player().health < 90 and not saw_doctor:
				a.append(option("doctor", "Have a doctor look at your injuries.", 120, "Medical attention improves health and prevents neglect."))
			# Leaving the hospital
			a.append(option("rest", "Leave the hospital and head home to sleep.", 480, "Head back to the house to get rest."))
			if w.data.characters.erin.alive and who != "erin" and not talked_family:
				a.append(option("family", "Head home to Erin.", 90, "Return home to Erin."))
			if w.data.characters.cole.alive and who != "cole" and not interviewed_cole:
				a.append(option("investigate", "Drive to the station to meet Detective Cole.", 90, "Head to the station."))
			if w.data.characters.matt.alive and who != "matt" and not talked_matt:
				a.append(option("matt", "Head down to the Juniper Diner.", 75, "Drive to the diner."))

		"station":
			# Local actions at the police station
			if w.data.characters.cole.alive and who != "cole" and not interviewed_cole:
				a.append(option("investigate", "Speak with Detective Cole about the investigation.", 90, "Discuss the investigation on formal ground."))
			if not corrected_lie and w.flag("lied") and who == "daniel":
				a.append(option("correct", "Formally correct your previous statement.", 100, "Your earlier false statement remains in the event history."))
			# Leaving the station
			a.append(option("rest", "Leave the station and head home to sleep.", 480, "Head back home to get rest."))
			if w.data.characters.erin.alive and who != "erin" and not talked_family:
				a.append(option("family", "Head home to Erin.", 90, "Return home to Erin."))
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Drive to St. Anne’s Hospital to see Nate.", 90, "Head to the hospital."))
			if w.data.characters.matt.alive and who != "matt" and not talked_matt:
				a.append(option("matt", "Drive down to the Juniper Diner.", 75, "Head to the diner."))

		_:
			# Road or other fallback locations
			if day >= 1 and not drove_today:
				a.append(option("drive", "Keep driving the county road to clear your head.", 75, "Fatigue makes driving more dangerous."))
			a.append(option("rest", "Turn the car around and head home to sleep.", 480, "Return to the house to rest."))
			if w.data.characters.nate.alive and who != "nate" and not visited_nate:
				a.append(option("visit", "Head toward St. Anne’s Hospital to see Nate.", 90, "Drive to the hospital."))
			if w.data.characters.matt.alive and who != "matt" and not talked_matt:
				a.append(option("matt", "Head toward the Juniper Diner to meet Matt.", 75, "Drive to the diner."))
			if w.data.characters.cole.alive and who != "cole" and not interviewed_cole:
				a.append(option("investigate", "Head toward the station to meet Cole.", 90, "Drive to the station."))

	if a.is_empty():
		a.append(option("rest", "Head home to rest and let the night pass.", 480, "All immediate daytime tasks are completed for today. Rest advances to the next morning."))
	return a

func validate(w, action_id: String) -> String:
	if not w.player().alive or w.player().health <= 0:
		return "The current character is not alive."
	if not choices(w).any(func(c): return c.id == action_id):
		return "That approach is no longer available in this scene."
	if w.data.scene in ["accident", "pressure"] and w.player().location != "plant":
		return "This action requires being at the plant."
	var required_actor: String = {"pressure": "harold", "statement": "cole", "homecoming": "erin"}.get(w.data.scene, "")
	if w.data.scene == "encounter":
		required_actor = encounters.catalogue()[w.data.flags.encounter].actor
	if not required_actor.is_empty() and (not w.data.characters[required_actor].alive or w.data.characters[required_actor].location != w.player().location):
		return "The other person must be alive and present for this conversation."
	if action_id in ["photo", "record"] and (not "phone" in w.player().possessions or w.data.objects.phone.condition != "working"):
		return "A working phone is required."
	return ""

func setup_danger(w, kind: String, prefix: String) -> String:
	return scenes.setup_danger(w, kind, prefix)

func act(w, action_id: String) -> bool:
	last_error = validate(w, action_id)
	if not last_error.is_empty():
		return false
	var a: Dictionary = choices(w).filter(func(c): return c.id == action_id)[0]
	var before_scene: String = w.data.scene
	var before_day = int(w.data.minute / 1440)
	var who: String = w.data.player
	w.advance(a.minutes)
	w.record(w.player().name + " chose: " + a.label, [who], "player action", false, "working", who)
	
	# Mark daily / one-shot completed action tracking flags to prevent duplicate choices
	match action_id:
		"family": w.data.flags["talked_family_day_" + str(before_day)] = true
		"visit": w.data.flags["visited_nate_day_" + str(before_day)] = true
		"investigate": w.data.flags["interviewed_cole_day_" + str(before_day)] = true
		"matt": w.data.flags["talked_matt_day_" + str(before_day)] = true
		"luis": w.data.flags["talked_luis_day_" + str(before_day)] = true
		"neighbor": w.data.flags["talked_neighbor_day_" + str(before_day)] = true
		"doctor": w.data.flags["saw_doctor_day_" + str(before_day)] = true
		"drive": w.data.flags["drove_today_" + str(before_day)] = true
		"records": w.data.flags["records_" + who] = true
		"correct": w.data.flags["corrected"] = true
		"job": w.data.flags["job_reviewed"] = true
		"rest": w.data.flags["rested_day_" + str(before_day)] = true

	var prose = ""
	match before_scene:
		"encounter": prose = encounters.resolve(w, action_id)
		"accident": prose = scenes.accident(w, action_id)
		"pressure": prose = scenes.pressure(w, action_id)
		"statement": prose = scenes.statement(w, action_id)
		"homecoming": prose = scenes.homecoming(w, action_id)
		"danger": prose = scenes.danger(w, action_id)
		_: prose = scenes.town(w, action_id)
	var npc_text = npc_turn(w, before_day, a.minutes)
	if not npc_text.is_empty():
		prose += "\n\n" + npc_text
	if w.player().health <= 0:
		prose += "\n\n" + succeed(w)
	elif before_scene == "town":
		var encounter_text: String = encounters.trigger(w)
		if not encounter_text.is_empty():
			prose += "\n\n" + encounter_text
	w.data.flags.last_action = a
	w.story(prose)
	w.data.story_log.back()["action"] = a.label
	w.data.flags.last_actor = who
	return true

func npc_turn(w, before_day: int, minutes_passed: int = 30) -> String:
	var visible: Array[String] = []
	var sim_ambient = npc_sim.simulate(w, minutes_passed, before_day)
	if not sim_ambient.is_empty():
		visible.append(sim_ambient)
	var rumors = RumorNetwork.propagate(w)
	for r in rumors:
		visible.append(r)
	for intent in w.data.intentions:
		if intent.status == "pending" and w.data.minute >= intent.due and w.data.characters[intent.actor].alive and intent.actor != w.data.player:
			intent.status = "completed"
			if intent.action == "review_log":
				w.data.objects.maintenance_log.condition = "inspection added after accident"
				var event_id: String = w.record("Harold filled an inspection line in the maintenance log after the accident.", ["harold"], "private action", false, "important", "harold")
				w.data.objects.maintenance_log.history.append(event_id)
			elif intent.action == "repay":
				if w.data.characters.matt.finances.cash >= 120 and w.data.characters.daniel.alive:
					w.data.characters.matt.finances.cash -= 120
					w.data.characters.matt.finances.debt -= 120
					w.data.characters.daniel.finances.cash += 120
					w.record("Matt repaid the loan to Daniel.", ["matt", "daniel"], "bank transfer", false, "important", "matt")
					if w.data.player == "daniel":
						visible.append("A transfer from Matt arrives. He remembered the date on the diner paper.")
				else:
					intent.status = "unfulfilled"
	if w.data.characters.luis.alive and w.data.player != "luis" and w.flag("luis_witness") and not w.flag("luis_spoke") and w.data.minute > 500:
		w.data.flags.luis_spoke = true
		w.record("Luis told Cole he heard Harold ask for a consistent story about the guard.", ["luis", "cole"], "Luis’s witness statement", false, "important", "harold")
		w.data.intentions.append({"actor": "luis", "action": "tell_cole", "due": w.data.minute, "why": "Witnessed pressure and wants to protect coworkers", "status": "completed"})
	if w.data.characters.cole.alive and (w.flag("evidence_shared") or w.flag("log_shared") or w.flag("luis_spoke")) and w.data.minute > 1440 and not w.flag("case_open"):
		w.data.flags.case_open = true
		w.record("Cole opened a formal safety investigation based on the evidence received.", ["cole"], "case decision", false, "important", "cole")
	var day = int(w.data.minute / 1440)
	if day > before_day:
		for tick_day in range(before_day + 1, day + 1):
			for id in w.data.characters:
				if id == w.data.player:
					continue
				var p: Dictionary = w.data.characters[id]
				if not p.alive:
					continue
				p.finances.cash = maxi(0, int(p.finances.cash) - 24)
				p.fatigue = 15
				if id == "nate":
					p.health = mini(95, int(p.health) + (9 if w.flag("quick_help") else 5))
				if id.begins_with("local_") and id != w.data.player:
					var workplaces = {"Nurse": "hospital", "Mechanic": "plant", "Shopkeeper": "diner", "Teacher": "home", "Plant worker": "plant"}
					p.location = workplaces[p.occupation] if not w.flag("plant_closed") or workplaces[p.occupation] != "plant" else "diner"
					w.record(p.name + (" looked for temporary work while the plant was closed." if p.location == "diner" and workplaces[p.occupation] == "plant" else " kept their daily commitments as a " + p.occupation.to_lower() + "."), [id], "routine", false, "working", id)
			if tick_day == 2 and w.data.player != "erin" and w.data.characters.erin.alive:
				w.record("Erin sent an application for a job two towns away.", ["erin"], "private action", false, "important", "erin")
				w.data.characters.erin.goals.append("Attend the job interview")
				w.data.intentions.append({"actor": "erin", "action": "apply_job", "due": w.data.minute, "why": "Regain financial stability and reduce dependence", "status": "completed"})
			if tick_day >= 3 and w.data.player != "chloe" and not w.flag("chloe_suspects") and w.data.characters.chloe.alive and w.data.characters.erin.alive and w.data.characters.chloe.location == "home" and w.data.characters.erin.location == "home" and w.knows("erin", "application"):
				w.data.flags.chloe_suspects = true
				var heard: String = w.record("Chloe overheard Erin mentioning a job two towns away on the phone.", ["chloe"], "overheard conversation", false, "important", "erin")
				w.record("Chloe suspects Erin wants to move away from the family.", ["chloe"], heard + " / Chloe’s interpretation", true, "important", "erin")
				w.data.characters.chloe.beliefs.append({"belief": "Mom might be planning to leave us.", "source": heard, "confidence": 0.65, "possibly_false": true})
		var fin_notes = Finances.daily_tick(w, day, before_day)
		visible.append_array(fin_notes)
		var thread_notes = StoryThreads.update_daily_threads(w, day, before_day)
		visible.append_array(thread_notes)
		if w.flag("blamed") and not w.flag("nate_heard") and w.data.characters.nate.alive and w.data.characters.cole.alive:
			w.data.flags.nate_heard = true
			w.record("Cole told Nate that Daniel suggested Nate bypassed the guard.", ["nate", "cole"], "Cole relayed Daniel’s allegation", true, "important", "daniel")
			w.relationship("nate", "daniel", "resentment", 20)
		if day >= 3 and w.flag("case_open") and not w.flag("plant_closed"):
			w.data.flags.plant_closed = true
			w.record("The plant suspended production pending a safety review.", w.data.characters.keys(), "public closure notice", false, "important", "harold")
			visible.append("A public notice arrives: production at Mercer Works is suspended pending a safety review. There will be no shifts until further notice.")
		elif day >= 3 and not w.flag("case_open") and w.data.relationships["harold:daniel"].resentment >= 25 and not w.flag("fired_daniel") and w.data.characters.harold.alive:
			w.data.flags.fired_daniel = true
			w.record("Harold removed Daniel from the shift rota, citing restructuring.", ["harold", "daniel"], "employment notice", false, "important", "daniel")
			if w.data.player == "daniel":
				visible.append("Your name is missing from the next rota. Harold’s message calls it restructuring.")
		if day >= 7 and not w.flag("week_seen"):
			w.data.flags.week_seen = true
			visible.append("A week ago, none of this had happened. The people who remember it are still here. Your story can continue.")
	return "\n\n".join(visible)

func succeed(w) -> String:
	var previous: String = w.data.player
	w.player().alive = false
	w.data.deaths.append({"character": previous, "minute": w.data.minute, "cause": w.data.flags.get("last_hazard", "injury")})
	var ranked: Array = []
	for id in ["erin", "chloe", "luis", "nate", "cole", "harold", "matt", "rebecca"]:
		if id == previous or not w.data.characters[id].alive:
			continue
		var r: Dictionary = w.data.relationships[id + ":" + previous]
		var score: float = r.familiarity * 0.3 + r.resentment * 0.2 + r.affection * 0.2 + w.memories_for(id, previous).size() * 3 + w.rng.randf_range(0, 35)
		ranked.append({"id": id, "score": score})
	if ranked.is_empty():
		for id in w.data.characters:
			if w.data.characters[id].alive:
				ranked.append({"id": id, "score": 1})
	if ranked.is_empty():
		w.data.scene = "ended"
		return "There is nobody left to carry this story."
	ranked.sort_custom(func(a, b): return a.score > b.score)
	w.data.player = ranked[0].id
	w.data.scene = "town"
	w.record(w.data.characters[previous].name + " died after an accident.", [w.data.player], "notification from emergency services", false, "important", previous)
	w.data.flags.successor_reason = {"previous": previous, "selected": w.data.player, "candidates": ranked, "criteria": "Connection, unresolved resentment, affection, shared memories, seeded uncertainty"}
	return "SOMEONE ELSE’S MORNING\n\n" + w.player().name + " hears the news at " + w.data.locations[w.player().location] + ". For a long moment, the ordinary room feels unfamiliar.\n\nYou are " + w.player().name + " now. You carry their memories, their worries, and the parts of this story they were never told."
