extends RefCounted
const Finances = preload("res://scripts/finances.gd")
## Player-facing motives and dilemmas. No hidden culprit knowledge or stat promises.

static func connection(w, actor: String) -> String:
	if w.data.player != "daniel":
		var memories: Array = w.memories_for(w.data.player, actor)
		return "" if memories.is_empty() else "What you remember: " + str(memories.back().text)
	return {
		"nate": "Nate is the kid you brought into the plant, promising him the line was solid. Forty tons of hydraulic iron mangled his arm, and now Voss’s syndicate wants to frame him. You owe him his life and his name.",
		"luis": "Luis covered your back on day one when an unhinged die-press nearly leveled the warehouse. He’s the one brother on the floor ready to bring pipe wrenches to an executive boardroom war.",
		"erin": "Erin is your ride-or-die wife who keeps the scanner buzzing and the shotgun ready. She refused to let Briar Glen break you, and she’s ready to take down Harold Voss by your side.",
		"chloe": "Chloe is your fearless fifteen-year-old daughter chasing state track championships while police cruisers rip down the cul-de-sac. She needs to know her dad won't fold under pressure.",
		"matt": "Matt is your wild younger brother, perpetually dodging repo squads with van-loads of racing nitrous and smoking starters. He’s chaos on four wheels, but he’s still blood.",
		"harold": "Harold Voss is the espresso-fueled, mobbed-up plant manager who thinks a supervisor badge bought your soul. He has cartel-backed deadlines, and he will burn the town down before he goes to prison.",
		"cole": "Cole is the state safety task force bulldog—wiretaps, crime boards, and search warrants ready to lock down Line 4. He doesn't take bribes, and he doesn't forget a lie.",
		"rebecca": "Rebecca is your combat-ready neighbor down the ridge with a pump-action shotgun, a hot turkey casserole, and a fortified safehouse ready for your family."
	}.get(actor, "")

static func encounter_stakes(key: String) -> String:
	return {
		"school": "Chloe is gunning for state championships while sirens wail outside. Paying her bus fee keeps her dream alive amidst the madness.",
		"interview": "A corporate operations salary two towns away could break Voss’s chokehold on your family forever—if you have the guts to take it.",
		"contradiction": "The forensic wire photo and your signed incident report are on a direct collision course. Cole is ready to cuff you unless you come clean.",
		"loyalty": "Harold is slapping $150 in crisp cash on the desk for a fraudulent safety sign-off. Fast money, but you’re signing a live grenade.",
		"nate_bill": "Mercer Works canceled Nate’s medical insurance. You can step up with cash and emergency filings, or leave your boy to drown in medical debt.",
		"matt_van": "Matt's delivery van broke down on route 9 loaded with hot cargo. Bail him out with cash, haul the crates in your pickup, or let him crash and burn.",
		"meeting": "The floor crew has seized the diner back room with pipe wrenches, planning a wildcat strike. Your signature puts you at the front of the charge.",
		"neighbor": "Rebecca is offering a warm fortress, hot food, and shotgun cover. Accepting means letting someone else into the fight.",
		"promise_due": "The Springfield team bus is idling with the engine roaring. Keep your cash pledge to Chloe, or break her heart at the finish line.",
		"erin_offer": "The courier contract is on the table—a golden ticket out of Briar Glen. Erin wants to build a new empire with you, right now.",
		"harold_cornered": "Harold Voss is sweating bullets with a crowbar in his trench coat, begging you to help him torch the inspection ledger before the raid.",
		"strike_vote": "The factory gate is an active warzone in the freezing sleet—burning drums, blocked scab buses, and megaphones blaring. Cast the deciding vote.",
		"luis_statement": "Luis has the smoking-gun affidavit on Voss's document tampering. Handing it to Cole launches a federal assault on the plant."
	}.get(key, "")

