extends RefCounted
const Schedule = preload("res://scripts/town_schedule.gd")

static func scheduled_events(w) -> Array[String]:
	var visible: Array[String] = []
	var minute: int = w.data.minute
	if not w.data.characters.erin.alive:
		return visible
	if w.data.player != "erin" and minute >= 2 * 1440 + 9 * 60 and not w.flag("job_applied") and Schedule.within(minute, 0, 9 * 60, 17 * 60, true):
		w.data.flags.job_applied = true
		w.record("Erin sent an application for a job two towns away.", ["erin"], "private application", false, "important", "erin")
	if minute >= 3 * 1440 + 10 * 60 and w.flag("job_applied") and not w.flag("job_interview_held") and Schedule.within(minute, 0, 10 * 60, 16 * 60, true):
		w.data.flags.job_interview_held = true
		w.data.flags.job_interview_minute = minute
		w.record("Erin completed her interview for the accounting position in Millfield.", ["erin"], "private interview", false, "important", "erin")
	if minute >= 4 * 1440 + 15 * 60 and w.flag("job_interview_held") and minute > int(w.data.flags.get("job_interview_minute", 0)) + 1440 and not w.flag("job_offered") and Schedule.within(minute, 0, 9 * 60, 17 * 60, true):
		w.data.flags.job_offered = true
		w.record("The Millfield firm offered Erin the accounting position, with a start date to agree after acceptance.", ["erin"], "formal offer", false, "important", "erin")
		if w.data.player == "daniel":
			visible.append("Erin forwards you the offer. A salary that does not come from Mercer Works. ‘We need to talk tonight,’ she writes.")
	if w.flag("job_accepted") and minute >= 7 * 1440 + 8 * 60 and Schedule.within(minute, 0, 8 * 60, 17 * 60, true):
		w.data.flags.job_started = true
	return visible
## Manages persistent macro story threads and delayed consequences across 7 days.
## Evaluates systemic ripples from player choices, off-screen NPC actions, and seeded truths.

static func update_daily_threads(w, day: int, before_day: int) -> Array[String]:
	var visible: Array[String] = []
	var p: Dictionary = w.player()
	var who: String = w.data.player
	var truths: Dictionary = w.data.get("truths", {})

	# Exhaustion is cleared by rest, not by crossing midnight.

	# 2. Thread: Nate Bell Clinical Trajectory
	if w.data.characters.nate.alive:
		var nate = w.data.characters.nate
		var prognosis = truths.get("nate_prognosis", "nerve_damage")
		if day == 2:
			nate.health = mini(90, int(nate.health) + (15 if w.flag("quick_help") else 5))
			w.record("Nate survived emergency vascular surgery at St. Anne’s Hospital.", ["nate"], "medical bulletin", false, "important", "nate")
		elif day == 4:
			if prognosis == "complications" and not w.flag("quick_help"):
				nate.health = maxi(15, int(nate.health) - 20)
				w.record("Nate developed a postoperative systemic infection.", ["nate"], "hospital notice", false, "important", "nate")
				if w.player().location in ["home", "hospital"]:
					visible.append("Word reaches you from St. Anne’s: Nate has developed a postoperative fever and is back in intensive care.")
			else:
				nate.health = mini(95, int(nate.health) + 10)
		elif day == 6:
			w.record("Nate retained an industrial injury attorney to inspect Mercer Works maintenance logs.", ["nate"], "legal consultation", false, "important", "nate")

	# 3. Thread: Brother Matt Mercer Delivery Route
	if w.data.characters.matt.alive:
		var matt = w.data.characters.matt
		if day >= 4 and not w.flag("matt_loan_given") and not w.flag("matt_delivery_plan") and not w.flag("matt_van_impounded"):
			w.data.flags.matt_van_impounded = true
			matt.finances.debt += 350
			w.record("Matt’s courier van was towed and impounded after breaking down on County Route 9.", ["matt"], "towing notice", false, "important", "matt")
			if who == "daniel":
				visible.append("A voicemail from Matt: his van was impounded on Route 9. He lost his delivery contract.")


	# 5. Thread: OSHA & The Plant Investigation
	if w.data.characters.cole.alive:
		if day >= 3 and w.flag("case_open") and not w.flag("plant_closed"):
			w.data.flags.plant_closed = true
			w.record("The plant suspended production pending a safety review.", w.data.characters.keys(), "public closure notice", false, "important", "harold")
			visible.append("A public notice arrives: production at Mercer Works is suspended pending a safety review. There will be no shifts until further notice.")
		elif day >= 3 and not w.flag("case_open") and not w.flag("week_complete") and w.data.relationships["harold:daniel"].resentment >= 25 and not w.flag("fired_daniel") and w.data.characters.harold.alive:
			w.data.flags.fired_daniel = true
			w.record("Harold removed Daniel from the supervisor rota, citing plant restructuring.", ["harold", "daniel"], "employment notice", false, "important", "daniel")
			if who == "daniel":
				visible.append("Your name is missing from the plant rota. Harold Voss’s memo calls it temporary restructuring.")

	# 6. Thread: Day 7 The Reckoning
	if day >= 6 and not w.flag("week_seen"):
		w.data.flags.week_seen = true
		visible.append("SUNDAY\n\nA week of choices is behind you. Cole's office reopens Monday at 09:00; you can review the week's record then. The safety inquiry may take longer.")

	return visible

