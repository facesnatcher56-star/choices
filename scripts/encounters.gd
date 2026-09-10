extends RefCounted
## Authored, conditional storylets add human situations to the local simulation.
## Each one is offered once, only when its actors and prerequisites exist.

func catalogue() -> Dictionary:
	return {
		"school": {"day": 1, "actor": "chloe", "place": "home", "title": "Forty-five dollars", "text": "Chloe leaves a school form beside your plate. The trip costs $45.\n\n‘I can say I don’t want to go,’ she says. She is offering you a way out, and watching to see whether you take it.", "responses": [
			["pay", "Pay for the school trip.", -45, "trust", 8, "Chloe folds the signed form carefully. ‘Thanks.’ For a moment she gets to worry about something ordinary."],
			["explain", "Explain the money situation without blaming her.", 0, "trust", 5, "You sit down with her. She does not like the answer, but she stops pretending not to care."],
			["promise", "Promise you will find the money soon.", 0, "trust", 2, "‘Before Friday,’ she says. She writes the date on the form. The promise now has a deadline."],
			["dismiss", "Tell her there are bigger problems right now.", 0, "resentment", 12, "Chloe takes the form back. ‘I know.’ She leaves before you can decide whether to soften it."]]},
		"interview": {"day": 2, "actor": "erin", "place": "home", "title": "Two towns away", "text": "Erin tells you she has applied for a job. It is two towns away, and the interview is tomorrow.\n\n‘I needed something that was mine,’ she says. ‘I wanted to tell you myself.’", "responses": [
			["support", "Offer to handle the morning so she can go.", 0, "trust", 10, "Erin hands you Chloe’s schedule. ‘Thank you.’ It is a small, practical kind of trust."],
			["listen", "Ask what she wants from the job.", 0, "affection", 8, "‘A choice,’ Erin says. You talk about the commute, and then about things that have nothing to do with the commute."],
			["cost", "Work through the travel costs together.", 0, "respect", 6, "You make a list together. The numbers are awkward, but the conversation stays on the same side of the table."],
			["object", "Ask her to stay until the trouble at work settles.", 0, "resentment", 15, "‘There is always something to wait for.’ Erin closes the laptop. She has not agreed."]]},
		"contradiction": {"day": 2, "actor": "cole", "place": "station", "title": "Two accounts", "text": "Cole puts your original statement beside the photograph you supplied.\n\n‘You said it looked normal. This shows the wire. Help me understand when each thing happened.’ He has a contradiction to investigate, not access to your thoughts.", "responses": [
			["admit", "Admit that the first account was misleading.", 0, "respect", 6, "Cole records your admission and the correction. The old account stays in the file."],
			["uncertain", "Say you are uncertain about the timing.", 0, "trust", -10, "Cole adds the uncertainty to the file. He says he will compare it with the image timestamp."],
			["pressure", "Describe Harold’s request, without blaming him for the wire.", 0, "trust", 4, "Cole separates the two questions: pressure over a statement, and responsibility for the guard. One does not prove the other."],
			["pause", "Ask to stop the interview for now.", 0, "trust", -3, "Cole closes the notebook. ‘We will need to return to this.’ The questions remain open."]]},
		"loyalty": {"day": 2, "actor": "harold", "place": "plant", "title": "A signature", "text": "Harold offers a $150 retention payment. The form includes a line saying the safety inspection was completed before the accident.\n\n‘You know how these forms are,’ he says. You do not have evidence that this line is true.", "responses": [
			["sign", "Sign the form and take the payment.", 150, "trust", 12, "Harold places the signed form in a folder. The $150 will help at home. Your name is now attached to an unverified statement."],
			["refuse", "Refuse to sign something you cannot verify.", 0, "resentment", 12, "Harold withdraws the form. ‘Suit yourself.’ The payment goes with it."],
			["copy", "Ask for a copy to show Cole first.", 0, "trust", -15, "Harold lets you take a blank copy. You now have the wording of the request, not proof of a completed inspection."],
			["amend", "Cross out the inspection claim before signing.", 0, "respect", 5, "Harold looks at the alteration. ‘Payroll will reject it.’ You leave the amended form on his desk anyway."]]},
		"nate_bill": {"day": 2, "actor": "nate", "place": "hospital", "title": "The cost of recovery", "text": "Nate has a stack of forms on his blanket. Sick pay covers less than his normal shift.\n\n‘I don’t need you to fix my life,’ he says. ‘I need someone to stop telling me how lucky I am.’", "responses": [
			["money", "Offer $60 toward groceries, with no conditions.", -60, "trust", 10, "Nate accepts after a long pause. ‘This doesn’t settle anything.’ You tell him you know."],
			["forms", "Help him sort through the benefit forms.", 0, "respect", 8, "You work through the forms together. One problem becomes small enough to finish."],
			["hear", "Let him talk without offering a solution.", 0, "affection", 6, "Nate talks about the pain, the rent, and the way people now look at him. You stay."],
			["distance", "Say you have too much of your own to handle.", 0, "resentment", 9, "‘Yeah,’ Nate says. He turns the forms back toward himself."]]},
		"matt_van": {"day": 3, "actor": "matt", "place": "diner", "title": "A borrowed tomorrow", "text": "Matt’s van has finally stopped running. He needs $120 to keep his delivery work.\n\n‘I know what I still owe you,’ he says. This request is older than the accident, and suddenly much harder to answer.", "responses": [
			["lend", "Lend him $120 and put a repayment date in writing.", -120, "trust", 8, "Matt signs a scrap of diner paper. The loan is real. Whether he can repay it is still uncertain."],
			["ride", "Help him plan deliveries without the van.", 0, "respect", 7, "You spend the next hour rearranging routes. It will be inconvenient. It might work."],
			["decline", "Tell him plainly that you cannot afford it.", 0, "trust", 3, "Matt studies his coffee. ‘Fair enough.’ An honest limit is still a limit."],
			["blame", "Ask why you always have to rescue him.", 0, "resentment", 12, "‘I shouldn’t have asked.’ Matt pushes his chair back. Neither of you finishes the coffee."]]},
		"meeting": {"day": 3, "actor": "luis", "place": "diner", "title": "The people on the rota", "text": "Luis has gathered a few coworkers after the suspension notice. Everyone wants the plant safe. Everyone also needs wages.\n\n‘We can ask together,’ he says. ‘But someone has to put their name on it.’", "responses": [
			["join", "Put your name on the request for paid leave.", 0, "trust", 10, "Your name joins the others. A request is delivered with several signatures, not one person standing alone."],
			["quiet", "Help draft it, but leave your name off.", 0, "respect", 4, "Luis accepts the help. He notices the missing signature but does not argue."],
			["wait", "Suggest waiting for the inspection findings.", 0, "trust", -4, "Someone at the back asks whether the rent will wait too. Luis keeps the meeting moving."],
			["leave", "Say you need to protect your own position.", 0, "resentment", 8, "Luis nods once. The others make room for you to leave."]]},
		"neighbor": {"day": 4, "actor": "rebecca", "place": "home", "title": "An ordinary kindness", "text": "Rebecca knocks with a pot of soup. ‘I made too much.’ You both know that is an excuse.\n\nShe does not ask for the whole story. The silence leaves you room to decide how much to give her.", "responses": [
			["accept", "Thank her and invite her in.", 0, "affection", 10, "Rebecca comes in. For a little while, somebody else washes the cups."],
			["share", "Tell her you are worried about money.", 0, "trust", 7, "Rebecca listens. She suggests the community pantry. It is practical help, offered without a speech."],
			["private", "Accept the soup but keep the conversation brief.", 0, "respect", 3, "‘Of course,’ she says. She leaves the pot and does not press."],
			["reject", "Tell her you do not need looking after.", 0, "trust", -6, "Rebecca takes the pot back. ‘I didn’t mean to intrude.’ The doorstep feels colder after she leaves."]]},
		"promise_due": {"day": 4, "actor": "chloe", "place": "home", "title": "You said Friday", "text": "Chloe puts the school form back on the table.\n\n‘You said you would find the money.’ She remembers the promise exactly. You do too.", "responses": [
			["pay", "Keep the promise. Give her the $45.", -45, "trust", 10, "Chloe takes the form to her room. This time, your promise and what happened are the same thing."],
			["sorry", "Apologize and explain why you cannot.", 0, "trust", -5, "‘You could have said that before.’ She is right. You let her be disappointed without asking her to comfort you."],
			["ask", "Ask whether she wants to talk about it.", 0, "affection", 2, "She talks. You listen. The missed trip does not stop mattering just because the conversation is honest."],
			["deny", "Say you never made a definite promise.", 0, "resentment", 20, "‘I wrote it down.’ Chloe points at the date. The disagreement now includes whether she can trust her own memory around you."]]},
		"erin_offer": {"day": 5, "actor": "erin", "place": "home", "title": "A letter from Millfield", "text": "Erin places a printed formal job offer beside the teapot. $48,000 salary, full health benefits, forty-five minute commute each way.\n\n‘They need an answer by tomorrow,’ Erin says quietly. ‘It’s real, Daniel. We have to decide what happens to us.’", "responses": [
			["celebrate", "Tell her you’re proud of her and want her to take it.", 0, "trust", 15, "Erin looks at you for a long second, then exhales, shoulders dropping. ‘Thank you, Daniel.’ A rare, quiet moment of unity."],
			["practical", "Ask how you will manage Chloe’s track schedule and the commute.", 0, "respect", 8, "You pull up a calendar together. It will be exhausting, but manageable."],
			["fear", "Ask if this means she’s planning to leave you.", 0, "affection", -5, "Erin looks away. ‘I want to save this family, Daniel. But I can't do it drowning.’"],
			["refuse", "Tell her the family cannot survive her being away all day.", 0, "resentment", 18, "Erin folds the paper sharply and puts it in her bag. The silence that follows is deafening."]]},
		"harold_cornered": {"day": 5, "actor": "harold", "place": "diner", "title": "Across the linoleum", "text": "Harold Voss slides into the diner booth opposite you, clutching an unlit cigar. His face is gray and sunken. The state inspector is reviewing Line 4 maintenance logs tomorrow morning.\n\n‘If that log copy disappears, this whole thing stays an unfortunate workplace accident,’ Harold whispers. ‘If it stays in the file, criminal negligence charges come down. Thirty families lose their breadwinner.’", "responses": [
			["refuse", "Tell Harold you will not destroy evidence for him.", 0, "resentment", 15, "Harold’s jaw tightens. ‘Then whatever happens to Mercer Works is on your head.’ He leaves money on the table and walks."],
			["bargain", "Demand severance protection for the floor workers first.", 0, "respect", 6, "Harold stares at you with bleak pragmatism. ‘I can’t promise what corporate won’t fund.’"],
			["leave", "Stand up and walk out of the diner.", 0, "trust", -5, "You leave Harold alone in the booth with his cold coffee."]]},
		"strike_vote": {"day": 6, "actor": "luis", "place": "plant", "title": "The front gate", "text": "Twenty-two workers stand in the slush outside Mercer Works’ chain-link gates. Luis is standing on a wooden pallet holding a megaphone. Production is halted, but corporate is threatening scab replacements.\n\n‘We take a vote right here,’ Luis calls out, his breath misting in the freezing air. ‘Do we stand together on a picket line, or do we let them divide us?’", "responses": [
			["picket", "Vote to hold the picket line and stand with the crew.", 0, "trust", 12, "Your hand goes up alongside the others. Luis nods at you from the pallet: ‘Solidarity, Daniel.’"],
			["mediate", "Urge caution and offer to talk with Harold first.", 0, "respect", 6, "Luis shakes his head: ‘Talking time is over, Dan. Harold is protecting Harold.’"],
			["walk", "Tell Luis you have to take care of your own family first.", 0, "resentment", 10, "A few guys turn their backs as you walk to your truck. The distance between you and the floor widens."]]},
		"the_reckoning": {"day": 7, "actor": "cole", "place": "station", "title": "The closed file", "text": "Detective Cole lays the final investigative binder on his desk. Seven days of statements, timestamps, medical bulletins, and company records.\n\n‘The state safety board has concluded their review,’ Cole says, meeting your eyes. ‘The paper trail is set in stone now.’", "responses": [
			["listen", "Hear the official findings and accept what comes next.", 0, "respect", 8, "Cole reads through the summary. Facts have hardened into permanent public record."],
			["ask", "Ask what will happen to Harold Voss and the plant.", 0, "trust", 5, "‘OSHA citations have been filed,’ Cole answers evenly. ‘The rest will be argued in court.’"],
			["silence", "Sign the receipt of notice without a word.", 0, "trust", 2, "You sign your name. The investigation is officially closed."]]}
	}

