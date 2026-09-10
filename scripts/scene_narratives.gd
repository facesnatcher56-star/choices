extends RefCounted
## Authored narrative resolutions and sensory descriptions for story scenes and hazards.

func travel(w, destination: String, other: String = "") -> void:
	w.player().location = destination
	if not other.is_empty() and w.data.characters[other].alive:
		w.data.characters[other].location = destination

func accident(w, id: String) -> String:
	var text = ""
	match id:
		"stop":
			w.data.flags.power_off = true
			w.data.flags.quick_help = true
			w.data.characters.nate.health = 46
			text = "You throw your full weight into the mushroom emergency stop. With a dying hydraulic groan, the forty-ton press freezes in place. You scream for Luis to dial 911 while you drop to the concrete, tearing off your work shirt to pack the wound and stem the arterial bleeding until sirens echo outside."
		"ambulance":
			w.data.flags.quick_help = true
			w.data.characters.nate.health = 48
			text = "You drop straight to your knees on the oil-slicked floor, yelling for Luis to cut the breaker as you press both hands hard into Nate's torn arm to slow the bleed. Luis hits the cutoff just before the machine can shudder again. The dispatcher's voice crackles on speakerphone while you hold pressure until the paramedics burst through the fire doors."
		"call_luis":
			w.data.flags.quick_help = true
			w.data.flags.power_off = true
			w.data.characters.nate.health = 48
			text = "Luis calls emergency dispatch while you kill the machine breaker and clear the floor. You drop beside Nate and pack his torn arm until the paramedics take over. Splitting the response keeps everyone moving and buys Nate precious minutes."
	w.data.flags.accident = true
	w.record("Nate was taken to St. Anne’s Hospital after the machine accident.", ["daniel", "harold", "luis"], "direct observation", false, "important", "nate")
	w.data.characters.nate.location = "hospital"
	w.data.scene = "pressure"
	return text + "\n\nParamedics wheel Nate out through the slush under screaming sirens, his blood leaving dark speckles across the threshold. After the bay doors rattle shut, Harold Voss catches you against the steel locker bank by the time clock. His collar is dark with sour sweat, his thumb frantically clicking a silver ballpoint pen. He steps into your space, smelling of stale coffee and panic:\n\n‘We need to be consistent on this, Daniel. You checked that guard on your pre-shift walkthrough. It looked normal. That’s all anyone needs to hear. You back the plant, and the plant backs you. We start throwing fault around, corporate pulls the stamping contract and thirty families are on the street by Friday.’"