static func response_stakes(key: String, id: String) -> String:
	var stakes = {
		"school": {"pay": "Slap down the cash and send her running for gold in Springfield.", "explain": "Give her the unvarnished truth about the emergency bills.", "promise": "Keep hope alive by giving your word to bring forty-five cash before the team bus rolls out.", "dismiss": "Shove the paper away and prioritize the industrial warzone."},
		"interview": {"support": "Back her play to escape Voss's empire with full benefits.", "listen": "Hear her vision for a clean life away from the factory pit.", "cost": "Run the highway numbers and map the fuel budget together.", "object": "Demand she stay in town while the federal storm rages."},
		"contradiction": {"admit": "Blow Voss's extortion wide open and clear your conscience.", "uncertain": "Claim adrenaline fogged your memory; Cole smells blood in the water.", "pressure": "Quote Voss's exact threats without taking the blame for the wire.", "pause": "Demand legal representation and shut down the interrogation."},
		"loyalty": {"sign": "Pocket $150 in crisp fifties and legally ratify a crime.", "refuse": "Throw the dirty bribe in Harold's face and dare him to fire you.", "copy": "Snatch the rider to show your attorney, escaping his office with the proof.", "amend": "Deface the rider with red ink exposing the bypass and sign with defiance."},
		"nate_bill": {"money": "Hand over $60 emergency cash so Nate can get his nerve blockers.", "forms": "Draft emergency state whistleblower trauma appeals to save him.", "hear": "Stand by his hospital bed while the fury and adrenaline pour out.", "distance": "Step back and leave Nate to battle the insurance sharks alone."},
		"matt_van": {"lend": "Drop $120 to replace his starter and make him sign a contract.", "ride": "Haul his cargo in your pickup down route 9 at 80 mph.", "decline": "Refuse to bail out another reckless stunt with family money.", "blame": "Blast him for hauling hot cargo and running amateur stunts."},
		"meeting": {"join": "Sign Daniel Mercer — Night Supervisor at the top of the strike petition.", "quiet": "Sharpen their labor-law clauses while keeping your name off the frontline.", "wait": "Preach caution and wait for federal inspection findings.", "leave": "Walk out on the crew to protect your supervisor standing."},
		"neighbor": {"accept": "Open your doors to a hot feast and an armed ally.", "share": "Admit how close the family is to total financial ruin.", "private": "Take the casserole but keep the tactical situation private.", "reject": "Turn down armed help and hot food out of stubborn pride."},
		"promise_due": {"pay": "Slap down the fifty and watch your daughter sprint for glory.", "sorry": "Look her in the eye and admit you couldn't beat the deadline.", "ask": "Sit on the porch steps and hear her fears about the family.", "deny": "Claim you never made a promise and accuse her of lying."},
		"erin_offer": {"celebrate": "Spin her across the kitchen and pop the cork on a new life.", "practical": "Map out a high-speed commute and household battle plan.", "fear": "Ask if she’s using this job to leave you in the dust.", "refuse": "Demand she reject the offer and stay locked in Briar Glen."},
		"harold_cornered": {"refuse": "Refuse to commit felony arson and watch Voss self-destruct.", "bargain": "Demand six months of full worker severance before talking.", "leave": "Walk out into the rain, leaving Voss alone with his madness."},
		"strike_vote": {"picket": "Light the flare, weld the gates shut, and lead the wildcat strike!", "mediate": "Call for two hours of ceasefire to confront Harold Voss directly.", "walk": "Turn your truck around and abandon the blockade to the scabs."},
		"luis_statement": {"named": "Take Luis's signed affidavit to Cole and drop the hammer on Voss.", "protect": "Keep Luis safe from the crosshairs and seize the records yourself.", "back_off": "Burn the evidence in a diner mug and let the lead turn to ashes."}
	}
	return str(stakes.get(key, {}).get(id, ""))

