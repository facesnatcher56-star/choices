extends RefCounted
## Authored narrative resolutions and sensory descriptions for story scenes and hazards.

func travel(w, destination: String, other: String = "") -> void:
	w.player().location = destination
	if not other.is_empty() and w.data.characters[other].alive:
		w.data.characters[other].location = destination

func accident(w, id: String) -> String:
	var text = ""
	match id:
		"ambulance", "call_luis":
			w.data.flags.quick_help = true
			w.data.characters.nate.health = 48
			text = "You pull your phone out to call 911. While the dispatcher picks up, the machine's steel ram shudders through another cycle—shit, you forgot to hit the e-stop! Luis dives across the floor and kills the main breaker just in time. Paramedics arrive while you're packing Nate’s shredded arm, but the delay in killing the power was a terrifying gamble."
		"stop":
			w.data.flags.power_off = true
			w.data.characters.nate.health = 44
			text = "You throw your body weight into the mushroom e-stop. With a dying hiss of hydraulics, the press freezes inches from Nate's neck. But the machine is dead and nobody has called 911 yet—Nate is convulsing on the concrete, losing blood fast while you scream for Luis to dial emergency dispatch."
		"photo":
			w.data.flags.photo = true
			w.data.objects.photo = {"owner": "daniel", "location": "daniel", "condition": "original", "history": []}
			w.player().possessions.append("photo")
			w.record("Daniel photographed the wire holding the guard open.", ["daniel", "harold", "luis"], "direct observation", false, "important", "daniel")
			text = "You whip out your phone and snap three quick photos of the bypass wire and Nate’s blood on the serial plate. The LED flash lights up the bay. Harold's face twists with pure fury: ‘What the hell are you doing taking pictures while he’s bleeding?!’ You locked down the evidence, but you just made an enemy on the spot."
		"ask_harold":
			text = "You demand to know what Harold means. Harold snaps back with defensive panic: ‘I mean what I said! If inspectors see that bypass, we’re all out on the street!’ Luis lunges between you both, screaming: ‘Shut up! Can this wait? He’s bleeding out!’ While you two argued, Nate lost precious blood."
		"touch_guard":
			w.data.objects.guard.condition = "wire removed"
			w.data.objects.guard.history.append("Daniel removed wire before investigators arrived")
			w.data.flags.disturbed = true
			w.player().health -= 18
			w.record("Daniel removed the bypass wire before investigators arrived.", ["daniel", "harold", "luis"], "direct observation", false, "important", "daniel")
			text = "You reach past the warm steel frame and rip the bypass wire free. The sharp copper burr slices deep, leaving a bright cut across your palm. The heavy yellow guard drops shut with a loud iron clang. Luis calls for help. You got rid of the wire, but your own blood is on the machine now and the scene is compromised."
	w.data.flags.accident = true
	w.record("Nate was taken to St. Anne’s Hospital after the machine accident.", ["daniel", "harold", "luis"], "direct observation", false, "important", "nate")
	w.data.characters.nate.location = "hospital"
	w.data.scene = "pressure"
	return text + "\n\nParamedics wheel Nate out under screaming sirens. After the ambulance leaves, Harold catches you by the time clock, smelling of sour sweat:\n\n‘We need to be consistent. You checked that guard. It looked normal. That’s all anyone needs to hear.’"

