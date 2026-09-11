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
			text = "You dropkick your entire body weight straight into the glowing red mushroom stop! The hydraulic ram screeches to an emergency halt with an explosive detonation of boiling steam and shredded metal shrapnel! You rip off your jacket, screaming for Luis to dial 911 while you slide across the oil slick, packing Nate's torn arm before secondary transformer lines explode!"
		"ambulance":
			w.data.flags.quick_help = true
			w.data.characters.nate.health = 48
			text = "You power-slide knees-first through a lake of hot hydraulic oil, screaming over the wailing air-raid sirens for Luis to kill the substation breaker! You clamp both hands onto Nate's mangled arm like an iron vise, arresting the arterial jet as secondary breaker banks pop like fireworks across the ceiling! Luis pulls the master disconnect just as the press throws blinding lightning arcs, and paramedics storm through the blast doors with a crash cart!"
		"call_luis":
			w.data.flags.quick_help = true
			w.data.flags.power_off = true
			w.data.characters.nate.health = 48
			text = "Luis calls emergency dispatch while you kill the machine breaker and dodge exploding pneumatic hoses! You dive beneath the smoking iron jaws, packing Nate's arm with raw adrenaline until paramedics storm the smoking bay. Splitting the response keeps everyone moving and buys Nate precious seconds before the press can cycle again."
	w.data.flags.accident = true
	w.record("Nate was taken to St. Anne’s Hospital after the machine accident.", ["daniel", "harold", "luis"], "direct observation", false, "important", "nate")
	w.data.characters.nate.location = "hospital"
	w.data.scene = "pressure"
	return text + "\n\nParamedics wheel Nate out through the slush under screaming sirens and flashing red strobes, his blood spraying across the icy tarmac. Black SUVs with tinted windows circle the main gate like vultures! The heavy steel blast doors slam shut, and Harold Voss corners you against the locker bank like a manic conspirator. He's sweating bullets, chugging cold quad-shot espresso, his knuckles white around a heavy steel crowbar:\n\n‘We need to be rock-solid on this, Daniel! Corporate doesn't just build brackets here—we've got off-the-books aerospace contracts and syndicate investors who will burn this zip code to the ground if inspectors start tearing apart Line 4! You say the guard looked pristine. You back the plant, or thirty families are dodging repo men and cartel hit squads by Friday!’"