static func prepare(w, options: Array) -> Array:
	var opening = {
		"accident": {
			"stop": "Kill the power before the next stroke crushes Nate further. Every second counts.",
			"ambulance": "Stem the arterial bleed immediately. You got Nate this job; he needs your hands on that wound right now.",
			"call_luis": "Coordinate the emergency response. Split power isolation and dispatch so neither is delayed."
		},
		"pressure": {
			"photo": "Preserve the evidence while Harold is in the office. Documenting the wire now protects the truth before it disappears.",
			"witness": "Call Luis over. A witness on the floor prevents Harold from isolating and intimidating you in private.",
			"refuse": "Tell Harold you will give an honest statement. The man who controls your shifts will remember your refusal.",
			"agree": "Protect your supervisor pay and family security by agreeing to back Harold's version.",
			"record": "Start a voice memo in your pocket. A hidden audio recording safeguards your word against Harold's.",
			"defer": "Buy time to think without committing to a lie or picking an open fight right now."
		},
		"statement": {
			"truth": "Document the bypassed guard and machine condition as found, without inventing or concealing facts.",
			"lie": "Protect your job and plant operations by signing Harold's version that the guard was normal.",
			"blame": "Deflect suspicion onto the man you vouched for. Nate may survive to hear what you wrote.",
			"delay": "Sign only the basic injury notice and defer your full statement until you've cleared your head."
		},
		"homecoming": {
			"tell": "Be completely transparent with Erin about the accident and Harold's pressure, facing the crisis together.",
			"partial": "Tell her Nate was hurt, but spare her the managerial threats to keep her from panicking tonight.",
			"hide": "Claim an equipment breakdown kept you late. Keep tonight quiet, but carry the burden entirely alone.",
			"sleep": "Admit you are in shock and physically spent. Sleep helps your body, but leaves questions hanging."
		}
	}
	for c in options:
		c["secondary"] = false
		if w.data.scene != "town":
			c.why = opening.get(w.data.scene, {}).get(c.id, c.why)
			continue
		var id: String = c.id
		c.secondary = id.begins_with("travel_") or id in ["rest", "wait_open", "work", "overtime"]
		if id.begins_with("encounter_"):
			var key = id.trim_prefix("encounter_")
			var reason = encounter_stakes(key)
			if not reason.is_empty():
				c.why = reason
		if w.data.player != "daniel":
			continue
		match id:
			"visit":
				if w.flag("blamed"):
					c.label = "Face Nate at the trauma ward—the man you framed."
					c.why = "You scapegoated Nate while he was on the operating table. Face the brother you betrayed."
				elif w.flag("lied"):
					c.label = "Face Nate at St. Anne's after signing Harold's cover-up."
					c.why = "You signed Harold's fraudulent walkthrough to protect your badge. Meet the eyes of the kid who paid the price."
				elif w.flag("honest"):
					c.label = "Visit Nate at St. Anne's Hospital to plan the fight."
					c.why = "You stood up to Voss and saved Nate's name on the state report. See how he is holding up in trauma recovery."
				else:
					c.label = "Drive to St. Anne’s Hospital to check on Nate."
					c.why = "Nate took this graveyard shift on your word. You have to stand by his bedside."
				c.secondary = w.knows("daniel", "visited Nate")
			"family":
				if w.flag("corrected"):
					c.label = "Tell Erin you recanted the lie with Investigator Cole."
					c.why = "Let your wife know you cleared your name from Harold's fraudulent report."
				elif w.flag("told_erin"):
					c.label = "Plan the counterstrike with Erin in the kitchen."
					c.why = "Erin is locked and loaded with the scanner running; coordinate your next moves together."
				elif w.knows("erin", "knowingly misled"):
					c.label = "Talk to Erin about recanting your statement."
					c.why = "She knows you signed Harold's cover-up; she wants to know if you're going to fix it."
				elif w.knows("erin", "blamed Nate"):
					c.label = "Face Erin about blaming Nate on the report."
					c.why = "She was devastated by your admission; face the rift in your marriage."
				else:
					c.label = "Tell Erin the truth about the plant catastrophe."
					c.why = "You kept the crisis from her last night; the silence between you is widening."
				c.secondary = w.knows("daniel", "spent time with Erin")
			"matt":
				c.label = "Answer your brother Matt's distress call at the diner."
				c.why = "Matt broke down on route 9 with hot cargo and needs cash before repo muscle flags his GPS."
				c.secondary = w.knows("daniel", "his delivery van needs repairs")
			"luis":
				c.label = "Meet Luis Ortega at the diner to crack the case."
				c.why = "Luis caught Voss in the supervisor booth erasing safety logs; his testimony is dynamite."
				c.secondary = w.knows("daniel", "Luis says the maintenance log")
			"confront_harold":
				if w.flag("lied"):
					c.label = "Storm Harold Voss's booth about the fraudulent report."
					c.why = "Demand to know what his promises are worth now that federal agents are circling the plant."
				elif w.knows("daniel", "maintenance log"):
					c.label = "Confront Harold Voss about the erased inspection line."
					c.why = "Force Harold to defend his cover-up face-to-face before corporate attorneys step in."
				elif w.flag("honest"):
					c.label = "Confront Harold Voss over his threats of retaliation."
					c.why = "Harold is furious that you documented the bypassed guard; face him down on the floor."
				else:
					c.label = "Kick open Harold Voss's booth door and demand answers."
					c.why = "Corner Harold face-to-face about the hotwired guard before corporate goons arrive."
			"search_cage":
				c.label = "Pick the tool cage lock to seize the wire clippers."
				c.why = "Recover the linesman pliers and copper off-cuts matching Line 4 before Harold destroys them."
			"crew_stand":
				if w.flag("honest"):
					c.label = "Rally the floor operators into an underground strike front."
					c.why = "You stood up for Nate on the report; mobilize the crew in solidarity before Harold intimidates them."
				elif w.flag("blamed"):
					c.label = "Face the angry shift crew in the diner's back booth."
					c.why = "The shift crew knows Nate was hurt; face your coworkers and prove whose side you're on."
				else:
					c.label = "Rally the floor operators into an underground strike front."
					c.why = "Build collective solidarity among the shift workers before Harold intimidates them."
			"nate_defense":
				if w.flag("blamed"):
					c.label = "Rush to Nate's bedside and confess the scapegoat report."
					c.why = "Apologize to Nate for succumbing to Harold's pressure and promise to retract it with Cole."
				elif w.flag("honest"):
					c.label = "Arm Nate with legal testimony for Cole's interrogation."
					c.why = "Coordinate Nate's timeline for Cole's interrogation and give him your sworn word as supervisor."
				else:
					c.label = "Help Nate build a bulletproof defense against Voss."
					c.why = "Prepare Nate for Cole's interrogation and give him your sworn word as supervisor."
			"nate_rx":
				c.label = "Rush $35 cash to St. Anne’s pharmacy for Nate's pain meds."
				c.why = "Mercer's insurer denied coverage; paying out-of-pocket spares Nate agonizing nerve pain."
			"records":
				c.label = "Raid the supervisor booth to photograph the red log book."
				c.why = "Photograph the blank or erased inspection line before Harold swaps the binder."
			"investigate":
				if w.flag("delayed_statement") and not w.flag("statement_completed"):
					c.label = "Deliver your deferred sworn statement to Investigator Cole."
					c.why = "Hand over your formal supervisor testimony on Line 4 directly to the state inquiry."
				elif w.flag("photo") and not w.flag("evidence_shared"):
					c.label = "Slap the forensic bypass wire photo onto Cole's desk."
					c.why = "Give the state investigator physical proof that Line 4's guard was deliberately wired open."
				elif w.flag("cage_searched") and not w.flag("cage_evidence_shared"):
					c.label = "Deliver the tool cage wire and plier evidence to Cole."
					c.why = "Hand over timestamped photos of the cut copper wire and pliers found in the maintenance cage."
				elif w.knows("daniel", "maintenance log") and not w.flag("log_shared"):
					c.label = "Blow the whistle on Harold's log book tampering to Cole."
					c.why = "Tell Cole about the blank pre-shift inspection line and the erased marks."
				elif w.flag("honest"):
					c.label = "Coordinate the state safety inquiry with Investigator Cole."
					c.why = "Cole received your honest incident report; plan the federal inspection raid on Line 4."
				else:
					c.label = "Enter your testimony into Cole's official federal file."
					c.why = "Cole can act on what you hand over. Once it is in the file, Voss cannot touch it."
				c.why += " Takes 90 minutes out of the day you normally sleep before your night shift."
				c.secondary = w.knows("daniel", "met Cole") and not (w.flag("photo") and not w.flag("evidence_shared")) and not (w.flag("cage_searched") and not w.flag("cage_evidence_shared")) and not (w.knows("daniel", "maintenance log") and not w.flag("log_shared")) and not (w.flag("delayed_statement") and not w.flag("statement_completed"))
			"correct":
				c.label = "Slap down a sworn retraction with Cole and blow Voss's cover."
				c.why = "The old statement stays on file, but this signed correction strips Harold of his shield."
			"bills":
				var cash_avail = Finances.available_cash(w)
				if cash_avail >= 80:
					c.label = "Drop $80 cash at the utility depot to keep the heat blazing."
					c.why = "Clears the overdue utility notice immediately with cash, stopping the shutoff crew."
				else:
					c.label = "Throw all remaining cash ($%d) at the overdue heating bill." % cash_avail
					c.why = "Applies every dollar in your wallet to keep the heat flowing; the balance rolls into debt."
				c.secondary = false
			"bills_credit":
				c.label = "Charge the $80 heating bill to credit to keep the furnace roaring."
				c.why = "Settles the immediate utility notice while preserving cash, increasing card debt to $%d." % (Finances.total_debt(w) + 80)
				c.secondary = false
			"rest":
				var clock = int(w.data.minute / 60) % 24
				if clock < 6 or clock >= 21:
					c.label = "Barricade the front door and sleep until morning."
					c.why = "Rest in your own bed to clear your head, restore your energy, and wake to morning light."
				else:
					c.label = "Crash for a few hours before the next night shift." if clock < 18 else "Turn in and sleep off the adrenaline."
					c.why = "Sleep restores your health, clears your exhaustion, and wakes you to morning light."
			"work":
				c.label = "Survive a grueling 7-hour shift on the screaming factory floor ($112)."
				c.why = "$112 cash wages. Money gives you ammunition; exhaustion takes it away."
			"overtime":
				c.label = "Take Harold's high-octane 8-hour double shift in the iron pit ($160)."
				c.why = "$160 cash wages. You come back exhausted, and Erin absorbs another absence."
	# Recovery belongs up front when it is urgent, or when the chapter has gone quiet.
	var has_lead = options.any(func(c): return not c.secondary)
	var has_rest = options.any(func(c): return c.id == "rest")
	for c in options:
		if c.id == "doctor":
			c.secondary = false
		elif c.id == "rest" and (not has_lead or w.player().fatigue >= 70):
			c.secondary = false
		elif c.id == "wait_open" and not has_lead and not has_rest:
			c.secondary = false
	return options