func pressure(w, id: String) -> String:
	var text = ""
	var witnesses: Array = ["daniel", "harold"]
	match id:
		"agree":
			w.data.flags.promised = true
			w.relationship("harold", "daniel", "trust", 18)
			text = "You nod and promise to back his story. Harold exhales a long breath, clamping a clammy hand onto your arm: ‘Good man. I’ll remember this.’ You saved your paycheck for now, but your name is tied to a cover-up."
		"refuse":
			w.relationship("harold", "daniel", "trust", -20)
			w.relationship("harold", "daniel", "resentment", 20)
			text = "You tell Harold you’re giving an honest statement. His face hardens like iron: ‘Then tell it honestly. Just remember whose signature is on the shift sheet.’ The threat hangs like ice—your job is directly on the line."
		"why":
			text = "You ask why he needs it settled tonight. Harold’s voice drops to an urgent, furious whisper: ‘Because one lost contract means thirty people without wages.’ He rubs his eyes. He's terrified of bankruptcy, but you still don't know who wired that guard."
		"defer":
			text = "You tell him your head is spinning and you need time to think. Harold checks the clock with naked frustration: ‘Take your time.’ You bought a moment, but Cole's headlights are already sweeping across the gravel outside."
		"witness":
			witnesses.append("luis")
			w.data.flags.luis_witness = true
			w.relationship("luis", "daniel", "trust", 12)
			text = "You step back toward the doorway and call Luis over. Luis appears with blood on his sleeves. Harold freezes, flushing crimson before coughing out a timid, watered-down request. Harold glares at you with quiet hatred, but now you have a witness."
		"record":
			w.data.flags.recording = true
			w.relationship("harold", "daniel", "trust", -25)
			text = "You pull out your phone with the red record light glaring. Harold’s jaw drops in fury: ‘Turn that off.’ The file captures his order and a long silence. You didn't get a confession, but you just declared open war."
	w.record("Harold asked Daniel to say the guard looked normal; Daniel chose to " + {"agree": "agree", "refuse": "refuse", "why": "question the request", "defer": "defer an answer", "witness": "bring Luis in", "record": "record the exchange"}[id] + ".", witnesses, "direct conversation", false, "important", "daniel")
	w.data.intentions.append({"actor": "harold", "action": "review_log", "due": w.data.minute + 240, "why": "Protect the production contract after a reportable accident", "status": "pending"})
	w.data.scene = "statement"
	w.data.characters.cole.location = "plant"
	return text + "\n\nA cruiser door clunks shut out in the rain. Officer Cole arrives with a notebook. He asks you to step away from the others.\n\n‘Start with what you saw. Not what someone told you happened.’"

func statement(w, id: String) -> String:
	var text = ""
	match id:
		"lie":
			w.data.flags.lied = true
			w.record("Daniel told Cole the guard looked normal when he checked it.", ["daniel", "cole"], "Daniel’s unverified statement", true, "important", "daniel")
			w.record("Daniel knowingly gave a misleading account of the guard.", ["daniel"], "private intention", false, "important", "daniel")
			text = "You look Cole dead in the eye and say the guard looked normal during your check. Cole writes it down without looking up. Harold exhales in the corner, but your stomach twists—you just signed your name to a lie on a police report."
		"blame":
			w.data.flags.blamed = true
			w.record("Daniel suggested Nate bypassed the guard; he provided no eyewitness evidence.", ["daniel", "cole"], "Daniel’s allegation", true, "important", "daniel")
			text = "You suggest Nate was rushing to hit piece-rate quotas and wired the guard back himself. ‘Did you see him do that?’ Cole asks. You did not. He draws a line beneath the word ‘suggests’. Cole smells a smear, and Nate will hear about this."
		"delay":
			w.data.flags.delayed_statement = true
			text = "You tell Cole you're in shock and need until tomorrow to give a formal account. Cole gives you his card. ‘Tomorrow, then. Write down what you remember before you speak to anyone else.’ You bought a night to breathe, but you’ve put a target on your back."
		_:
			w.data.flags.honest = true
			w.record("Daniel told Cole he found the guard bypassed and did not see who did it.", ["daniel", "cole"], "witness statement", false, "important", "daniel")
			text = "You describe the wire, Nate’s breathing, and the running machine. You draw a careful boundary around everything you do not know. Cole does not fill it in for you. You kept your integrity, but Harold is glaring daggers from across the bay."
			if id == "evidence":
				w.data.flags.evidence_shared = true
				w.record("Cole received Daniel’s original photograph of the bypassed guard.", ["daniel", "cole"], "photograph", false, "important", "daniel")
				text += " You hand over the digital photo of the wire, the bloody plate, and the clock. Cole’s eyes narrow as he logs it into evidence. Harold looks ready to kill you."
	w.data.characters.cole.location = "station"
	w.player().location = "home"
	w.data.scene = "homecoming"
	return text + "\n\nIt is nearly 4:00 AM when your beat-up Chevy rattles into the Mercer driveway. Inside, the kitchen light is on—never a good sign before dawn. Sitting at the laminate table is your wife, Erin. Twelve years of marriage, two maxed-out store credit cards, and a kitchen table currently buried under the holy trinity of Mercer family finances: overdue electric, Chloe's high-school track fee notice, and two stone-cold mugs of tea. Beside the mugs sits an unpaid heating bill and a note in Erin's handwriting: ‘Matt called twice - van died on route 9’. Upstairs in the front bedroom, your fifteen-year-old daughter Chloe is asleep under her track posters.\n\nErin looks up over her reading glasses, taking in the machine grease on your jacket and the dark smear of blood on your cuffs.\n\n‘You said you’d be back before two, Daniel.’ She looks at your face, voice dropping to a whisper. ‘What happened at the plant?’"