func pressure(w, id: String) -> String:
	var text = ""
	var witnesses: Array = ["daniel", "harold"]
	match id:
		"photo":
			w.data.flags.photo = true
			w.data.objects.photo = {"owner": "daniel", "location": "daniel", "condition": "original", "history": []}
			w.player().possessions.append("photo")
			w.record("Daniel photographed the wire holding the guard open after the ambulance departed.", ["daniel"], "direct observation", false, "important", "daniel")
			text = "While Harold turns his back and ducks into the glass supervisor booth to dig through filing cabinets for incident paperwork, you step quickly across the oil-slicked floor back to Line 4. The forty-ton press sits dead in the sodium glare. With adrenaline buzzing in your ears, you drop to one knee and frame three sharp photos: the stiff copper wire twisted around the safety interlock, the bypassed micro-switch, and the serial plate on the press housing. The timestamp burns into your phone’s memory. As Harold's heavy work boots crunch back across the concrete, your phone is already buried deep in your coat pocket."
		"agree":
			w.data.flags.promised = true
			w.relationship("harold", "daniel", "trust", 18)
			text = "You swallow down the bitter bile in your throat and give Harold a slow, compliant nod. Harold lets out a shuddering, ragged breath, his shoulders dropping two inches. He claps a clammy, heavy palm onto your shoulder with forced warmth: ‘Good man, Daniel. I knew you were solid. When the hammer falls, you find out who stands with the line.’ His eyes dart away from yours, fixating on the floorboards: ‘Keep your head down and let me handle the paperwork. I won't forget this on the next promotion cycle.’ You protected your paycheck for now, but your name is bound to a lie."
		"refuse":
			w.relationship("harold", "daniel", "trust", -20)
			w.relationship("harold", "daniel", "resentment", 20)
			text = "You meet Harold’s bloodshot eyes and tell him straight: you will write an honest statement about what you found on Line 4. Harold’s jaw locks like rusted iron. The nervous tremor in his hands instantly freezes into cold, calculated hostility. He leans forward until you can smell the tobacco on his teeth: ‘You want to be a hero, Daniel? Heroes don’t have a mortgage. Heroes don’t buy groceries for a fifteen-year-old girl. You put pen to paper blaming Mercer Works, and you’ll be blacklisted from every machine shop in this county. You remember whose signature signs off on your hourly pay before you blow your life apart.’"
		"defer":
			text = "You show Harold your trembling, grease-blackened hands. ‘My hands are shaking, Harold. I just dragged my friend out from under forty tons of steel. I need five minutes to splash cold water on my face before I write anything.’ Harold’s jaw twitches with naked annoyance. He glances down at his watch, tapping the scratched glass with a nicotine-stained fingernail: ‘Five minutes, Daniel. Not six. The hospital will log the arrival, and corporate wants the preliminary form faxed before daybreak. Take your breath, then get your head on straight.’"
		"witness":
			witnesses.append("luis")
			w.data.flags.luis_witness = true
			w.relationship("luis", "daniel", "trust", 12)
			text = "Instead of letting Harold corner you alone in the shadows, you turn toward the open bay and call out: ‘Luis! Bring that spill kit over here!’ Luis Ortega steps into the harsh light, his forearms stained with Nate’s blood, his eyes wide and vigilant. Harold flushes a dark, furious red, his throat clicking audibly as he swallows his demands. The aggressive bullying collapses into a tight, strained grimace: ‘Just making sure Daniel’s timeline is clear, Luis. Good work on the tourniquet.’ Harold glares at you with quiet venom, but with Luis standing shoulder-to-shoulder with you, he cannot force your hand."
		"record":
			w.data.flags.recording = true
			w.relationship("harold", "daniel", "trust", -25)
			text = "You quietly thumb the side button of your phone inside your jacket, letting the voice recorder roll before you answer. You ask Harold to repeat what he expects you to put in the report. Harold leans in close, his voice a hurried, sweating hiss: ‘You write that the guard was inspected and operational! If the state red-tags Line 4, corporate padlocks the front gates. Thirty guys lose their livelihood. Say the guard looked normal during your check.’ The microphone picks up every trembling syllable, every rasping intake of breath. You nod noncommittally, keeping your hands deep in your pockets."
	w.record("Harold asked Daniel to say the guard looked normal; Daniel chose to " + {"agree": "agree", "refuse": "refuse", "witness": "bring Luis in", "record": "record the exchange", "photo": "photograph the bypassed guard", "defer": "defer an answer"}[id] + ".", witnesses, "direct conversation", false, "important", "daniel")
	w.data.intentions.append({"actor": "harold", "action": "review_log", "due": w.data.minute + 240, "why": "Protect the production contract after a reportable accident", "status": "pending"})
	w.data.scene = "statement"
	return text + "\n\nHarold slaps the three-page employer incident clipboard down on the supervisor’s metal desk, shoving a ballpoint pen into your palm. ‘Your account. In ink. Before you clock out.’\n\nThe plant is silent now except for the low hum of transformer units. The safety agency will receive this document in the morning; nobody from that office is here tonight. What you write now will be the official narrative they read first."

