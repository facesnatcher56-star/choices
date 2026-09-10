extends RefCounted
## Player-facing motives and dilemmas. No hidden culprit knowledge or stat promises.

static func connection(w, actor: String) -> String:
	if w.data.player != "daniel":
		var memories: Array = w.memories_for(w.data.player, actor)
		return "" if memories.is_empty() else "What you remember: " + str(memories.back().text)
	return {
		"nate": "Nate is the man you vouched for when he needed this job. He trusted your word that the floor was safe. Now you can barely look at the arm that used to wave you over at shift change.",
		"luis": "Luis covered for you when your first shift as supervisor went wrong. He could have had your job; instead, he taught you how to keep it. He is the one person on the floor you still trust to tell you the truth.",
		"erin": "Erin is your wife, and the person you once planned to leave this town with. Every promotion became another reason to stay. She knows the difference between you being frightened and you shutting her out.",
		"chloe": "Chloe is your fifteen-year-old daughter. She used to save you a seat beside the track, even when you missed the meet. Lately she has stopped asking whether you will come.",
		"matt": "Matt is your little brother—the kid who used to follow you everywhere. Now he mostly calls when he is cornered. You miss being his brother instead of the person deciding whether he gets another chance.",
		"harold": "Harold gave you the supervisor's keys and the pay rise that made staying seem sensible. He can still take both away. Tonight he wants to know what that bought him.",
		"cole": "Cole is the workplace-safety investigator who will review your incident report. He does not owe you loyalty. Once he writes something down, Harold cannot quietly decide it never happened—and neither can you.",
		"rebecca": "Rebecca is Erin's friend from before your marriage. Erin still calls her when she cannot talk to you. Accepting her help means letting someone who knows your family see how close it is to breaking."
	}.get(actor, "")

static func encounter_stakes(key: String) -> String:
	return {
		"school": "Chloe is offering to disappear from the week's problems. Taking that offer costs nothing today. Teaching her that her wishes always come last costs something else.",
		"interview": "A job outside Mercer Works could give your family room to refuse Harold. It also means the future you kept postponing may happen without you leading it.",
		"contradiction": "The photograph and your signed account cannot both tell the same story. Protecting the first lie may be easier right now than explaining it to the people you meant to protect.",
		"loyalty": "The money is real. So is the signature he wants under a claim you cannot verify. Harold is offering relief now in exchange for something you may not be able to take back.",
		"nate_bill": "You cannot give Nate his old life back. You can decide whether he has to face what comes next alone—and whether your help comes with an expectation of forgiveness.",
		"matt_van": "The van is Matt's last income that does not come through you. Rescue him with money, spend your own time finding another way, or finally set a limit you both have to live with.",
		"meeting": "These are the people who worked under your orders. A signature puts you beside them in public; helping anonymously may win the same relief without showing them where you stand.",
		"neighbor": "Rebecca offers more than dinner: somewhere Chloe can stay if the house becomes unbearable. You have to let someone outside the family know you need that door open.",
		"promise_due": "Chloe remembers your exact words. This decision will tell her whether your promises mean something when keeping them becomes inconvenient.",
		"erin_offer": "This salary could end Harold's hold over the family. Erin is asking whether you will build that future with her, not whether she is allowed to want it.",
		"harold_cornered": "The man who used to summon you to his office has come looking for you. He wants his problem to feel like your responsibility again.",
		"strike_vote": "Luis is asking you to stand where management can see you. Your crew will remember who stayed beside them when being their supervisor stopped offering protection.",
		"luis_statement": "Cole needs someone willing to put a name to the missing inspection. Luis needs next week's wages. Moving the case forward may expose the friend who kept you on your feet."
	}.get(key, "")