func pressure(w, id: String) -> String:
	var text = ""
	var witnesses: Array = ["daniel", "harold"]
	match id:
		"photo":
			w.data.flags.photo = true
			w.data.objects.photo = {"owner": "daniel", "location": "daniel", "condition": "original", "history": []}
			w.player().possessions.append("photo")
			w.record("Daniel photographed the wire holding the guard open after the ambulance departed.", ["daniel"], "direct observation", false, "important", "daniel")
			text = "While Harold is frantically shredding manifests in the glass booth, you sprint back through the acrid chemical smoke to Line 4! The mammoth press sits hissing in the dark like a wounded dragon. You drop to one knee and snap three high-resolution photos: the braided military-grade copper wire cinched around the safety interlock, the bypassed micro-switch, and the serial plate stamped with classified defense contract markings. The digital evidence burns into your phone as Harold’s heavy boots come pounding back across the concrete."
		"agree":
			w.data.flags.promised = true
			w.relationship("harold", "daniel", "trust", 18)
			text = "You swallow the acid in your throat and give a tight nod. Harold exhales like a ruptured steam valve, laughing with wild, unhinged relief! He slaps you hard on the back: ‘My man! I knew you had ice in your veins, Daniel! Corporate pays six-figure hush money to men who keep their mouths shut! When this storm blows over, you and me are getting a massive piece of the syndicate pie!’"
		"refuse":
			w.relationship("harold", "daniel", "trust", -20)
			w.relationship("harold", "daniel", "resentment", 20)
			text = "You stare Harold down through the smoke and tell him flat out: you're writing the exact truth. Harold's bloodshot eyes bug out. He brandishes the crowbar, swinging it within inches of your jaw: ‘You want to be a hero, Mercer?! Heroes end up in shallow ditches out in the marsh! I've got cartel loan sharks breathing down my neck and corporate muscle thirty minutes away! You sign that paper, or you're signing your own death warrant!’"
		"defer":
			text = "You hold up both hands, trembling and black with grease and hydraulic oil. ‘My adrenaline is completely through the roof, Harold! I just wrestled a dying man out of an industrial meat grinder! Give me five minutes to splash cold water on my face or you'll get gibberish in ink!’ Harold slams his clipboard against the steel locker with a deafening bang: ‘Five minutes, Daniel! The hospital is logging the ambulance and corporate wants this report on the wire before sunrise! Splash your face, then get in line!’"
		"witness":
			witnesses.append("luis")
			w.data.flags.luis_witness = true
			w.relationship("luis", "daniel", "trust", 12)
			text = "You refuse to let Harold isolate you in the shadows. You cup your hands and bellow into the burning bay: ‘Luis! Grab the emergency spill kit and get over here now!’ Luis Ortega marches out of the haze holding a massive 24-inch pipe wrench in one fist, looking like an urban commando. Harold flushes an apoplectic purple, instantly choking down his threats behind a fake grin: ‘Just debriefing Daniel, Luis! Great work on the kill switch!’ With Luis standing beside you like an armed sentinel, Harold's intimidation evaporates into panicked sweating."
		"record":
			w.data.flags.recording = true
			w.relationship("harold", "daniel", "trust", -25)
			text = "You stealthily thumb the voice-memo hotkey inside your jacket, letting the microphone roll. You bait Harold into repeating his extortion on tape. Harold leans in, his breath reeking of espresso and terror: ‘You swear the guard was operational! If the feds shut Line 4, corporate triggers the panic clause! Thirty guys lose their jobs, and syndicate creditors start repossessing kneecaps! Say the guard looked factory-spec!’ The mic captures every frantic, incriminating syllable."
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
			text = "You grip the pen and sign the fraudulent declaration: pre-shift walkthrough conducted at 22:00, safety guard fully operational, interlocks responsive, no anomalies observed. Harold snatches the clipboard with a manic, triumphant grin, blowing softly across the wet ink. "
			if w.flag("promised"):
				text += "‘Smart man, Daniel! You kept your word. You protected the shop—and your neck.’"
			else:
				text += "‘Thought you were going to be a martyr, Daniel? Glad to see survival instincts won out. You protected the shop.’"
			text += " There is no state inspector here tonight to challenge it, but outside, your phone instantly buzzes with an anonymous encrypted text: *‘Smart move, Supervisor. Stay quiet and stay alive.’*"
		"blame":
			w.data.flags.blamed = true
			account = "Daniel suggested Nate bypassed the guard; he provided no eyewitness evidence."
			text = "Your hand shakes as you scrawl the betrayal into ink: Nate Bell operated at an aggressive piece-rate speed; possible unauthorized modification of safety interlocks to bypass cycle delay. You got Nate this job on your personal word; now you’ve fed him to corporate wolves while he lies in an emergency operating room. Harold nods with cold, predatory satisfaction: ‘The kid took the fall. A damn shame, but the plant keeps humming.’ A sickening wave of nausea washes over you as an icy draft whistles under the door."
		"delay":
			w.data.flags.delayed_statement = true
			text = "Across the large narrative box, you scrawl in bold black marker: STATEMENT DEFERRED PENDING CLEARANCE OF ACUTE TRAUMA AND FORENSIC DISCOVERY. Harold turns red enough to pop a gasket. He kicks a metal trash can across the office: ‘Are you insane, Daniel?! Corporate wants this file locked down, not an open invitation for federal bloodhounds!’ ‘State law gives me eight hours, Harold. Send your corporate lawyers if you don't like it.’ Harold curses violently, but the law ties his hands."
		_:
			w.data.flags.honest = true
			w.data.flags.statement_careful = true
			account = "Daniel reported finding the guard bypassed and did not see who did it."
			text = "You lay out the hard, explosive truth: found Nate trapped beneath Line 4; observed heavy copper wire intentionally rigged around the safety micro-switch; machine actively cycling; emergency stop triggered; culprit unknown. You attribute nothing you didn't see firsthand."
			if w.flag("photo"):
				w.data.flags.report_photo_attached = true
				text += " You staple a printed thumbnail of the bypass wire photograph directly to the form, preserving the digital original on your phone."
			if w.flag("promised"):
				text += "\n\nHarold snatches the board, his face turning an apoplectic purple. His knuckles crack against the metal: ‘You gave me your word, Daniel! You swore you'd protect the line, and now you hand me an unexploded bomb?! You just declared war on corporate!’"
			else:
				text += "\n\nHarold snatches the board, scanning your words as his jaw falls slack in shock: ‘You just lit the fuse on an absolute powder keg, Daniel. Corporate attorneys and federal marshals will rip this town apart!’"
	if not account.is_empty():
		w.data.flags.initial_account = account
		w.data.flags.statement_completed = true
		w.record(account, ["daniel"], "employer incident form", id in ["lie", "blame"], "important", "daniel")
	w.data.flags.report_pending = true
	w.player().location = "home"
	w.data.scene = "homecoming"
	return text + "\n\nThe employer's report will enter the state safety review queue when offices open. Nobody is reviewing it at three in the morning.\n\nYour truck's dashboard clock reads %02d:%02d when you kill the engine in the gravel driveway. The streets outside are dark and empty. In the kitchen window, the pale yellow bulb is still on. Erin, your wife, is sitting at the small laminate table. You once planned to leave Briar Glen together before mortgages and promotions anchored you here. As you step through the back door, she spots the dark smear of oil and blood on your cuff before she even checks the clock.\n\n‘You said you'd be back before two, Daniel. What happened on shift?’" % [int(w.data.minute / 60) % 24, int(w.data.minute) % 60]