func statement(w, id: String) -> String:
	var text = ""
	var account = ""
	match id:
		"lie":
			w.data.flags.lied = true
			account = "Daniel wrote that the guard looked normal when he checked it."
			w.record("Daniel knowingly gave a misleading account of the guard.", ["daniel"], "private intention", false, "important", "daniel")
			text = "You grip the pen and fill out the narrative box: pre-shift walkthrough conducted at 22:00, safety guard fully operational, interlocks responsive, no anomalies observed. You sign your legal name at the bottom. Harold stands right behind your shoulder, watching every ink stroke with eagle eyes. The second you lift the pen, he snatches the clipboard, blowing softly across the wet ink with a satisfied grunt. ‘Smart man, Daniel. You protected the shop.’ There is no state inspector here tonight to challenge it, but your name is etched into the lie."
		"blame":
			w.data.flags.blamed = true
			account = "Daniel suggested Nate bypassed the guard; he provided no eyewitness evidence."
			text = "Your hand shakes as you write down the words that will haunt you: Nate Bell was working at an aggressive piece-rate speed; possible operator modification of safety gate to bypass cycle delay. You leave the eyewitness line blank. You got Nate this job on your personal word; now, while he lies on an operating table having steel slivers pulled from his muscle, you have shifted the blame onto his empty post. Harold reads the form, nodding grimly: ‘A damn shame when young guys get reckless. But the truth has to be documented.’"
		"delay":
			w.data.flags.delayed_statement = true
			text = "You fill out the objective details—shift time, machine ID, emergency dispatch arrival—but across the large narrative box you write in heavy block letters: DETAILED STATEMENT DEFERRED PENDING CLEARANCE OF ACUTE SHOCK AND MEDICAL TRAUMA. Harold’s eyebrows knit together into a furious scowl. He taps the metal desk with his wedding ring: ‘This looks evasive, Daniel. Corporate wants closure, not question marks.’ ‘I'm shaken up, Harold. You want a legal statement, you give me time to process it.’ Harold scowls, but state rules require the severe-injury notification within eight hours, and he has to file the paper with your pending note attached."
		_:
			w.data.flags.honest = true
			w.data.flags.statement_careful = true
			account = "Daniel reported finding the guard bypassed and did not see who did it."
			text = "You write down the exact sequence of events without hedging: found Nate on the concrete beneath Line 4; observed heavy copper wire holding the safety guard interlock wide open; machine actively cycling; emergency stop triggered; origin of wire unknown. You attribute nothing you did not observe firsthand."
			if w.flag("photo"):
				w.data.flags.report_photo_attached = true
				text += " You staple a printed thumbnail of the bypass wire photograph directly to the form, preserving the digital original on your phone."
			text += "\n\nHarold snatches the board, scanning your words as his face turns ashen. His knuckles go white against the clip: ‘You just invited a full OSHA inquiry into Mercer Works, Daniel. I hope your high horse keeps your family warm this winter.’"
	if not account.is_empty():
		w.data.flags.initial_account = account
		w.data.flags.statement_completed = true
		w.record(account, ["daniel"], "employer incident form", id in ["lie", "blame"], "important", "daniel")
	w.data.flags.report_pending = true
	w.player().location = "home"
	w.data.scene = "homecoming"
	return text + "\n\nThe employer's report will enter the state safety review queue when offices open. Nobody is reviewing it at three in the morning.\n\nYour truck's dashboard clock reads %02d:%02d when you kill the engine in the gravel driveway. The streets outside are dark and empty. In the kitchen window, the pale yellow bulb is still on. Erin, your wife, is sitting at the small laminate table. You once planned to leave Briar Glen together before mortgages and promotions anchored you here. As you step through the back door, she spots the dark smear of oil and blood on your cuff before she even checks the clock.\n\n‘You said you'd be back before two, Daniel. What happened on shift?’" % [int(w.data.minute / 60) % 24, int(w.data.minute) % 60]