func trigger(w) -> String:
	if w.data.scene != "town":
		return ""
	var day = int(w.data.minute / 1440)
	for key in catalogue():
		var e: Dictionary = catalogue()[key]
		if day < e.day or w.flag("encounter_" + key) or e.actor == w.data.player or not w.data.characters[e.actor].alive:
			continue
		if key in ["school", "promise_due"] and not w.data.player in ["daniel", "erin"]:
			continue
		if key in ["interview", "contradiction", "loyalty", "matt_van"] and w.data.player != "daniel":
			continue
		if key == "contradiction" and (not w.flag("lied") or not w.flag("evidence_shared") or w.flag("corrected")):
			continue
		if key == "loyalty" and (not w.flag("promised") or w.flag("plant_closed")):
			continue
		if key == "meeting" and not w.flag("plant_closed"):
			continue
		if key == "nate_bill" and w.data.characters.nate.health < 40:
			continue
		if key == "promise_due" and not w.flag("school_promised"):
			continue
		if key == "erin_offer" and (w.data.player != "daniel" or not w.flag("job_offered")):
			continue
		if key == "harold_cornered" and (w.data.player != "daniel" or not w.flag("case_open")):
			continue
		if key == "strike_vote" and not w.flag("plant_closed"):
			continue
		if key == "the_reckoning" and day < 7:
			continue
		w.data.flags["encounter_" + key] = true
		w.data.flags.encounter = key
		w.data.scene = "encounter"
		w.player().location = e.place
		w.data.characters[e.actor].location = e.place
		if key == "interview":
			w.record("Erin told Daniel she applied for the job two towns away.", ["erin", "daniel"], "Erin’s disclosure", false, "important", "erin")
		return "LATER · " + w.data.locations[e.place] + "\n\n" + e.text
	return ""