static func response_stakes(key: String, id: String) -> String:
	var stakes = {
		"school": {"pay": "Give her one part of the week that still belongs to her.", "explain": "Keep her trust by admitting a limit; she may still miss the trip.", "promise": "Keep hope alive by giving your word. She will come back for it.", "dismiss": "End the conversation quickly; she hears that asking was the mistake."},
		"interview": {"support": "Make her escape from dependence on the plant something you build together.", "listen": "Find out whether she wants a different job or a different life.", "cost": "Take her plan seriously enough to help make it possible.", "object": "Ask for stability at home at the cost of another delay in her life."},
		"contradiction": {"admit": "Repair the record by admitting that you damaged it.", "uncertain": "Leave room to retreat, but give Cole another reason to doubt you.", "pressure": "Explain Harold's part without pretending it removes your own.", "pause": "Buy breathing room; leave the contradiction unresolved."},
		"loyalty": {"sign": "$150 now. Your name becomes part of Harold's account.", "refuse": "Keep your name off the claim; lose the money and anger your boss.", "copy": "Take a blank copy home to review before signing, avoiding an immediate commitment.", "amend": "Offer a truthful signature; Harold has already tied the money to his wording."},
		"nate_bill": {"money": "Offer practical relief without buying the right to be forgiven.", "forms": "Use your supervisor's knowledge to get Nate help the company has not explained.", "hear": "Let him be angry without making him reassure you.", "distance": "Protect what you have left for your own family; leave him facing this alone."},
		"matt_van": {"lend": "Protect his independence with money your own family may need.", "ride": "Save the contract through shared routes; it costs your time instead of $120.", "decline": "Set an honest limit even if the van and his work go with it.", "blame": "Say the resentment out loud; risk losing more than the money he owes."},
		"meeting": {"join": "Help win emergency pay and let the crew see your name beside theirs.", "quiet": "Help win relief while keeping your name off management's copy.", "wait": "Avoid committing before the findings; wages remain unresolved.", "leave": "Keep your distance from the dispute; the crew loses your support."},
		"neighbor": {"accept": "Give the family a place to turn when you cannot hold everything together.", "share": "Tell the truth about needing help; open a door for Chloe.", "private": "Accept tonight's kindness while keeping the larger crisis behind your door.", "reject": "Keep your pride and privacy; close off the offered refuge."},
		"promise_due": {"pay": "Make your word something she can count on again.", "sorry": "Break the promise without making her doubt that you made it.", "ask": "Hear what the broken promise meant to her.", "deny": "Protect yourself by asking your daughter to distrust her own memory."},
		"erin_offer": {"celebrate": "Support a future where Harold cannot threaten all your income.", "practical": "Commit to your share of making her new life work.", "fear": "Risk an honest answer about the marriage.", "refuse": "Ask her to keep shrinking her life around yours; she may choose differently."},
		"harold_cornered": {"refuse": "Keep the evidence intact and end his expectation of your loyalty.", "bargain": "Use his fear to ask for protection for the crew; he may promise nothing.", "leave": "Refuse the private negotiation without giving him another statement."},
		"strike_vote": {"picket": "Stand publicly with the crew; push management toward a meeting.", "mediate": "Try to get both men into one room without joining the line.", "walk": "Choose the people waiting at home; accept the distance from your crew."},
		"luis_statement": {"named": "Ask your friend to risk his job for a statement Cole can pursue.", "protect": "Keep Luis's name out of it; the log still needs independent corroboration.", "back_off": "Let him withdraw. Protect his immediate safety and give up this lead."}
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
		c.secondary = id.begins_with("travel_") or id in ["bills", "bills_credit", "truck_diy", "truck_shop", "rest", "wait_open", "drive", "neighbor", "doctor", "work", "overtime"]
		if id.begins_with("encounter_"):
			var key = id.trim_prefix("encounter_")
			var reason = encounter_stakes(key)
			if not reason.is_empty():
				c.why = reason
		if w.data.player != "daniel":
			continue
		match id:
			"visit":
				c.label = "Face Nate—the man you vouched for."
				c.why = "He took this job on your word. You still have to meet his eyes."
				c.secondary = w.knows("daniel", "visited Nate")
			"family":
				c.label = "Go back to Erin before the silence becomes your answer."
				c.why = "Your wife can face bad news with you. She cannot stand beside a version of you she isn't allowed to know."
				c.secondary = w.knows("daniel", "spent time with Erin")
			"matt":
				c.label = "Answer your brother's call for help."
				c.why = "Matt needs a way to keep earning without you. You need to know this will not become another rescue."
				c.secondary = w.knows("daniel", "his delivery van needs repairs")
			"luis":
				c.label = "Find out what Luis is afraid to put on paper."
				c.why = "He helped you become supervisor. His recollection could challenge Harold's paperwork."
				c.secondary = w.knows("daniel", "Luis says the maintenance log")
			"records":
				c.label = "Check the log before Harold's account becomes the only one."
				c.why = "Your shift is in that book. Missing paperwork could challenge the story being built around Nate."
			"investigate":
				c.label = "Put your account where Harold cannot quietly erase it."
				c.why = "Cole can act on what you hand over. Once it is in the file, you cannot control where it leads."
				c.why += " Takes 90 minutes out of the day you normally sleep before your night shift."
				c.secondary = w.knows("daniel", "met Cole") and not (w.flag("photo") and not w.flag("evidence_shared")) and not (w.knows("daniel", "maintenance log") and not w.flag("log_shared")) and not (w.flag("delayed_statement") and not w.flag("statement_completed"))
			"correct":
				c.label = "Tell Cole you lied before the lie becomes your life."
				c.why = "The old statement stays on file. So does the fact that you chose to correct it."
			"rest":
				var clock = int(w.data.minute / 60) % 24
				if clock < 6 or clock >= 21:
					c.label = "Turn in and sleep until morning."
					c.why = "Rest in your own bed to clear your head, restore your energy, and wake to morning light."
				else:
					c.label = "Get some sleep before the next night shift." if clock < 18 else "Turn in and get a full night's sleep."
					c.why = "Sleep restores your health, clears your exhaustion, and wakes you to morning light."
			"work":
				c.label = "Take the shift. Buy room to refuse Harold later."
				c.why = "$112 for seven hours at the plant. Money gives you options; exhaustion takes them away."
			"overtime":
				c.label = "Take Harold's extra hours and the money that comes with them."
				c.why = "$160 for eight hours. You come back exhausted, and Erin absorbs another absence."
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