func homecoming(w, id: String) -> String:
	var text = ""
	match id:
		"tell":
			w.data.flags.told_erin = true
			w.relationship("erin", "daniel", "trust", 12)
			w.record("Daniel told Erin about Nate’s accident and Harold’s request.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
			text = "You pull out the vinyl chair opposite Erin and sit down. In a low, halting whisper so you don't wake Chloe down the hall, you tell her everything: the hydraulic scream of Line 4, Nate's mangled arm, packing the wound with your shirt, and Harold cornering you by the time clock demanding a clean cover-up. Erin listens without interrupting, her knuckles turning white around her ceramic tea mug. Her cardigan is pulled tight across her chest against the draft.\n\n‘Harold Voss,’ she says, her voice trembling with quiet fury. ‘He thinks he owns this town. Daniel, I can handle living broke. I can handle driving a truck with a dying alternator and wearing two sweaters indoors. What I cannot handle is finding out from the morning paper that my husband signed away his soul to cover for Mercer Works.’\n\nShe taps a red final-notice envelope on the table. ‘Your brother Matt called twice while you were on the floor. His delivery van broke down on route 9 again. He was begging for a loan. I told him we’re two weeks behind on the heating bill.’"
			if w.flag("lied"):
				w.record("Daniel admitted to Erin that he knowingly misled the incident report.", ["daniel", "erin"], "Daniel’s admission", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", -18)
				text += "\n\nWhen you admit that you already signed Harold's dishonest incident report to protect your paycheck, Erin recoils as if slapped, pushing her mug away across the table. Her eyes fill with tears of betrayal and fear: ‘You signed it?! An official state injury form?! Daniel... Nate could lose that arm. If you lied on company paper, you need to walk into Investigator Cole's office tomorrow morning and recant before Harold buries you with it.’"
		"partial":
			w.record("Daniel told Erin only that Nate was injured at work.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
			text = "You tell her Nate got caught in a machine press and had to be rushed to St. Anne’s, but you bury Harold’s threats and the incident form in silence. Erin watches your throat as you swallow, her eyes searching your face for the pieces you're holding back. ‘Is he going to make it, Daniel?’ ‘The surgeons took him right into the trauma bay,’ you answer quietly. Erin pushes a scrap of notebook paper across the table. ‘Your brother Matt called twice while you were gone. His courier van died on route 9 again. He was begging for money. I told him our card was declined at the grocery yesterday.’"
		"hide":
			w.record("Daniel said he was late because of a difficult shift.", ["daniel", "erin"], "Daniel’s account", true, "important", "daniel")
			w.relationship("erin", "daniel", "trust", -4)
			text = "You step straight to the kitchen sink, turning on the hot water to scrub the black grease and copper dust until your hands are raw red. You tell her an overhaul on the stamping die ran three hours late. Erin stands in the kitchen doorway, arms folded tightly. She looks at your stiff posture, then down at the dark stain on your boot. She doesn't yell; after twelve years of marriage, she knows your tells intimately. Her silence is heavier than an accusation: ‘An overhaul. Right.’ She lets out a tired, defeated sigh. ‘Your brother Matt called at one in the morning. His van broke down on route 9. He was hoping you could bail him out. I told him you were busy.’"
		"sleep":
			w.player().fatigue = 10
			w.player().conditions.erase("exhausted")
			w.player().health = mini(100, w.player().health + 8)
			text = "You drop your face into your trembling hands, utterly spent. ‘Erin, please. I'm in shock. I can't put words together tonight.’ Erin looks at the exhaustion carved into your features. She softens, stepping behind you and resting a warm, calloused hand against the back of your neck. ‘Tomorrow, then,’ she whispers. ‘Get some sleep before you collapse. We'll deal with the morning when it gets here.’"
	w.data.scene = "town"
	w.data.flags["matt_called"] = true
	var hour = int(w.data.minute / 60) % 24
	var light = "The streets outside are dark." if hour < 6 or hour >= 18 else ("Pale November light reaches the kitchen window." if hour < 9 else "Daylight lies across the kitchen table.")
	return text + "\n\n" + light + " Your shift is over. The rest of this is not."

func town(w, id: String) -> String:
	var who: String = w.data.player
	var name: String = w.player().name
	var day = int(w.data.minute / 1440)
	var text = ""
	if id == "wait_open":
		var clock = int(w.data.minute) % 1440
		if clock >= 5 * 60 and clock < 11 * 60:
			return "You turn in and let exhaustion pull you under. When you wake, gray morning light is filtering through the blinds. " + preload("res://scripts/town_schedule.gd").stamp(w.data.minute) + ": the town is beginning to stir."
		else:
			return "You take a quiet break to rest your body and clear your head. By " + preload("res://scripts/town_schedule.gd").stamp(w.data.minute) + ", the quiet hours have passed."
	if id.begins_with("travel_"):
		travel(w, id.trim_prefix("travel_"))
		return "You arrive at " + str(w.data.locations[w.player().location]) + ". There is time to decide what to do next."
	match id:
		"visit":
			travel(w, "hospital")
			w.relationship("nate", who, "trust", 6)
			w.record(name + " visited Nate during his recovery.", [who, "nate"] if w.data.characters.nate.health >= 40 else [who], "hospital visit", false, "important", who)
			if w.data.characters.nate.health < 40:
				text = "St. Anne’s trauma floor smells of harsh iodine and lemon disinfectant. Nate is unconscious in Room 314 beneath a heavy gray blanket, his right arm elevated in an aluminum suspension cradle and swathed in thick white gauze. An automated IV pump hums beside the bed, dosing morphine into his wrist. The charge nurse speaks in a hushed murmur from the door: ‘Tendons were severed cleanly, but the vascular surgeon managed to reattach the arterial flow. He won’t be awake for hours.’ On the wall, a muted television flickers with personal injury lawyer commercials."
			elif w.knows("nate", "suggested Nate"):
				text = "Nate is propped upright against three pillows, his skin waxy and gray. When you walk in, his jaw clenches so hard his temple pulses. His uninjured left hand grips the plastic bed rail until his knuckles blanch white. ‘Cole told me what you suggested on that incident form, Daniel,’ Nate whispers, his voice rasping from the intubation tube. ‘You wrote that I bypassed the guard to hit piece-rate? I took that graveyard shift because you swore on your family’s name the plant was safe. You stood five feet away while the press crushed my arm, and now you’re hanging me out to dry so Harold Voss doesn't dock your bonus.’ He turns his face toward the rain-streaked window and refuses to say another word."
			else:
				text = "Nate winces sharply as a spasm of phantom nerve pain shoots down his elevated forearm. Dried blood is still caked beneath his fingernails. ‘I keep replaying the sound in my head, Daniel,’ he whispers, his breath hitching. ‘The hydraulic valve hiss... the clatter of the sheet feed. I don’t remember seeing any wire on that guard. But Harold... Harold kept whispering to the paramedics while they were loading the stretcher that it was operator error. Why would Harold say that before the machine was even locked out?’ He looks at you with raw, searching eyes, begging for the truth."
				w.record("Nate says he cannot remember the guard immediately before the accident.", [who, "nate"], "Nate’s recollection", true, "important", "nate")
		"family":
			travel(w, "home", "erin")
			w.relationship("erin", who, "affection", 5)
			if who == "daniel" and w.knows("erin", "knowingly misled"):
				text = "Erin sits at the kitchen table with the household ledger, her pencil poised over the grocery line. When the kitchen door clicks, she looks up with dark circles under her eyes. ‘Have you been to the county safety station, Daniel? Did you correct what you wrote on Harold’s form?’"
				if w.flag("corrected"):
					text += " You tell her about meeting Cole and submitting the formal retraction. Erin lets out a long, trembling breath, her shoulders sagging as she reaches across the table to cover your hand with hers. ‘Thank God. We may lose the shift pay, Daniel, but at least we can look Nate in the eye.’"
					w.record(name + " told Erin the statement was corrected.", [who, "erin"], "direct conversation", false, "important", who)
			elif w.knows("erin", "Nate"):
				text = "Erin is folding clean laundry into a wicker basket, her movements tight and mechanical. ‘I saw Nate's sister at the market this morning,’ she says quietly, without looking up. ‘She said the doctors are still trying to save his fingers. Daniel... people at church are saying Mercer Works might shut down if the state finds safety violations. What happens to our mortgage if the plant locks the gates?’"
			else:
				text = "Erin is checking over Chloe’s school schedule, her cardigan pulled tight against the draft. ‘The heating oil delivery is scheduled for Thursday, Daniel. If we don’t have eighty dollars by Wednesday afternoon, they shut the line off.’ She pauses, watching your eyes. ‘You’ve been quiet since you came home from the plant. Is there something going on at Mercer Works that you aren't telling me?’"
			w.record(name + " spent time with Erin at home.", [who, "erin"], "routine", false, "working", who)
		"investigate":
			travel(w, "station", "cole")
			if w.flag("photo") and who == "daniel" and not w.flag("evidence_shared"):
				w.data.flags.evidence_shared = true
				w.record("Cole received Daniel’s photograph of the bypassed guard.", [who, "cole"], "photograph", false, "important", who)
				text = "Investigator Cole takes your phone and examines the high-resolution photo under his desk lamp. He zooms in on the copper wire twisted around the micro-switch, his eyes narrowing behind wire-rimmed spectacles. ‘Look at the twist on the copper,’ Cole notes calmly, tapping the screen with a mechanical pencil. ‘These aren't frayed ends. Someone used eight-inch linesman pliers to pinch the interlock closed. That’s deliberate bypass, not vibration wear. Keep the digital original safe, Daniel; this just became the centerpiece of our inquiry.’"
			elif w.knows(who, "maintenance log") and not w.flag("log_shared"):
				w.data.flags.log_shared = true
				w.record(name + " shared the maintenance log findings with Cole.", [who, "cole"], "document disclosure", false, "important", who)
				text = "Cole enters your detailed description of the maintenance book into his case notes. ‘A blank line where a pre-shift safety sign-off should be suggests supervisory negligence before Nate ever powered on Line 4. If Harold retroactively filled in that line after the accident, that moves this from an administrative violation to document tampering.’"
			elif w.flag("case_open"):
				text = "Cole gestures for you to sit across from his steel desk. A thick manila folder labeled *Mercer Works — Stamping Incident 11-04* lies open between you. ‘We have the mechanical logs, the EMS timeline, and Harold Voss’s initial filing. What we need is the human sequence: who was in the bay between 21:30 and 02:00, and who had access to the maintenance cage.’"
			else:
				text = "Investigator Cole listens with the neutral, impassive patience of a career bureaucrat. He writes in shorthand on a yellow legal pad, pausing deliberately between questions to let the silence sit in the air. ‘In these investigations, people always try to tell me what they think happened. I don't deal in theories, Daniel. I deal in physical switches, signed inspection books, and verified timestamps.’"
			text += " Cole watches your posture and eye contact with razor focus, cataloging every hesitation as he notes your words."
			w.record(name + " met Cole to discuss the investigation.", [who, "cole"], "direct conversation", false, "working", who)
			if who == "daniel" and w.flag("delayed_statement") and not w.flag("statement_completed"):
				w.data.flags.statement_completed = true
				w.data.flags.honest = true
				w.record("Daniel supplied his deferred statement: he saw the bypass but not who installed it.", [who, "cole"], "signed statement", false, "important", who)
				text += " You pull out the formal statement you deferred overnight, handing over an unhedged, honest account of finding the bypassed wire on Line 4 without pointing unverified fingers."
		"submit_recording":
			travel(w, "station", "cole")
			w.data.flags.recording_shared = true
			w.record("Cole received Daniel's voice memo of Harold ordering him to stop recording.", [who, "cole"], "voice recording", false, "important", "harold")
			text = "Cole plugs your phone into his desktop speakers and presses play. Harold’s hurried, sweating voice crackles into the room: *‘We need to be consistent... thirty families on the street by Friday!’* Cole leans back in his swivel chair, his pen stopping in mid-air. He looks across the desk at you with a sharp, sober nod: ‘That is direct supervisory coercion during an active industrial casualty. It doesn't prove who twisted the wire, but it destroys Harold’s credibility before he even sits in this chair.’"
		"rest":
			travel(w, "home")
			w.player().fatigue = 8
			w.player().conditions.erase("exhausted")
			w.player().health = mini(100, int(w.player().health) + 12)
			text = "You wash the shop grease from your face, turn your phone face down on the bedside table, and pull the heavy quilt up to your chin. Exhaustion pulls you into a deep, uninterrupted sleep, letting your body heal and the adrenaline drain away. When you wake, cold morning sunlight is cutting across the floorboards."
		"luis":
			travel(w, "diner", "luis")
			if w.data.relationships["luis:" + who].trust >= 50:
				w.record("Luis says the maintenance log had a blank inspection line before the accident.", [who, "luis"], "Luis’s recollection", true, "important", "luis")
				text = "Luis keeps his baseball cap pulled low, his dark eyes scanning the counter every time the diner bell chimes. He leans across the table, speaking in a low, intense murmur: ‘Listen to me, Daniel. At 21:45, before Nate clocked in, I went into the supervisor booth to grab spare earplugs. Harold had the red maintenance binder open with a pencil eraser in his hand. Line 4's Friday inspection was totally blank. He saw me and slammed the book shut. Harold knew that press had a malfunctioning interlock before Nate ever touched the foot pedal.’"
			else:
				text = "Luis cradles his diner mug in two grease-stained hands, keeping his gaze firmly fixed on the black coffee. He answers your questions in cautious monosyllables, talking about overtime and weekend deer hunting. He's terrified of being blacklisted or fired, and he doesn't trust you enough yet to put his neck on the chopping block."
				w.relationship("luis", who, "trust", 5)
		"work":
			travel(w, "plant")
			w.data.flags["worked_" + who] = int(w.data.flags.get("action_start_day", day))
			w.player().finances.cash += 112
			text = "Seven grueling hours under buzzing fluorescent tubes on the secondary assembly line. You earn $112 in hard cash. Nobody speaks above a whisper; every worker on the floor is eyeing the yellow caution tape roping off Line 4 with cold dread."
			w.record(name + " completed a paid shift at the plant.", w.witnesses("plant"), "routine", false, "working", who)
			if w.player().fatigue > 78 and day >= 1:
				return setup_danger(w, "industrial", text + " Your reflexes are shot and your hands are trembling slower than the steel feeder.")
		"records":
			travel(w, "plant")
			w.data.flags["records_" + who] = true
			var condition: String = w.data.objects.maintenance_log.condition
			w.record(name + " saw the maintenance log: " + condition + ".", [who], "document inspection", false, "important", who)
			text = "You slip into the supervisor's glass booth while Harold is away from his desk and pull the heavy red maintenance ledger from the metal shelf. " + ("The pre-shift inspection line for Line 4 is completely blank—no supervisor signature, no safety stamp. You pull out your phone and snap two clear photos of the blank page before returning the ledger." if condition == "intact" else "The pre-shift inspection line has been freshly filled in with fresh blue ink, claiming the guard was certified at 21:00. Under close inspection, you can see the faint indentations of erased pencil marks beneath the ink.")
		"bills":
			w.data.flags["paid_bills_day"] = day
			var current_cash = int(w.player().finances.get("cash", 0))
			if current_cash >= 80:
				w.player().finances.cash -= 80
				text = "You sit down at the kitchen counter and count out four crisp twenty-dollar bills to clear the $80 overdue heating notice. The furnace stays on for another month, but the stack of grocery money in your wallet shrinks to almost nothing."
			else:
				w.player().finances.cash = 0
				w.player().finances.debt += (80 - current_cash)
				text = "You scrape together every dollar bill in your wallet ($" + str(current_cash) + ") and apply the rest to your outstanding utility debt. The gas company agrees to keep the heat flowing, but the shortfall hangs over your head."
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
		"bills_credit":
			w.data.flags["paid_bills_day"] = day
			w.player().finances.debt += 80
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
			w.record(name + " charged the $80 heating bill to the credit card.", [who], "credit card payment", false, "important", who)
			text = "You call the automated utility hotline and punch in your credit card numbers to clear the $80 heating bill. A mechanical tone confirms payment. The furnace stays running, but your card balance ticks up to $" + str(w.player().finances.debt) + "."
		"truck_diy":
			travel(w, "home")
			w.data.flags.truck_fixed = true
			w.player().finances.cash = maxi(0, int(w.player().finances.cash) - 35)
			w.player().fatigue = mini(100, int(w.player().fatigue) + 35)
			if not w.player().conditions.has("exhausted"):
				w.player().conditions.append("exhausted")
			w.record(name + " spent the afternoon replacing the truck alternator with a junkyard pull.", [who], "diy repair", false, "working", who)
			text = "You spend three freezing hours on your back in the gravel driveway beneath the truck's rusted chassis, a flashlight clamped between your teeth. For $35 in scrapyard parts you save over a hundred dollars, but your knuckles are skinned raw and your lower back aches with leaden exhaustion."
		"truck_shop":
			travel(w, "road")
			w.data.flags.truck_fixed = true
			var cost = 140
			if w.player().finances.cash >= cost:
				w.player().finances.cash -= cost
				text = "Jim at the county garage puts the truck on the hydraulic lift and has a remanufactured alternator installed in an hour. You count out $140 in cash. It leaves your wallet hurting, but your truck is roadworthy and your afternoon is saved."
			else:
				w.player().finances.debt += cost
				text = "Jim swipes your credit card for the $140 repair. ‘Bearing was about thirty miles from seizing and throwing the serpentine belt,’ Jim says, wiping his hands. The truck is safe, but your debt increases."
			w.record(name + " paid for professional alternator replacement at the garage.", [who], "mechanic repair", false, "working", who)
		"matt":
			travel(w, "diner", "matt")
			text = "Your twenty-eight-year-old brother Matt is slumped in a corner vinyl booth at Juniper Diner, his eyes bloodshot and smelling of cheap cigarettes. An auto shop repair estimate sits on the laminate table like a death sentence. When you sit down, he laughs nervously and scratches the back of his neck, unable to look you in the eye: ‘Hey, Dan. Look... I know you’re dealing with hell at the plant. But the starter on my delivery van died cold on route 9. The tow driver took fifty bucks just to drag it here. If I can’t get parts by tomorrow, the courier firm cuts me loose.’"
			w.relationship("matt", who, "affection", 6)
			w.record("Matt told " + name + " his delivery van needs repairs.", [who, "matt"], "direct conversation", false, "working", "matt")
		"correct":
			travel(w, "station", "cole")
			w.data.flags.corrected = true
			w.data.flags["apology_" + who] = true
			w.record("Daniel corrected his misleading statement to Cole; the original remains on file.", [who, "cole"], "signed correction", false, "important", who)
			w.relationship("cole", who, "trust", -8)
			text = "Cole pulls Harold’s submitted incident report from the folder and lays a formal retraction addendum beside it. You write down the complete truth about the bypassed guard and Harold’s coercion, signing your name with a steady hand. Cole stamps the paper with a heavy, administrative thud. ‘Your original statement stays in the state archive, Daniel. But this signed correction strips Harold of his shield. We now have a formal inquiry into supervisor intimidation.’"
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
			w.data.flags["worked_" + who] = int(w.data.flags.get("action_start_day", day))
			w.player().finances.cash += 160
			w.player().fatigue = mini(100, int(w.player().fatigue) + 45)
			if not w.player().conditions.has("exhausted"):
				w.player().conditions.append("exhausted")
			w.relationship("erin", who, "resentment", 8)
			w.record(name + " worked an exhausting overnight double shift for $160 cash.", [who, "harold"], "overtime shift", false, "working", who)
			text = "Eight brutal hours hauling stamped steel until your forearms burn. You pocket $160 and finish the shift exhausted, still on the factory floor. Those hours could not be spent at home."
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