static func resolve_commitments(w, day: int) -> Array[String]:
	var visible: Array[String] = []
	for key in ["erin_offer", "meeting", "strike_vote", "matt_van", "luis_statement", "nate_bill"]:
		if not w.data.flags.has("decision_" + key) or w.data.flags.has("outcome_" + key) or day <= int(w.data.flags.get("decision_day_" + key, day)):
			continue
		var contact: String = {"erin_offer": "erin", "meeting": "luis", "strike_vote": "luis", "matt_van": "matt", "luis_statement": "luis", "nate_bill": "nate"}[key]
		if not preload("res://scripts/town_schedule.gd").person_available(contact, w.data.minute, 0):
			continue
		var decision: String = w.data.flags["decision_" + key]
		var outcome = ""
		var actor = "erin"
		match key:
			"nate_bill":
				actor = "nate"
				match decision:
					"forms": outcome = "Nate sends you the receipt for his benefit claim. ‘They finally have what they asked for.’ There is no payment yet, but he no longer has to fight the paperwork alone."
					"money": outcome = "Nate texts that the $60 covered groceries. Then a second message: ‘I'm still angry.’ He accepted your help; he did not sell you forgiveness."
					"hear": outcome = "Nate sends a message about a bad night. He is choosing you as someone he can tell without having to say he is fine."
					_: outcome = "Nate stops sending updates. You asked for distance when your own life felt too full. Now the silence is real."
			"luis_statement":
				actor = "luis"
				if decision == "named":
					w.data.flags.fired_luis = true
					outcome = "Luis shows you the new rota. His name is gone. ‘Scheduling changes,’ Harold called it. Luis taps the signature he gave Cole. ‘You said you wouldn't disappear.’ His account is still in the inquiry. The cost has reached the friend who gave it."
				elif decision == "protect":
					outcome = "Luis catches you outside the diner. ‘My name's still on the rota.’ You kept his name out of your lead. The inspection log still needs an account you can stand behind yourself."
				else:
					outcome = "Luis thanks you for letting the unsigned statement go. There is no new witness account for Cole; your friend has not had to put his livelihood behind it."
			"erin_offer":
				if not w.data.characters.erin.alive:
					continue
				w.data.flags.job_accepted = true
				outcome = "Erin tells you she accepted the Millfield job. " + ("With your support, she arranged the commute and Chloe's rides with you." if decision in ["celebrate", "practical"] else "She arranged her own commute. Your worries about the marriage remain unresolved.")
				w.data.characters.erin.goals.append("Start the Millfield job")
			"meeting":
				actor = "luis"
				if decision in ["join", "quiet"]:
					w.data.flags.paid_leave_granted = true
					w.data.characters.daniel.finances.cash += 112
					outcome = "Luis reports that the crew's written request won one day's emergency paid leave. Daniel receives $112. " + ("Your signature was on the request." if decision == "join" else "Your drafting helped, although you did not sign.")
				else:
					outcome = "Luis reports that the crew's request for paid leave is still unanswered. You did not help submit it, and no leave payment has arrived."
			"strike_vote":
				actor = "luis"
				if decision == "picket":
					w.data.flags.picket_held = true
					outcome = "The crew holds the picket line with your support. Management agrees to meet worker representatives; production remains suspended pending the safety work."
				elif decision == "mediate":
					w.data.flags.mediation_requested = true
					outcome = "Your offer to mediate reaches Harold. He agrees to a meeting with Luis, but offers no reopening date or wage guarantee."
				else:
					outcome = "The crew continues organizing without you. Luis sends the next update through a coworker; you chose to spend that time with your family."
			"matt_van":
				actor = "matt"
				outcome = "Matt calls: the shared delivery routes kept his contract alive." if decision == "ride" else ("Matt calls: your loan covered the repair and he is back on his route." if decision == "lend" else "Matt remembers that you could not help with the van. He is still trying to recover his delivery work.")
		w.data.flags["outcome_" + key] = outcome
		w.record(outcome, [w.data.player, actor], "follow-up conversation", false, "important", actor)
		visible.append(outcome)
	return visible
