extends RefCounted
## A persistent, branching disaster serial. Scores belong to the town, surviving succession.

static func chapters() -> Array:
	return [
		["THE REPOSSESSION PARADE", "A flatbed carrying a thirty-foot mechanical rooster blocks the street. Its loudspeaker announces that Briar Glen has been repossessed. Then the brakes fail. The rooster rolls toward the town square, spraying foreclosure notices from its beak. A masked auctioneer waves from its back: 'Everything must go. Including your houses.'", [
			["Climb the rooster and turn its announcement into a town revolt.", "You scramble up the tail and seize the microphone. Your call to resist rolls across the rooftops. People pour onto their porches carrying frying pans like church bells. The auctioneer escapes through a hatch, leaving his auction invitation behind.", 2, 0, 1],
			["Open the empty loading yard and divert the rolling monstrosity inside.", "You swing the yard gates wide. The rooster plows into stacked packaging foam and explodes into a blizzard of white cubes. Nobody is hit. You retrieve an auction invitation from the abandoned cab while the crowd cheers.", 2, 1, 0],
			["Accept the auctioneer's $120 to escort his ridiculous parade.", "You pocket $120 and wave the truck into the empty yard. The auctioneer gives you a bidder invitation and calls you a partner. The crowd has a considerably shorter word for it.", -1, 0, 2, 120]]],
		["THE AUCTION OF EVERYBODY", "Inside an inflatable gold courthouse, an auctioneer offers the town's debts to bidders wearing animal masks. Your invitation opens the velvet rope. Lot thirteen is a bundle of collection claims against local families. The bidding bell is a taxidermied raccoon with a bicycle horn. You have one chance before the hammer falls.", [
			["Demand the paperwork and expose the auction on the room's giant screen.", "You put the sale terms under the document camera. The crowd sees collection claims being advertised as ownership of entire homes. You retain a copy; the bidders cannot unsee the deception. Security unplugs the raccoon.", 1, 2, 1],
			["Lead the families in a bidding chant until the auction collapses.", "Every family bids one imaginary billion dollars. The auctioneer tries to outshout two hundred people and loses his voice. The sale collapses, but the original paperwork leaves with the bidders.", 3, 0, 1],
			["Sell your invitation to a fox-masked bidder for $180.", "The fox pays $180 for your seat. You leave through a tunnel of furious neighbors. Behind you, the bell rings. A collection cartel now knows exactly how cheap access can be.", -2, 0, 2, 180]]],
		["THE PIE TRUCK COUP", "The auction organizers retreat in a refrigerated pie truck. At the square, their driver abandons it with the keys inside and a radio still barking orders. Behind the raspberry pies sits a locked document case. A crowd approaches from one end of the street; a recovery truck approaches from the other.", [
			["Use the truck horn to summon witnesses and secure the case together.", "You lean on the horn until half the square arrives. Together you inventory the case and photograph its shipping label before sealing it for review. Its contents remain unknown, but nobody can quietly make it disappear.", 2, 1, 1],
			["Trade the recovery crew the truck for a copy of its cargo manifest.", "You make the trade in front of witnesses. The recovery crew prints a manifest connecting the auction company to the document shipment. It is a lead, not a confession. The pies leave town under armed accounting supervision.", 0, 2, 0],
			["Turn the abandoned pies into a free street banquet.", "You distribute the sealed pies while a volunteer directs traffic. The crowd throws an impromptu victory feast. The recovery crew takes the case during the distraction; tonight you have fed a movement and lost a lead.", 3, -1, 1]]],
		["LIVE FROM THE END OF THE WORLD", "A pirate television crew sets up in a laundromat. Their host wears a sequined hazmat suit. 'The auction people bought tomorrow's headlines,' she says. 'I've rented the next ten minutes.' A washing machine thumps like a countdown. The camera light turns red.", [
			["Broadcast only the auction evidence you actually secured.", "You separate documents, observations, and suspicions on live television. The host looks disappointed until viewers begin sending corroborating leads. A careful account becomes a spectacle the organizers cannot dismiss as easily.", 1, 2, 1],
			["Challenge the auction boss to a public showdown under the water tower.", "You point into the camera and name the meeting place. The host hits a confetti cannon. Hundreds promise to attend. You have built an audience, but given the opposition warning.", 3, 0, 2],
			["Take $200 to read their sponsor's apology instead.", "The host slides you $200. You read a statement calling the auction a misunderstanding. Your face becomes the night's most replayed clip. The washing machine finishes its cycle to total silence.", -2, -1, 2, 200]]],
		["THE BLACKOUT CARNIVAL", "The square goes dark during an improvised protest carnival. A hired generator trailer has been disconnected; a collection-company banner covers its controls. The only lights left are glow sticks and a Ferris wheel running on its own battery. The crowd wants a plan before the organizers reclaim the square.", [
			["Build a human chain of lanterns and lead everyone to safety.", "You organize a glowing procession out of the square. Children ride on shoulders, the brass band keeps time, and the blockade becomes a luminous march. You surrender the stage and keep the people together.", 3, 0, 0],
			["Document the trailer and its contract before the crew removes it.", "You photograph the disconnected trailer, its banner, and the posted rental contract from outside the barrier. The sequence links the interruption to an identifiable contractor without pretending to prove who ordered it.", 0, 2, 1],
			["Rent a replacement generator for $80 and restart the carnival.", "Your $80 buys a staffed replacement generator. The lights blaze back on. The crowd roars as the Ferris wheel becomes a giant illuminated middle finger to the people trying to empty the square.", 2, 0, 1, -80]]],
		["THE MAN IN THE GOLDEN ROOSTER", "The auction boss arrives beneath the water tower wearing the mechanical rooster's salvaged head. He offers a sealed envelope containing $300 for your public withdrawal. Beside him, a courier holds the original auction register. Around you, phones rise like a field of tiny spotlights.", [
			["Make him open the register in front of the whole crowd.", "You refuse the envelope and insist on the register. Under hundreds of cameras, the courier reads the company names and sale conditions. You preserve the reading with witnesses. The rooster head suddenly looks very small.", 1, 3, 1],
			["Reject the cash and lead a thunderous vote of no confidence.", "Hands rise across the square. The boss cannot buy the sound of an entire town booing him in rhythm. His courier leaves with the register, but volunteers begin organizing a permanent defense fund.", 3, 0, 1],
			["Take the $300 and publicly abandon the campaign.", "The money is real. So is the silence when you announce your withdrawal. The boss shakes your hand for every camera. Whatever you do next, the town will remember this picture.", -3, -1, 3, 300]]],
		["THE MIDNIGHT DOCUMENT STAMPEDE", "The auction company announces that its local office closes at midnight. Dollies stacked with files roll toward a removal van. A paper shredder the size of a refrigerator waits beside the loading door. The crowd gathers outside the barrier, waiting for your next move.", [
			["Keep witnesses on the public pavement and record every departing box.", "You organize a numbered inventory from outside the barrier. Vehicle markings, box labels, and departure times become a trail that survives the move. The crowd stays clear; the footage keeps rolling.", 1, 3, 0],
			["Offer workers a public platform to refuse the destruction order.", "You call for anyone unwilling to shred the records to step forward. Several workers wheel their boxes back inside and demand written instructions. Cheers drown out the shredder. Their stand buys time, though you do not obtain the files.", 3, 1, 1],
			["Sell the boss your withdrawal from the vigil for another $150.", "You take $150 and leave. The remaining volunteers continue without you, recording your departure alongside the boxes. Your wallet is heavier; your place in the movement is almost gone.", -3, -2, 2, 150]]],
		["BRIAR GLEN GOES OFF SCRIPT", "Dawn. The wrecked rooster overlooks a square covered in pie tins, auction notices, and handwritten demands. The company has sent a negotiator. The residents have brought the record you helped create. This is the last microphone of the campaign. What do you ask the town to become?", [
			["Demand a public review backed by the preserved record.", "You lay the collected record on the table and demand that the claims survive independent scrutiny.", 0, 2, 0],
			["Build a residents' defense fund and refuse to leave anyone isolated.", "You hand the microphone to the families. The campaign becomes a standing organization instead of one person's spectacle.", 2, 0, 0],
			["Declare yourself the town's indispensable fixer.", "You pitch yourself as the person who can make this all go away. Every earlier bargain now stands beside you on the stage.", -1, 0, 2]]]
	]

