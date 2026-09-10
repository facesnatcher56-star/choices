extends RefCounted
## Manages persistent macro story threads and delayed consequences across 7 days.
## Evaluates systemic ripples from player choices, off-screen NPC actions, and seeded truths.

static func update_daily_threads(w, day: int, before_day: int) -> Array[String]:
	var visible: Array[String] = []
	var p: Dictionary = w.player()
	var who: String = w.data.player
	var truths: Dictionary = w.data.get("truths", {})

	# Clear temporary exhaustion condition after a full night's sleep
	if p.has("conditions") and "exhausted" in p.conditions:
		p.conditions.erase("exhausted")

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
		if day >= 4 and not w.flag("matt_loan_given") and not w.flag("matt_van_impounded"):
			w.data.flags.matt_van_impounded = true
			matt.finances.debt += 350
			w.record("Matt’s courier van was towed and impounded after breaking down on County Route 9.", ["matt"], "towing notice", false, "important", "matt")
			if who == "daniel":
				visible.append("A voicemail from Matt: his van was impounded on Route 9. He lost his delivery contract.")

	# 4. Thread: Mercer Family & Marriage
	if w.data.characters.erin.alive:
		if day == 2 and not w.flag("job_applied") and who != "erin":
			w.data.flags.job_applied = true
			w.record("Erin sent an application for a bookkeeping position in Millfield.", ["erin"], "private application", false, "important", "erin")
		elif day == 4 and not w.flag("job_interview_held") and w.flag("job_applied"):
			w.data.flags.job_interview_held = true
			w.record("Erin completed an interview for the accounting position in Millfield.", ["erin"], "interview", false, "important", "erin")
		elif day == 5 and not w.flag("job_offered") and w.flag("job_interview_held"):
			w.data.flags.job_offered = true
			w.record("The Millfield firm offered Erin the accounting position, with a start date next Monday.", ["erin"], "formal offer", false, "important", "erin")
			if who == "daniel":
				visible.append("Erin received an email offer from the accounting firm in Millfield. The decision to stay or move cannot be deferred much longer.")

	# 5. Thread: OSHA & The Plant Investigation
	if w.data.characters.cole.alive:
		if day >= 2 and (w.flag("evidence_shared") or w.flag("log_shared") or w.flag("luis_spoke")) and not w.flag("case_open"):
			w.data.flags.case_open = true
			w.record("Officer Cole formally requested a state OSHA investigator for Line 4.", ["cole"], "case action", false, "important", "cole")
		if day >= 3 and w.flag("case_open") and not w.flag("plant_closed"):
			w.data.flags.plant_closed = true
			w.record("The plant suspended production pending a safety review.", w.data.characters.keys(), "public closure notice", false, "important", "harold")
			visible.append("A public notice arrives: production at Mercer Works is suspended pending a safety review. There will be no shifts until further notice.")
		elif day >= 3 and not w.flag("case_open") and w.data.relationships["harold:daniel"].resentment >= 25 and not w.flag("fired_daniel") and w.data.characters.harold.alive:
			w.data.flags.fired_daniel = true
			w.record("Harold removed Daniel from the supervisor rota, citing plant restructuring.", ["harold", "daniel"], "employment notice", false, "important", "daniel")
			if who == "daniel":
				visible.append("Your name is missing from the plant rota. Harold Voss’s memo calls it temporary restructuring.")
		if day >= 5 and w.flag("case_open") and not w.flag("subpoena_served"):
			w.data.flags.subpoena_served = true
			w.record("The District Attorney issued subpoenas for all Line 4 shift supervisor logs.", ["cole", "daniel", "harold"], "legal subpoena", false, "important", "cole")

	# 6. Thread: Day 7 The Reckoning
	if day >= 7 and not w.flag("week_seen"):
		w.data.flags.week_seen = true
		visible.append("DAY SEVEN · THE RECKONING\n\nSeven days have elapsed since Line 4 caught Nate Bell. The town of Briar Glen has absorbed the shocks, the lies, the debts, and the choices made under pressure. The consequences have taken permanent root.")

	return visible