func homecoming(w, id: String) -> String:
	var name: String = w.player().name
	var text = ""
	match id:
		"tell":
			w.data.flags.told_erin = true
			text = "You slam the deadbolts shut, drop into the chair across from Erin, and lay it out in a breathless rush: the 40-ton turbo press detonating, Nate crushed beneath the glowing die, electrical fire raining from the rafters, and Harold Voss threatening you with cartel hitmen and crowbars by the lockers."
			if w.flag("lied"):
				w.record("Daniel admitted to Erin that he knowingly misled the incident report.", ["daniel", "erin"], "Daniel’s admission", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", -16)
				text += " Your stomach turns to acid as you admit you signed Harold's cover-up walkthrough to protect your paycheck.\n\nErin leaps to her feet, kicking her chair backward with a crash: ‘You signed off on a corporate cover-up?! Daniel, federal marshals and cartel repo goons will breach this house before sunrise! You get to Investigator Cole and recant before Harold leaves our family holding the murder weapon!’"
			elif w.flag("blamed"):
				w.record("Daniel admitted to Erin that he blamed Nate on the incident report.", ["daniel", "erin"], "Daniel’s admission", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", -22)
				text += " Your stomach turns to ice as you confess the rest: you wrote on the state report that Nate was recklessly chasing speed and rigged the switch himself.\n\nErin stares at you as if a ghost just stepped into the kitchen. Her hands drop to the table, trembling with horror. ‘You blamed Nate Bell?!’ she whispers. ‘Daniel, you brought that kid into this town! He’s in trauma surgery fighting for his life, and you framed him to protect Harold Voss?! If federal inspectors get wind of this, they'll drag you out of this house in cuffs! You fix this tomorrow morning before Nate wakes up!’"
			elif w.flag("delayed_statement"):
				w.record("Daniel told Erin he deferred his incident statement.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", 8)
				text += " You tell her you refused to rubber-stamp Harold's lies, scrawling a formal medical delay across the narrative box.\n\nErin lets out a sharp whistle, nodding with fierce, breathless approval. ‘You bought us a few hours, Daniel, but Harold's corporate handlers don't take rain checks. By sunrise, suits in black sedans will be circling our block. We need to be ready for an all-out war before Investigator Cole opens his inquiry.’"
			else: # honest
				w.record(name + " told Erin the truth about reporting the bypassed guard.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
				w.relationship("erin", "daniel", "trust", 14)
				text += " You tell her you stood your ground: you filed an unvarnished, honest report documenting the rigged wire on Line 4."
				if w.flag("photo"):
					text += " You show her the high-res photo on your phone—the twisted copper wire and the classified contract stamp."
				text += "\n\nErin stares at the screen, her eyes blazing with electric intensity. ‘Holy hell, Daniel,’ she whispers, grabbing both of your hands with fierce pride. ‘You stood up to Voss! He's got cartel-backed deadlines on that line! They're going to come at our family with everything they have—repo squads, private investigators, blacklist threats. But God, Daniel... you didn't sell your soul. We barricade our lives and fight them together.’"
			text += "\n\nShe taps a police scanner chattering on the counter, where dispatch is tracking high-speed sirens. ‘Your brother Matt called twice while you were on the floor. His delivery van broke down on route 9 again. He was begging for a loan. I told him we’re two weeks behind on the heating bill.’"
		"partial":
			w.data.flags.told_erin = false
			w.record("Daniel told Erin only that Nate was injured at work.", ["daniel", "erin"], "Daniel’s disclosure", false, "important", "daniel")
			text = "You tell her Nate got caught in a catastrophic failure on Line 4 and was rushed to trauma surgery, but you keep Harold's manic conspiracy threats and the falsified papers to yourself. Erin studies your breathing, sensing the armed powder keg ticking behind your eyes.\n\n‘Is he going to survive, Daniel?’\n\n‘Surgeons are pulling steel out of his arm right now,’ you answer, your jaw clenched.\n\nErin checks the scanner radio nervously. ‘Something crazy is happening at that plant, Daniel... rumors on social media say federal marshals are en route.’ She pushes a torn envelope across the table. ‘Your brother Matt called twice while you were gone. His courier van died on route 9 again. He was begging for money. I told him our card was declined at the grocery yesterday.’"
		"hide":
			w.data.flags.told_erin = false
			w.record("Daniel said he was late because of a difficult shift.", ["daniel", "erin"], "Daniel’s account", true, "important", "daniel")
			w.relationship("erin", "daniel", "trust", -4)
			text = "You head straight to the sink, scrubbing black grease and copper dust until your knuckles burn. You claim a massive electrical blowout kept you trapped on the line. Erin leans against the doorframe, arms folded, watching you with laser focus. She notices the dried blood on your boot and the burner phone vibrating in your coat.\n\n‘An electrical blowout,’ she repeats, her voice razor-sharp. ‘Right. And that's why two state police cruisers just tore down route 9 with their sirens screaming?’ She shakes her head with bitter exhaustion. ‘Your brother Matt called at one in the morning. His van broke down on route 9. He was hoping you could bail him out. I told him you were busy.’"

	text += "\n\nOutside the kitchen window, the streets outside are dark and empty. The clock on the wall ticks past four in the morning. Exhaustion finally drags the fight out of you. You turn off the kitchen light and head down the dark hallway to bed, falling into a deep, dreamless sleep.\n\nWhen morning comes, pale daylight cuts across the bedroom floor. You wake at 08:30 AM. Down the hall, Chloe has already caught the bus to Briar Glen High, and a mechanical rooster is rolling into town announcing a foreclosure parade. Your body has rested. Reality apparently has not. Choose ENTER THE CHAOS to confront the parade, or pursue the plant crisis; both stories remember what you do."

	w.data.minute = 8 * 60 + 30
	w.player().fatigue = 8
	w.player().conditions.erase("exhausted")
	w.player().health = mini(100, int(w.player().health) + 8)
	w.data.flags["talked_family_day_0"] = true
	w.data.flags["matt_called"] = true
	w.data.flags["slept_homecoming"] = true
	w.data.scene = "town"
	w.player().location = "home"
	return text

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
				text = "St. Anne’s trauma ER is an absolute warzone: orderlies sprint past carrying blood bags, police radios scream from the hallway, and security guards wrestle an erratic patient off a crash cart. Nate lies unconscious in Room 314 beneath a foil emergency blanket, his right arm suspended in a titanium traction rig. An automated IV pump beeps frantically, flooding his veins with heavy painkillers. A nurse snaps: ‘Tendons were shredded to ribbons, but surgeons managed to reconnect the main arterial line. He's knocked out cold until morning.’"
			elif w.knows("nate", "suggested Nate"):
				text = "Nate is propped upright in bed, eyes blazing with furious adrenaline, monitors spiking beside his head. When you walk in, his knuckles turn white on the steel bed rail. ‘Cole told me what you suggested on that incident form, Daniel!’ Nate snarls, his voice scraping raw through his oxygen mask. ‘You told state inspectors I rigged the switch to hit piece-rate bonuses?! I took that graveyard suicide shift because you swore Mercer Works was legit! Forty tons of hydraulic iron mangled my arm, and you framed me to keep Harold Voss's syndicate happy?! Get the hell out of my room before I hit this emergency alarm!’"
			elif w.flag("honest"):
				text = "Nate is hooked to a dual-chamber IV rig, watching the evening news with razor-sharp intensity. When he spots you, a burst of manic, grateful relief hits his face. ‘Luis was just here, Dan!’ Nate rasps, grabbing your sleeve with his good arm. ‘He told me Voss ambushed you with corporate goons and you refused to sign their fraudulent walkthrough! You slapped the honest report on the table and blew the whistle on that rigged bypass wire! Voss has black-market contracts riding on Line 4... he’s going to come at you with a sledgehammer, Dan. But you saved my life and my family's name. I owe you forever.’"
			else:
				text = "Nate winces as a jolt of phantom nerve agony rocks his shoulders, his vitals monitor beeping in erratic double-time. Dried grease and copper filings are still under his nails. ‘My ears won't stop ringing with that hydraulic explosion, Dan,’ he whispers, eyes wide with adrenaline. ‘The press cycled on its own before I even touched the foot-trip! Voss was whispering to the paramedics while they dragged me out, trying to coach their police statements. Why would Voss claim operator error before the hazard team even cleared the bay?!’"
				w.record("Nate says he cannot remember the guard immediately before the accident.", [who, "nate"], "Nate’s recollection", true, "important", "nate")
		"family":
			travel(w, "home", "erin")
			w.relationship("erin", who, "affection", 5)
			if who == "daniel" and w.knows("erin", "knowingly misled"):
				text = "Erin is pacing the kitchen floor like a caged panther, shotgun shells and a stack of overdue bank notices sitting on the laminate table. The police scanner is squawking in the background. ‘Did you hit the county safety station, Daniel? Did you tear up that pack of lies you signed for Harold Voss?’"
				if w.flag("corrected"):
					text += " You show her the stamped retraction signed by Investigator Cole. Erin exhales a shaky, victorious breath, slamming the counter with fierce pride: ‘Damn right! Harold can send his repo thugs all he wants—our names are clean on the state record!’"
					w.record(name + " told Erin the statement was corrected.", [who, "erin"], "direct conversation", false, "important", who)
			elif who == "daniel" and w.knows("erin", "blamed Nate"):
				text = "Erin glares at you from the sink, a butcher knife gripped tightly in her hand as she chops vegetables with furious force. ‘I just ran into Nate's mother outside the pharmacy, Daniel,’ she says, her voice shaking with righteous fury. ‘Harold Voss's cronies are already plastering the diner with rumors that Nate was reckless! She asked me why my husband would throw her boy under the bus! How am I supposed to look our neighbors in the face?!’"
			elif who == "daniel" and (w.flag("hid_from_erin") or w.flag("partial_erin")):
				w.data.flags.told_erin = true
				w.data.flags.hid_from_erin = false
				w.data.flags.partial_erin = false
				text = "You pull the kitchen blinds shut and lay down the unvarnished reality: the 40-ton catastrophe, Harold’s syndicate panic, and the high-stakes battle over the official state safety filing.\n\n"
				if w.flag("honest"):
					w.relationship("erin", who, "trust", 12)
					w.record(name + " confessed the full truth to Erin: he stood up to Harold and reported the bypassed guard.", [who, "erin"], "Daniel’s disclosure", false, "important", who)
					text += "When you tell her you filed the unvarnished report documenting the illegal bypass wire, Erin grabs your collar and plants a fierce, breathless kiss on your cheek: ‘Hell yes, Daniel! Voss has federal inspectors breathing down his neck now! We might have to dodge his goons, but we’re taking him down together!’"
				elif w.flag("lied"):
					w.relationship("erin", who, "trust", -16)
					w.record("Daniel admitted to Erin that he knowingly misled the incident report.", ["daniel", "erin"], "Daniel’s admission", false, "important", who)
					text += "When you admit you signed Harold's whitewashed report, Erin knocks a mug off the counter, shattering it on the floor: ‘You signed off on a corporate cover-up?! Daniel, federal marshals will raid this house before the week is over! You get to Investigator Cole and recant before Harold leaves you holding the bag!’"
				elif w.flag("blamed"):
					w.relationship("erin", who, "trust", -20)
					w.record("Daniel admitted to Erin that he blamed Nate on the incident report.", ["daniel", "erin"], "Daniel’s admission", false, "important", who)
					text += "When you admit you scapegoated Nate on the official injury form, Erin recoils in pure disbelief: ‘You framed Nate Bell?! Daniel, have you lost your damn mind?! Nate’s lying in trauma surgery and you handed Voss the knife! Fix this right now or don't bother coming back through that door!’"
				else:
					w.relationship("erin", who, "trust", 6)
					w.record(name + " explained to Erin that he deferred his formal statement.", [who, "erin"], "Daniel’s disclosure", false, "important", who)
					text += "You tell her you bought time with a formal deferral. Erin nods grimly: ‘Smart move. You kept your head out of Voss's noose. Now we strike before his private investigators build a fake case against us.’"
			elif who == "daniel" and w.flag("told_erin") and w.flag("honest"):
				text = "Erin is loading a twelve-gauge shell into her father's vintage shotgun by the pantry, the scanner blaring county sheriff traffic. ‘Nate’s sister called from the clinic, Daniel,’ she says, grinning with fierce energy. ‘Word spread like wildfire through the shift crew that you told Voss to shove his bribe! The mill town is waking up, Dan. We’re not taking Voss's dirty racket lying down anymore.’"
			elif w.knows("erin", "Nate"):
				text = "Erin is tuning the kitchen radio between emergency broadcasts and local gossip. ‘Everyone in town is talking about Mercer Works, Daniel. Rumors say black SUVs with tinted windows were spotted outside the plant gates at dawn. If corporate pulls the plug on the contract, this whole valley goes up in smoke.’"
			else:
				var heating_paid = (w.data.flags.has("bills") and w.data.flags.bills.has("heating") and w.data.flags.bills.heating.status == "paid") or int(w.data.flags.get("paid_bills_day", -1)) >= 0
				if heating_paid:
					text = "Erin slams a paid utility slip onto the kitchen board. ‘At least the gas company won't cut the line while we fight off Voss's lawyers,’ she says, handing you a mug of scalding black coffee. ‘Now tell me what our next move is before Harold launches his counterstrike.’"
				else:
					text = "Erin taps an urgent red shutoff notice against the kitchen counter. ‘The utility company gave us till Wednesday to cough up the $80, Daniel, or they cut our heat in the middle of this freeze! Between your wild plant explosion and this overdue notice, our lives are turning into an action movie!’"
			w.record(name + " spent time with Erin at home.", [who, "erin"], "routine", false, "working", who)
		"investigate":
			travel(w, "station", "cole")
			if w.flag("photo") and who == "daniel" and not w.flag("evidence_shared"):
				w.data.flags.evidence_shared = true
				w.record("Cole received Daniel’s photograph of the bypassed guard.", [who, "cole"], "photograph", false, "important", who)
				text = "Investigator Cole slams your phone onto his tactical desk magnifier, his eyes wide behind heavy spectacles. ‘Look at the crimp on that 12-gauge copper wire!’ Cole whistles, slapping a yellow legal pad. ‘That’s not wear-and-tear—that’s an intentional hotwire job done with eight-inch linesman clippers! Voss’s defense just went up in smoke! This photo is prime federal dynamite, Daniel!’"
			elif w.flag("cage_searched") and not w.flag("cage_evidence_shared"):
				w.data.flags.cage_evidence_shared = true
				w.data.flags.evidence_shared = true
				w.record(name + " gave Cole photographs of the cut wire and linesman pliers found in the maintenance cage.", [who, "cole"], "physical evidence", false, "important", who)
				text = "Cole pulls the photos of the tool cage up on his dual monitors, grinning like an attack dog that caught the scent. ‘Look at those plier teeth—fresh copper filings and an identical 12-gauge insulation coil! This connects the tool cage directly to Line 4! We’ve got forensic ballistics on the wire cut! Harold Voss is cooked!’"
			elif w.knows(who, "maintenance log") and not w.flag("log_shared"):
				w.data.flags.log_shared = true
				w.record(name + " shared the maintenance log findings with Cole.", [who, "cole"], "document disclosure", false, "important", who)
				text = "Cole types furiously into the state terminal, slamming his fist onto the keyboard. ‘A blank pre-shift inspection line! If Voss doctored that log after Nate was loaded into the ambulance, that moves this straight from an administrative fine to a felony federal conspiracy! We’re impounding those books before sundown!’"
			elif w.flag("case_open"):
				text = "Cole’s office looks like an FBI command center: wall-to-wall whiteboards covered in factory floor blueprints, shift rosters, and red yarn connecting Harold Voss to shell companies. Cole turns around holding an evidence bag: ‘Daniel! We’ve got phone records showing Voss placed three frantic calls to corporate headquarters at two in the morning. Give me the rest of the puzzle!’"
			elif who == "daniel" and w.flag("honest"):
				text = "Cole kicks open his filing cabinet with his boot and pulls out your intake dossier. ‘Your honest incident report hit my desk like a mortar shell at eight this morning, Daniel!’ Cole says, slamming the folder down. ‘In thirty years on this beat, I’ve never seen a supervisor stand up to a rogue plant manager like Voss. That document gives me the search warrants I need to tear Line 4 apart bolt by bolt!’"
			else:
				text = "Cole leans across his battered desk, chewing on a toothpick with unblinking intensity. Wiretap tape decks spin on the shelf behind him. ‘I don't care about corporate excuses, Daniel,’ Cole barks, pointing a steel ruler at you. ‘I care about who stripped the copper, who bypassed the hydraulic kill-switch, and whose fingerprints are on the maintenance cage! Talk to me!’"
			text += " Cole watches your face like a polygraph machine, logging every word into his audio recorder."
			w.record(name + " met Cole to discuss the investigation.", [who, "cole"], "direct conversation", false, "working", who)
			if who == "daniel" and w.flag("delayed_statement") and not w.flag("statement_completed"):
				w.data.flags.statement_completed = true
				w.data.flags.honest = true
				w.record("Daniel supplied his deferred statement: he saw the bypass but not who installed it.", [who, "cole"], "signed statement", false, "important", who)
				text += " You slap down the formal statement you deferred overnight, delivering an unhedged, honest account of finding the rigged wire on Line 4 without pointing unverified fingers."
		"submit_recording":
			travel(w, "station", "cole")
			w.data.flags.recording_shared = true
			w.record("Cole received Daniel's voice memo of Harold ordering him to stop recording.", [who, "cole"], "voice recording", false, "important", "harold")
			text = "Cole plugs your phone into high-output studio monitors and cranks the volume. Harold’s manic, sweating voice reverberates through the precinct: *‘We need to be consistent... corporate has deadlines... thirty families out on the street!’* Cole bursts into an explosive laugh, slamming both hands on the desk: ‘Listen to him sweat! That’s textbook felony witness tampering and extortion on tape! Voss is heading straight to federal lockup!’"
		"rest":
			travel(w, "home")
			w.player().fatigue = 8
			w.player().conditions.erase("exhausted")
			w.player().health = mini(100, int(w.player().health) + 12)
			var wake_hour = (int(w.data.minute) / 60) % 24
			var wake_light = "harsh morning sunlight cuts across the floorboards like a spotlight."
			if wake_hour >= 12 and wake_hour < 17:
				wake_light = "afternoon sirens scream on route 9 as daylight blazes through the blinds."
			elif wake_hour >= 17 and wake_hour < 21:
				wake_light = "dusk is falling over Briar Glen, streetlights buzzing like high-voltage transformers."
			elif wake_hour >= 21 or wake_hour < 5:
				wake_light = "the night is pitch black, broken only by passing police cruisers."
			text = "You barricade the front door, turn your phone to emergency alert only, and collapse onto the bed like a dropped engine block. Your body burns off the adrenaline in a deep, explosive sleep. When you wake, " + wake_light
		"luis":
			travel(w, "diner", "luis")
			if w.data.relationships["luis:" + who].trust >= 50:
				w.record("Luis says the maintenance log had a blank inspection line before the accident.", [who, "luis"], "Luis’s recollection", true, "important", "luis")
				text = "Luis keeps his cap pulled low, checking the diner windows like a getaway driver. He slides a folded napkin across the table, whispering with intense urgency: ‘Daniel, listen! At 21:45, right before Nate clocked in, I slipped into the booth to grab earplugs. Voss was hunched over the red maintenance log with an electric eraser! The inspection line for Line 4 was totally blank! When he saw me, he slammed the ledger and stuffed it under his jacket! Harold knew the machine was rigged before Nate ever set foot in the bay!’"
			else:
				text = "Luis holds his coffee cup with two white-knuckled hands, checking his rearview mirror reflection in the window. He speaks in cryptic code, twitching whenever a pickup truck slows down outside. Harold's enforcers have the town terrified, and Luis isn't ready to stick his neck out until he knows you're bulletproof."
				w.relationship("luis", who, "trust", 5)
		"work":
			travel(w, "plant")
			w.data.flags["worked_" + who] = int(w.data.flags.get("action_start_day", day))
			w.player().finances.cash += 112
			var shift_context = ""
			if w.flag("honest"):
				shift_context = " Voss stares through the reinforced glass of his booth like a furious mob boss, while the floor crew flashes you quiet, synchronized victory salutes behind his back."
			elif w.flag("blamed"):
				shift_context = " Workers turn their backs and spit on the concrete as you walk past, whispering venom about how you threw Nate to the wolves to save your skin."
			elif w.flag("lied"):
				shift_context = " Voss gives you a cold, conspiratorial wink from the catwalk—a toxic bond sealed in forged ink."
			text = "Seven insane hours in the roaring factory pit: 200-ton stamping presses thundering like artillery, sparks raining from overhead cranes, and forklifts burning rubber around tight corners. You pocket $112 in cash wages." + shift_context + " Yellow police tape flaps wildly over the blood-stained wreckage of Line 4."
			w.record(name + " completed a paid shift at the plant.", w.witnesses("plant"), "routine", false, "working", who)
			if w.player().fatigue > 78 and day >= 1:
				return setup_danger(w, "industrial", text + " Your reflexes are completely blown and the screaming feeder belt is jerking straight toward your hands!")
		"records":
			travel(w, "plant")
			w.data.flags["records_" + who] = true
			var condition: String = w.data.objects.maintenance_log.condition
			w.record(name + " saw the maintenance log: " + condition + ".", [who], "document inspection", false, "important", who)
			text = "While Voss is distracted shouting into his landline, you vault into the supervisor's glass booth and rip open the metal file cabinet! " + ("Line 4's pre-shift inspection is dead blank—no safety stamp, no initials! You whip out your phone and snap rapid-fire flash photos before slamming the binder shut!" if condition == "intact" else "The pre-shift line is filled in with fresh smeared blue ink claiming 21:00 certification! But under the desk lamp, the white paper is scuffed raw where pencil marks were hastily erased! Voss forged it after the crash!")
		"confront_harold":
			travel(w, "plant", "harold")
			w.relationship("harold", who, "trust", -15)
			w.relationship("harold", who, "resentment", 18)
			w.record(name + " confronted Harold about the bypassed guard and missing log entries.", [who, "harold"], "direct confrontation", false, "important", who)
			if w.flag("lied"):
				text = "You kick open the glass booth door, confronting Harold face-to-face! Harold slams down a heavy brass paperweight, his eyes wild with unhinged paranoia: ‘You signed that document, Daniel! We’re in this together! If federal agents kick that door in, I'll swear under oath you wired the bypass yourself! You stay in line or I'll bury you!’"
			elif w.flag("honest"):
				text = "You kick open the glass door and corner Harold against his mahogany desk! ‘You knew that switch was hotwired, Voss! Luis saw you erasing the inspection logs!’ Harold's face turns beet red, his neck veins bulging as he brandishes a nine-iron golf club from his umbrella stand: ‘You blew the whistle on me?! I have military supply deadlines! If corporate loses this contract, I will burn this entire town to the ground before I let you walk free!’"
			else:
				text = "You confront Harold in his office, demanding answers! Harold knocks a stack of blueprints onto the floor, slamming his fists down: ‘I kept thirty families fed with that line! You think some state pencil-pusher gives a damn about us?! You keep your mouth shut, Mercer, or things around here are going to get very dangerous for your family!’"
		"search_cage":
			travel(w, "plant")
			w.data.flags.cage_searched = true
			w.record(name + " searched the maintenance cage and found cut copper wire matching Line 4.", [who], "direct observation", false, "important", who)
			text = "You pick the padlock on the chain-link tool cage with a bent cotter pin and dive under the heavy workbenches! Buried beneath oily rags, you hit paydirt: coiled spools of identical 12-gauge high-voltage wire and heavy linesman clippers with fresh copper filings caught in the jaws! You snap five high-res forensic photos with timestamps!"
		"crew_stand":
			travel(w, "diner", "luis")
			w.relationship("luis", who, "trust", 12)
			w.data.flags.crew_united = true
			w.record(name + " met with the floor operators at the diner to form a united front.", [who, "luis"], "crew solidarity", false, "important", who)
			if w.flag("honest"):
				text = "You slide into the back booth of the Juniper Diner with Luis and six burly press operators. Tire irons and thermos bottles thud onto the table like a mob war council. Luis slams his fist down: ‘Dan stood up to Voss! Now it’s our turn! If Voss tries to fire one of us, we pull the main breakers and shut the entire factory down!’ The whole table roars in thunderous solidarity!"
			elif w.flag("blamed"):
				text = "You sit down with the floor crew in the back booth. Tense glares and clenched fists meet you across the table. You don’t flinch: ‘Harold tried to frame Nate, and he’s coming for the rest of you next with bribes and pink slips! If we stay divided, he picks us off one by one! If we stand united before Cole, we crush him!’ Luis slams his mug down: ‘Dan’s right. We strike together or we hang alone!’"
			else:
				text = "You rally the graveyard shift in the diner's back room. ‘Harold is going to interrogate everyone with cash bribes and termination threats,’ you tell them, your voice cutting through the clatter of silverware. ‘We form a united front right now. Cole gets the truth from all of us at once!’ Luis nods fiercely, pumping his fist: ‘The graveyard crew stands as one!’"
		"nate_defense":
			travel(w, "hospital", "nate")
			w.relationship("nate", who, "trust", 14)
			w.data.flags.nate_defended = true
			w.record(name + " helped Nate prepare his testimony and promised to testify on his behalf.", [who, "nate"], "defense pact", false, "important", who)
			if w.flag("blamed"):
				text = "You sit on the edge of Nate's hospital bed, your voice trembling with raw regret: ‘Nate... Harold bullied me into signing an initial blame report. I lost my nerve, and I almost destroyed your life.’ Nate stares at you in shock, monitors beeping rapidly: ‘You what?!’ ‘I’m fixing it,’ you swear, handing him a legal pad with detailed timelines. ‘I’m going straight to Cole to retract everything and expose Voss’s extortion!’ Nate breathes heavily, then grips your hand: ‘You better make them pay, Dan.’"
			elif w.flag("honest"):
				text = "You spread out a yellow legal pad over Nate’s bed, plotting out the counter-strike against Harold's lies. ‘Voss is trying to claim you bypassed the interlock for speed bonuses,’ you tell him. Nate laughs bitterly: ‘I have three witnesses who saw Voss tinkering near the motor housing!’ You write it down: ‘Perfect. Cole is going to shred Voss's story into confetti.’ Nate’s eyes light up with fierce confidence."
			else:
				text = "You sit beside Nate, mapping out every minute leading up to the 02:10 disaster. ‘We need a rock-solid timeline before Voss feeds his version to state investigators,’ you tell him. Nate dictates the machine logs and lockout steps with razor-sharp precision: ‘Let’s nail this bastard to the wall.’"
		"nate_rx":
			travel(w, "hospital", "nate")
			w.relationship("nate", who, "trust", 10)
			w.data.flags.nate_rx_paid = true
			w.record(name + " paid $35 cash at the hospital pharmacy for Nate's pain prescriptions.", [who, "nate"], "compassionate relief", false, "important", who)
			text = "You sprint down to St. Anne’s 24-hour pharmacy, slap $35 cash on the counter, and grab the denied prescription of high-potency nerve blockers before the night manager can object. You bring the medicine up to Nate, who swallows the relief with tears streaming down his face: ‘Mercer Works canceled my insurance three hours after the accident, Dan. You literally saved my sanity.’"
		"bills":
			w.data.flags["paid_bills_day"] = day
			var current_cash = int(w.player().finances.get("cash", 0))
			if current_cash >= 80:
				w.player().finances.cash -= 80
				w.record(name + " paid the $80 overdue heating bill in full with cash.", [who], "utility receipt", false, "important", who)
				text = "You drop four crisp twenty-dollar bills at the municipal payment depot, slamming the door on the power company’s shutoff crew! The furnace roars back to life, pumping hot air through the vents, though your emergency stash is drained dry!"
			else:
				w.player().finances.cash = 0
				w.player().finances.debt += (80 - current_cash)
				w.record(name + " applied remaining cash ($%d) toward the utility bill; balance moved to debt." % current_cash, [who], "utility receipt", false, "important", who)
				text = "You throw down every last bill in your wallet ($" + str(current_cash) + ") and negotiate a desperate deferral on the rest! The gas valves stay open, but the balance hangs over your head like an anvil!"
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
			if w.data.characters.erin.alive and w.data.characters.erin.location == "home":
				text += "\n\nErin watches the furnace fire up with a defiant smirk: ‘At least Voss can’t freeze us out of our own home!’"
		"bills_credit":
			w.data.flags["paid_bills_day"] = day
			w.player().finances.debt += 80
			if w.data.flags.has("bills") and w.data.flags.bills.has("heating"):
				w.data.flags.bills.heating.status = "paid"
			w.record(name + " charged the $80 heating bill to the credit card.", [who], "credit card payment", false, "important", who)
			text = "You punch the credit card digits into the emergency hotline, stopping the utility shutoff with seconds to spare! The furnace kicks on with a deep rattle, pushing your debt balance to $" + str(w.player().finances.debt) + "!"
			if w.data.characters.erin.alive and w.data.characters.erin.location == "home":
				text += "\n\nErin listens to the automated receipt tone, shaking her head with a wry grin: ‘Maxing out plastic in the middle of a corporate war—classic Mercer style.’"
		"matt":
			travel(w, "diner", "matt")
			text = "Matt is practically vibrating in the diner booth, gulping black coffee while police cruisers roll past outside. His hands are covered in grease and he's clutching a smoking alternator: ‘Dan! Thank God you made it! My delivery van broke down on route 9 with a cargo bed full of high-dollar commercial parts! The tow driver shook me down for fifty bucks, and if I don’t replace the starter before my dispatcher tracks the GPS, I’m dead meat!’"
			w.relationship("matt", who, "affection", 6)
			w.record("Matt told " + name + " his delivery van needs repairs.", [who, "matt"], "direct conversation", false, "working", "matt")
		"correct":
			travel(w, "station", "cole")
			w.data.flags.corrected = true
			w.data.flags["apology_" + who] = true
			w.record("Daniel corrected his misleading statement to Cole; the original remains on file.", [who, "cole"], "signed correction", false, "important", who)
			w.relationship("cole", who, "trust", -8)
			text = "You march into Cole's office, snatch Harold's fraudulent injury report, and slap a signed, sworn retraction across the desk! Cole's eyes flash with electric focus as he slams the official state seal onto your correction: ‘This tears Harold’s defense to shreds! Voss is now the prime suspect in an active felony cover-up!’"
		"doctor":
			travel(w, "hospital")
			w.player().health = mini(100, int(w.player().health) + 40)
			text = "An ER trauma doc stitches up your lacerations, pumps you full of broad-spectrum antibiotics and intravenous electrolytes, and wraps your battered ribs. You storm out of the trauma bay feeling like an armored tank ready for round two!"
		"overtime":
			travel(w, "plant")
			w.data.flags["worked_" + who] = int(w.data.flags.get("action_start_day", day))
			w.player().finances.cash += 160
			w.player().fatigue = mini(100, int(w.player().fatigue) + 45)
			if not w.player().conditions.has("exhausted"):
				w.player().conditions.append("exhausted")
			w.relationship("erin", who, "resentment", 8)
			w.record(name + " worked an exhausting overnight double shift for $160 cash.", [who, "harold"], "overtime shift", false, "working", who)
			text = "Eight grueling hours in a high-speed industrial meat grinder: double-time stamping, dodging flying metal burrs, and hauling steel billets under screaming emergency lights! You pocket $160 in crisp hundred and twenty-dollar bills, stumbling out at dawn trembling with pure exhaustion!"
		"job":
			travel(w, "home")
			w.data.flags.job_accepted = true
			w.player().finances.cash += 60
			w.record("Erin attended a paid trial day for the job two towns away.", [who], "direct experience", false, "important", who)
			text = "You call the confidential operations contact two towns away: a high-stakes trial run, $60 cash upfront, and a clean ticket out of Harold Voss's corrupt kingdom. The ball is in your court."
	if w.player().health < 25:
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
		w.player().alive = false
		w.data.scene = "ended"
		return "Disaster strikes in a brutal fraction of a second. Flesh tears, bone shatters, and searing agony consumes your vision before plunging into total blackness.\n\nFor a moment you think you can still get clear. Then the moment is gone.\n\nThe town does not stop with you."
	return "Agony explodes through your nervous system as the trap violently snaps shut. You stagger backward, vomiting from shock and clutching your bleeding, battered body.\n\nIt happens faster than you expected. You get clear, hurt and shaking. Your body will carry this decision longer than the scene lasts."