func choices(w) -> Array:
	var result: Array = []
	var e: Dictionary = catalogue()[w.data.flags.encounter]
	var cash = int(w.player().finances.get("cash", 0))
	for r in e.responses:
		var cost = -r[2] if r[2] < 0 else 0
		if cost > 0 and cash < cost:
			var label_text = r[1]
			if cash > 0:
				label_text = label_text.replace(".", " (pay $%d cash & carry remainder)." % cash)
			else:
				label_text = label_text.replace(".", " (charge to credit card / owe balance).")
			result.append({"id": r[0], "label": label_text, "minutes": 35, "why": "Available during ‘" + e.title + "’. Cash on hand ($%d) leaves a balance." % cash})
		else:
			result.append({"id": r[0], "label": r[1], "minutes": 35, "why": "Available during ‘" + e.title + "’. " + ("Requires $%d cash." % cost if cost > 0 else "An interpersonal response with lasting memory.")})
	return result

func resolve(w, id: String) -> String:
	var key: String = w.data.flags.encounter
	var e: Dictionary = catalogue()[key]
	var r: Array = e.responses.filter(func(row): return row[0] == id)[0]
	var cash_delta = r[2]
	if cash_delta < 0:
		var cost = -cash_delta
		var current_cash = int(w.player().finances.get("cash", 0))
		if current_cash >= cost:
			w.player().finances.cash -= cost
		else:
			var shortfall = cost - current_cash
			w.player().finances.cash = 0
			w.player().finances.debt += shortfall
	else:
		w.player().finances.cash += cash_delta

	w.relationship(e.actor, w.data.player, r[3], r[4])
	w.record(w.player().name + " chose to: " + r[1], [w.data.player, e.actor], "direct conversation about " + e.title, false, "important", w.data.player)
	if key == "school" and id == "pay" or key == "promise_due" and id == "pay":
		if w.data.flags.has("bills") and w.data.flags.bills.has("school"):
			w.data.flags.bills.school.status = "paid"
	if key == "school" and id == "promise":
		w.data.flags.school_promised = true
	if key == "contradiction" and id == "admit":
		w.data.flags.corrected = true
		w.data.flags.apology_daniel = true
		w.record("Daniel corrected his misleading account in a second interview with Cole.", ["daniel", "cole"], "signed correction", false, "important", "daniel")
	if key == "loyalty" and id == "sign":
		w.data.flags.signed_form = true
		w.record("Daniel signed an unverified inspection claim for a $150 retention payment.", ["daniel", "harold"], "signed document", false, "important", "daniel")
	if key == "matt_van" and id == "lend":
		w.data.flags.matt_loan_given = true
		w.data.characters.matt.finances.cash += 120
		w.data.characters.matt.finances.debt += 120
		w.data.intentions.append({"actor": "matt", "action": "repay", "due": w.data.minute + 2880, "why": "Signed a dated loan agreement with Daniel", "status": "pending"})
	if key == "nate_bill" and id == "money":
		w.data.characters.nate.finances.cash += 60
	if key == "school" and id == "dismiss" or key == "promise_due" and id == "deny":
		w.data.characters.chloe.beliefs.append({"belief": "Promises about money are difficult to rely on.", "source": w.data.events.back().id, "confidence": 0.7})
	w.data.scene = "town"
	return r[5]