static func index(w) -> int:
	return int(w.data.flags.get("chaos_chapter", 0))

static func available(w) -> bool:
	return index(w) < chapters().size()

static func start(w) -> String:
	w.data.scene = "chaos"
	w.data.locations["square"] = "Briar Glen square"
	w.player().location = "square"
	var c: Array = chapters()[index(w)]
	return str(c[0]) + "\n\n" + str(c[1]) + "\n\nCampaign so far: solidarity %d | evidence %d | notoriety %d." % [int(w.data.flags.get("chaos_solidarity", 0)), int(w.data.flags.get("chaos_evidence", 0)), int(w.data.flags.get("chaos_heat", 0))]

static func choices(w) -> Array:
	var result: Array = []
	var rows: Array = chapters()[index(w)][2]
	for i in range(rows.size()):
		var r: Array = rows[i]
		var cash: int = int(r[5]) if r.size() > 5 else 0
		if cash < 0 and int(w.player().finances.cash) < -cash:
			continue
		result.append({"id": "chaos_%d" % i, "label": r[0], "minutes": 15, "why": "Solidarity %+d; evidence %+d; notoriety %+d. Cash %+d. These totals shape the finale." % [r[2], r[3], r[4], cash]})
	return result

static func resolve(w, id: String) -> String:
	var r: Array = chapters()[index(w)][2][int(id.trim_prefix("chaos_"))]
	for pair in [["chaos_solidarity", 2], ["chaos_evidence", 3], ["chaos_heat", 4]]:
		w.data.flags[pair[0]] = int(w.data.flags.get(pair[0], 0)) + int(r[pair[1]])
	if r.size() > 5:
		w.player().finances.cash += int(r[5])
	w.record(str(r[1]), [w.data.player], "direct observation", false, "important", w.data.player)
	w.data.flags["chaos_choice_%d" % index(w)] = id
	w.data.flags.chaos_chapter = index(w) + 1
	w.data.scene = "town"
	var text: String = r[1]
	if available(w):
		text += "\n\nNEXT: " + str(chapters()[index(w)][0]) + ". The next crisis is ready whenever you are."
	else:
		var solidarity: int = int(w.data.flags.get("chaos_solidarity", 0))
		var evidence: int = int(w.data.flags.get("chaos_evidence", 0))
		var ending: String
		if solidarity >= 8 and evidence >= 8:
			ending = "THE TOWN THAT BIT BACK. Organized residents and a preserved record force the company to suspend the auction campaign pending review. The rooster becomes a community noticeboard. No miracle erases the debts, but nobody faces the collectors alone."
		elif evidence >= 8:
			ending = "THE PAPERWORK APOCALYPSE. Your record earns an independent review, but the divided town cannot agree on a collective response. You saved a trail worth following. Rebuilding trust will take longer."
		elif solidarity >= 8:
			ending = "REPUBLIC OF THE ROOSTER. Residents form a defense fund and keep the square. Missing records leave the collection dispute unresolved, but the company must now face an organized town."
		else:
			ending = "EVERYTHING MUST GO. The campaign fractures. The company continues pursuing its claims while neighbors argue over who sold whom out. The rooster remains, advertising an auction nobody wants to remember."
		if int(w.data.flags.get("chaos_heat", 0)) >= 10:
			ending += " Your face becomes the national symbol of the fiasco; strangers arrive to film the wreckage. Fame has brought another crowd to manage."
		w.data.flags.chaos_ending = ending
		text += "\n\n" + ending + "\n\nThe auction saga is complete. Nate's case and the rest of your life still carry their own consequences."
	return text