func homecoming(w, id: String) -> String:
	var text = ""
	match id:
		"tell":
			w.data.flags.told_erin = true
			w.relationship("erin", "daniel", "trust", 12)
			w.record("Daniel told Erin about Nate’s accident and Harold’s request.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
			text = "You sit across from her and describe the horrific accident, Nate’s mangled arm, and Harold cornering you by the time clock. Erin lets you finish, pulling her cardigan tight against the draft. ‘I can handle bad news, Daniel. I can handle living broke and driving a truck with a dying alternator. I cannot handle finding out from somebody else that my husband went to jail for Harold Voss.’\n\nShe taps the scrap of paper on the table. ‘Your brother Matt called twice while you were on shift. His delivery van broke down on route 9 again. He was begging for money. I told him we’re two weeks behind on the heating bill.’"
			if w.flag("lied"):
				w.record("Daniel admitted to Erin that he knowingly misled Cole.", ["daniel", "erin"], "Daniel’s admission", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", -18)
				text += "\n\nWhen you admit that you already lied to Officer Cole to protect your job, she moves her cup away. ‘You lied on a police report?! Daniel, then you need to fix that before they drag you out of here in front of Chloe. I cannot do it for you.’"
		"partial":
			w.record("Daniel told Erin only that Nate was injured at work.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
			text = "You tell her Nate got caught in a machine, but bury Harold’s threats and the statement. ‘Is he going to be all right?’ You tell her you do not know. She pushes the paper scrap forward. ‘Your brother Matt called twice while you were gone. His courier van died on route 9. He was begging for a loan. I told him we don't have it.’"
		"hide":
			w.record("Daniel said he was late because of a difficult shift.", ["daniel", "erin"], "Daniel’s account", true, "important", "daniel")
			w.relationship("erin", "daniel", "trust", -4)
			text = "You wash the grease from your hands in the sink and claim an overhaul ran late. Erin looks at the clock. ‘All right.’ She does not challenge the story. Twelve years together means she knows when you're lying; it just means she’s too tired to fight about it. ‘Your brother Matt called at one in the morning,’ she adds quietly. ‘His van broke down on route 9. He was hoping you could bail him out.’"
		"listen":
			w.data.flags.job_known = true
			w.record("Erin told Daniel she is considering a job two towns away.", ["daniel", "erin"], "Erin’s disclosure", false, "important", "erin")
			w.relationship("erin", "daniel", "affection", 10)
			text = "You put your hands over hers and ask about her day before she can interrogate yours. Erin hesitates. There is a job opening two towns away. ‘I was waiting for a moment when we could actually talk.’ She pauses, glancing at the phone. ‘Your brother Matt called earlier about his van breaking down on route 9 again. Always something draining the tank.’"
		"chloe":
			w.record("Daniel told Chloe and Erin that Nate was injured at the plant.", ["daniel", "erin", "chloe"], "family conversation", false, "important", "daniel")
			text = "Chloe steps down the stairs in her oversized school hoodie, rubbing her eyes. ‘Does his family know?’ A fifteen-year-old asked the one question neither you nor Harold stopped to consider."
		"sleep":
			w.player().fatigue = 10
			w.player().health = mini(100, w.player().health + 8)
			text = "‘Tomorrow,’ Erin says. You cannot tell whether it is an agreement or a deadline. When you wake, her cup has been washed and put away."
	w.data.scene = "town"
	w.data.flags["matt_called"] = true
	return text + "\n\nOutside, the pale November sunrise creeps over Briar Glen in shades of cold zinc and gray slush. Your shift is over. The rest of this is not."

func town(w, id: String) -> String:
	var who: String = w.data.player
	var name: String = w.player().name
	var day = int(w.data.minute / 1440)
	var text = ""
	match id:
		"visit":
			travel(w, "hospital")
			w.relationship("nate", who, "trust", 6)
			w.record(name + " visited Nate during his recovery.", [who, "nate"] if w.data.characters.nate.health >= 40 else [who], "hospital visit", false, "important", who)
			if w.data.characters.nate.health < 40:
				text = "Nate is out cold in St. Anne's Room 314 under heavy hospital morphine. A tired charge nurse lets you sit in the squeaking vinyl chair for ten minutes. A muted TV on the wall drones personal injury lawyer ads over the monitor beep."
			elif w.knows("nate", "suggested Nate"):
				text = "Nate is propped up with his bandaged arm elevated on foam pillows. ‘Cole told me what you suggested.’ He stares out at the gray rain on the glass. ‘You were not standing beside me. Remember that.’"
			else:
				text = "Nate shifts his bandaged arm with a wince of raw pain. ‘I remember the noise. I don’t remember the guard.’ He is frustrated by the blank space. You cannot fill it for him without hanging yourself."
				w.record("Nate says he cannot remember the guard immediately before the accident.", [who, "nate"], "Nate’s recollection", true, "important", "nate")
		"family":
			travel(w, "home", "erin")
			w.relationship("erin", who, "affection", 5)
			if who == "daniel" and w.knows("erin", "knowingly misled"):
				text = "Erin remembers the kitchen conversation. ‘Have you corrected what you told Cole?’ She is asking about the lie you admitted, not something she somehow guessed."
				if w.flag("corrected"):
					text += " You tell her about the correction. She reaches for your hand, but the conversation is not finished."
					w.record(name + " told Erin the statement was corrected.", [who, "erin"], "direct conversation", false, "important", who)
			elif w.knows("erin", "Nate"):
				text = "Erin asks how Nate is doing. The laundry is still waiting, Chloe needs a ride, and there is less in the account than either of you would like. You help with dinner."
			else:
				text = "Erin talks about the overdue bill and Chloe’s school trip. She has not been told what happened at the plant. Her worries are the ones she actually knows about."
			w.record(name + " spent time with Erin at home.", [who, "erin"], "routine", false, "working", who)
		"investigate":
			travel(w, "station", "cole")
			if int(w.data.flags.get("worked_" + who, -1)) != day and not w.flag("plant_closed") and who == "daniel":
				w.data.flags["forfeited_shift_" + str(day)] = true
			if w.flag("photo") and who == "daniel" and not w.flag("evidence_shared"):
				w.data.flags.evidence_shared = true
				w.record("Cole received Daniel’s photograph of the bypassed guard.", [who, "cole"], "photograph", false, "important", who)
				text = "You hand over the photograph. Cole asks you to keep the original. A fact that existed only on your phone is now part of the investigation."
			elif w.knows(who, "maintenance log") and not w.flag("log_shared"):
				w.data.flags.log_shared = true
				w.record(name + " shared the maintenance log findings with Cole.", [who, "cole"], "document disclosure", false, "important", who)
				text = "Cole adds your account of the maintenance log to the file. ‘A missing inspection does not tell us who touched the guard. It does tell us where to look.’"
			elif w.flag("case_open"):
				text = "Cole lays out what he can discuss: the machine is under review and the paperwork is incomplete. ‘Evidence of a safety failure is not evidence that one particular person caused it.’"
			else:
				text = "Cole has questions, not answers. He asks for documents and firsthand observations. Repeating a suspicion will not turn it into either."
			if w.data.flags.get("forfeited_shift_" + str(day), false):
				text += " Missing your morning factory shift forfeits $112 in day wages, but the case file is open in front of you."
			w.record(name + " met Cole to discuss the investigation.", [who, "cole"], "direct conversation", false, "working", who)
		"rest":
			travel(w, "home")
			w.player().fatigue = 8
			w.player().health = mini(100, int(w.player().health) + 12)
			text = "You eat cold leftovers over the sink, turn the phone face down, and sleep. For a while, the town carries on without you. When you wake, the light in the room has changed."
		"luis":
			travel(w, "diner", "luis")
			if w.data.relationships["luis:" + who].trust >= 50:
				w.record("Luis says the maintenance log had a blank inspection line before the accident.", [who, "luis"], "Luis’s recollection", true, "important", "luis")
				text = "Luis turns his mug in both hands. ‘There was a blank line in the maintenance book. I noticed it before the shift.’ He remembers missing paperwork, not who installed the wire."
			else:
				text = "Luis keeps the conversation on shifts and overtime. He does not trust you enough to put his job on the table. The coffee goes cold."
				w.relationship("luis", who, "trust", 5)
		"work":
			travel(w, "plant")
			w.data.flags["worked_" + who] = day
			w.player().finances.cash += 112
			text = "Seven hours under buzzing fluorescent tubes. You earn $112. Everyone on shift is walking on eggshells around Line 4."
			w.record(name + " completed a paid shift at the plant.", w.witnesses("plant"), "routine", false, "working", who)
			if w.player().fatigue > 78 and day >= 1:
				return setup_danger(w, "industrial", text + " Your hands are slower than the conveyor.")
		"records":
			travel(w, "plant")
			w.data.flags["records_" + who] = true
			var condition: String = w.data.objects.maintenance_log.condition
			w.record(name + " saw the maintenance log: " + condition + ".", [who], "document inspection", false, "important", who)
			text = "You find the maintenance log. " + ("An inspection line is blank. You copy the page before leaving." if condition == "intact" else "The inspection line has been filled in after the accident. Without an earlier copy, you cannot prove what used to be there.")
		"bills":
			w.data.flags["paid_bills_day"] = day
			var current_cash = int(w.player().finances.get("cash", 0))
			if current_cash >= 80:
				w.player().finances.cash -= 80
				text = "You sit down at the counter with your checkbook and clear the $80 heating bill before they shut the furnace off. The immediate notice is settled for now, though groceries and fuel will be waiting tomorrow."
			else:
				w.player().finances.cash = 0
				w.player().finances.debt += (80 - current_cash)
				text = "You pay the utility company what cash you have on hand ($" + str(current_cash) + ") and agree to carry the remaining balance. They grant a short reprieve on the shutoff."
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
		"bills_credit":
			w.data.flags["paid_bills_day"] = day
			w.player().finances.debt += 80
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
			w.record(name + " charged the $80 heating bill to the credit card.", [who], "credit card payment", false, "important", who)
			text = "You call the gas company and put the $80 on your credit card. The automated voice confirms the account is current. The furnace stays running, but your card balance ticks up to $" + str(w.player().finances.debt) + "."
		"truck_diy":
			travel(w, "home")
			w.data.flags.truck_fixed = true
			w.player().finances.cash = maxi(0, int(w.player().finances.cash) - 35)
			w.player().fatigue = mini(100, int(w.player().fatigue) + 35)
			if not w.player().conditions.has("exhausted"):
				w.player().conditions.append("exhausted")
			w.record(name + " spent the afternoon replacing the truck alternator with a junkyard pull.", [who], "diy repair", false, "working", who)
			text = "You spend three freezing hours under the truck's rusted chassis with a flashlight between your teeth. For $35 in scrapyard parts you save over a hundred dollars, but your knuckles are raw and your back is knotted with exhaustion."
		"truck_shop":
			travel(w, "road")
			w.data.flags.truck_fixed = true
			var cost = 140
			if w.player().finances.cash >= cost:
				w.player().finances.cash -= cost
				text = "Jim at the garage has the truck on the lift and back down in an hour. You hand over $140 in cash. It stings your wallet, but your afternoon stays free."
			else:
				w.player().finances.debt += cost
				text = "Jim swipes your credit card for the $140 repair. ‘Alternator was about two miles from dying,’ he says. The truck is safe, but the card debt grows."
			w.record(name + " paid for professional alternator replacement at the garage.", [who], "mechanic repair", false, "working", who)
		"matt":
			travel(w, "diner", "matt")
			text = "Your twenty-eight-year-old brother Matt sits in a diner booth smelling of motor oil and stale tobacco. A van repair estimate sits on the table like a death warrant. ‘I’m not asking for money,’ he says, about five seconds before asking for money. You stay for another coffee."
			w.relationship("matt", who, "affection", 6)
			w.record("Matt told " + name + " his delivery van needs repairs.", [who, "matt"], "direct conversation", false, "working", "matt")
		"correct":
			travel(w, "station", "cole")
			w.data.flags.corrected = true
			w.data.flags["apology_" + who] = true
			w.record("Daniel corrected his misleading statement to Cole; the original remains on file.", [who, "cole"], "signed correction", false, "important", who)
			w.relationship("cole", who, "trust", -8)
			text = "Cole takes a new statement. He does not tear out the old one. ‘This helps establish what happened. It also means we need to talk about why the first account was different.’"
		"doctor":
			travel(w, "hospital")
			w.player().health = mini(100, int(w.player().health) + 40)
			text = "The doctor treats what you had been trying to ignore. Rest, fluids, a follow-up appointment. You leave in better shape than you arrived."
		"drive":
			travel(w, "road")
			if w.player().fatigue > 65:
				return setup_danger(w, "road", "You miss the turn you have taken a hundred times. Your eyes will not stay focused.")
			text = "The county road winds past dark fields and a closed farm stand. You pull over for a while, then head back. Nothing happens. Sometimes that is what you need."
		"overtime":
			travel(w, "plant")
			w.player().finances.cash += 160
			w.player().fatigue = mini(100, int(w.player().fatigue) + 45)
			if not w.player().conditions.has("exhausted"):
				w.player().conditions.append("exhausted")
			w.relationship("erin", who, "resentment", 8)
			w.record(name + " worked an exhausting overnight double shift for $160 cash.", [who, "harold"], "overtime shift", false, "working", who)
			text = "Eight brutal hours hauling stamped steel until your forearms burn like fire. You pocket $160 in overtime wages, but you stagger home as dawn breaks, completely exhausted and having missed dinner with Erin and Chloe."
		"job":
			w.data.flags.job_accepted = true
			w.player().finances.cash += 60
			w.record("Erin attended a paid trial day for the job two towns away.", [who], "direct experience", false, "important", who)
			text = "You call the number you have been keeping to yourself. A trial day, , and a commute you will have to think about. The decision finally belongs to you."
		"neighbor":
			travel(w, "diner")
			var resident = "local_%d" % w.rng.randi_range(0, 20)
			travel(w, "diner", resident)
			var p: Dictionary = w.data.characters[resident]
			text = p.name + " sits at the counter. "
			var memories: Array = w.knowledge_for(resident)
			if not memories.is_empty():
				var k: Dictionary = memories.back()
				text += "The conversation turns to something they remember: ‘" + k.fact + "’"
				w.record(k.fact, [who], p.name + " relayed " + k.source, true, "working", resident)
			else:
				text += "You talk about the early frost and the diner’s broken heater. They ask how you are. You do not have to explain everything."
			w.record(name + " shared a quiet conversation with " + p.name + ".", [who, resident], "routine", false, "working", who)
	if w.player().health < 25 and id != "doctor":
		return setup_danger(w, "medical", text + "\n\nThe pain is getting worse. Standing takes more effort than it should.")
	return text

func setup_danger(w, kind: String, prefix: String) -> String:
	w.data.scene = "danger"
	w.data.flags.hazard = kind
	var warnings = {
		"industrial": "The heavy conveyor drive jerks violently against its warped steel housing, pinch rollers grinding in a blur of friction. Reaching your hands into the mechanism while exhausted will crush your arm into shredded pulp.",
		"road": "The two-lane county road drops off steeply into a rocky ditch with no guardrail. nodding off behind the wheel at 55 mph means tearing through the guard trees into the ravine.",
		"fire": "Thick, blinding black smoke rolls under the archive door, carrying the acrid stench of burning wiring. Pushing into the blazing room risks getting trapped in an oxygen-starved flashover.",
		"electrical": "Standing water pools across the concrete around a split 480V conduit, sending blinding blue sparks sizzling into the wet floor. Touching the metal frame will deliver a lethal cardiac shock.",
		"fall": "The rusted service ladder shudders and squeals under your boots. The top landing is forty feet above solid concrete, and the wall anchors are pulling out of the crumbling mortar.",
		"chemical": "An unlabelled drum leaks corrosive solvent across the unventilated room, filling the air with fumes that instantly sear your throat, bronchial tubes, and eyes.",
		"collapse": "The storage rack bows outward into the aisle, carrying tons of raw iron billets. Its structural bolts are shearing with deafening gunshot cracks.",
		"medical": "Your body is trembling violently from neglected trauma, blood loss, and shock. Pushing through without emergency care could trigger fatal circulatory collapse."
	}
	return prefix + "\n\n" + warnings[kind] + "\n\nEvery survival instinct screams at you to step back."

func danger(w, id: String) -> String:
	w.data.scene = "town"
	if id != "risk":
		if w.data.flags.hazard == "medical":
			travel(w, "hospital")
			w.player().health = mini(100, int(w.player().health) + 40)
		return "You swallow your pride, throw yourself backward clear of the hazard, and call for emergency assistance. Help takes time to arrive, but it does arrive. There is no prize for pretending you could handle it alone."
	var kind: String = w.data.flags.hazard
	var roll: float = w.rng.randf()
	var damage = w.rng.randi_range(25, 65)
	if roll < 0.24:
		damage = 120
	w.player().health = maxi(0, int(w.player().health) - damage)
	w.record(w.player().name + " was injured in a " + kind + " incident after proceeding despite the hazard.", w.witnesses(w.player().location), "direct observation", false, "important", w.data.player)
	w.data.flags.last_hazard = kind
	if w.player().health <= 0:
		return "Disaster strikes in a brutal fraction of a second. Flesh tears, bone shatters, and searing agony consumes your vision before plunging into total blackness.\n\nFor a moment you think you can still get clear. Then the moment is gone.\n\nThe town does not stop with you."
	return "Agony explodes through your nervous system as the trap violently snaps shut. You stagger backward, vomiting from shock and clutching your bleeding, battered body.\n\nIt happens faster than you expected. You get clear, hurt and shaking. Your body will carry this decision longer than the scene lasts."
