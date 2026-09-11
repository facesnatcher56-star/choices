extends RefCounted
const Stakes = preload("res://scripts/choice_stakes.gd")
const Schedule = preload("res://scripts/town_schedule.gd")
## Authored, conditional storylets add human situations to the local simulation.
## Each one is offered once, only when its actors and prerequisites exist.

func catalogue() -> Dictionary:
	return {
		"luis_statement": {"day": 1, "actor": "luis", "place": "diner", "title": "Put my name on it", "text": "Luis Ortega kicks a grease-stained duffel bag under the vinyl booth, his knuckles raw from twenty years fighting forty-ton stamping presses. Luis covered your back on your first shift as supervisor when an unhinged die nearly crushed you, and he is the one brother on the line you trust with your life. He slides a torn sheet of yellow legal pad across the table under a diner mug. On the pad, he has scrawled a blow-by-blow record of Harold Voss frantically erasing Line 4's safety inspection log at 21:45.\n\n‘Voss has goons and corporate lawyers watching the plant gates,’ Luis whispers, his voice crackling with raw adrenaline. ‘If my legal signature hits this affidavit, Voss will try to blackball me out of every machine shop on the Eastern seaboard. But Nate's lying in trauma surgery with his arm torn open, and Voss wants to pin it on him. You're the night supervisor, Daniel. You tell me: if I sign this live grenade, are we going to war together, or are you going to let them feed me to the wolves?’", "responses": [
			["named", "Walk Luis and his signed bombshell straight into Cole's office.", 0, "respect", 8, "‘I won't lie to you, Luis—Voss is going to come at us with everything he has. But if we don't drop the hammer right now, Nate takes the fall and this whole town stays crooked.’ Luis locks eyes with you, a wild, reckless grin breaking through the exhaustion. He grabs your pen and signs his legal name with a sharp flourish: ‘Lock and load, Daniel. Let's take this straight to Cole.’"],
			["protect", "Shield Luis. Go after the red ledger yourself.", 0, "trust", 12, "You slide the yellow sheet back across the table. ‘Keep your name off the line, Luis. You've got three kids to feed. I'll break into Voss's office and photograph the ledger myself.’ Luis looks at you with profound brotherhood, pocketing the paper: ‘You're a madman, Dan. Watch your back—Voss keeps a baseball bat behind the filing cabinet.’"],
			["back_off", "Pull Luis out of the blast radius and sacrifice the lead.", 0, "affection", 6, "‘You've already stuck your neck out too far, Luis. Burn the paper.’ Luis stares at the yellow sheet, strikes a match, and drops the flaming paper into an empty diner mug. ‘I wanted someone to know the truth,’ he mutters, watching the ashes curl. ‘Even if we have to swallow it.’"]]},
		"school": {"day": 1, "actor": "chloe", "place": "home", "title": "Forty-five dollars", "text": "Chloe sprints into the kitchen, slamming her spiked running shoes onto the counter while breathless. Outside, county police cruisers howl past the driveway with sirens blazing. She slaps a fluorescent yellow athletic permission slip down beside your scalding coffee. The regional sprint invitational in Springfield: $45 registration and charter bus fee.\n\n‘Coach says the regional roster locks at third period!’ she gasps, pulling her hair into a tight ponytail. She glances at the scanner chattering about the plant disaster, then lowers her voice: ‘Look, Dad... I heard about Nate and the plant blowing up. If Voss is threatening to shut down your shift and we’re flat broke, just tell me. I can tell Coach I blew out my hamstring.’ She's daring you to be the dad who comes through.", "responses": [
			["pay", "Put $45 behind Chloe's championship run while the town implodes.", -45, "trust", 8, "You slap two crisp twenties and a five on the counter, signing your name with a sharp stroke. ‘You run hurdles, Chloe. You don't run from bills.’ Chloe lets out a joyful battle cry, grabbing the cash and leaping into a fierce hug: ‘Yes! Springfield won't know what hit 'em! Thanks, Dad!’ She bolts out the door like a lightning bolt."],
			["explain", "Lay the wreckage of the family budget on the table.", 0, "trust", 5, "You pull the slip over and look her in the eye: ‘Chloe, the plant is on the brink of an emergency shutdown, and our heating bill is overdue. Forty-five bucks is our entire grocery buffer.’ Chloe stops, her eyes flashing with mature grit: ‘Then just give it to me straight, Dad. I'd rather know the truth than have you make excuses.’"],
			["promise", "Make a promise with an empty wallet and a ticking deadline.", 0, "trust", 2, "You sign the permission line with an iron pledge: ‘Take the slip in, Chloe. Tell Coach I will hand-deliver forty-five cash before the team bus rolls out on Friday.’ Chloe scribbles *FRIDAY NOON DEADLINE* in neon purple across the header: ‘Two o'clock sharp, Dad. If you miss it, the bus leaves without me.’"],
			["dismiss", "Let the plant crisis swallow Chloe's dream. Tell her no.", 0, "resentment", 12, "You shove the paper aside: ‘Chloe, Nate's fighting for his life in trauma surgery and the plant is an active crime scene! I don't have time for high school track!’ Chloe's face hardens into stone. She snatches the form off the table: ‘Right. Plant drama first, daughter second. Same as always.’ The front door slams with a window-shaking bang."]]},
		"interview": {"day": 2, "actor": "erin", "place": "home", "title": "Two towns away", "text": "Erin is loading coffee beans into the grinder like shotgun pellets, the kitchen radio blasting news of federal inquiries at Mercer Works. She slaps an embossed interview confirmation from Millfield Technical onto the island counter. Two towns away—a high-speed forty-minute commute on state highway 4.\n\n‘They called while you were crashing, Daniel,’ Erin says, her eyes glowing with electric determination. ‘Head of operations wants me in Thursday morning. Forty-eight thousand starting salary, full gold-tier family medical, paid leave, and zero unhinged plant managers pulling mob strings. It means long highway miles, but it gives us a bulletproof escape hatch if Harold Voss burns Mercer Works to the ground.’", "responses": [
			["support", "Take command of the household so Erin can make her escape bid.", 0, "trust", 10, "You slam both hands on the island and grin: ‘You go knock their teeth down their throats, Erin! I’ll handle Chloe and hold the fort here!’ Erin bursts into a breathless laugh, throwing her arms around your neck: ‘God, Daniel, that's what I needed to hear! Let's build our own empire!’"],
			["listen", "Ask Erin what life beyond Harold's empire looks like.", 0, "affection", 8, "You sit beside her and ask what this job means to her. Erin stares out the window at the distant plant smoke, her voice steady and fierce: ‘I want a life where sirens don't mean my husband might be in a body bag. I want a future where our family holds all the cards.’"],
			["cost", "Build the escape budget together, down to the last gallon.", 0, "respect", 6, "You grab a pen and map out highway tolls, high-octane fuel, and truck maintenance. The expenses are heavy, but planning the financial assault together makes both of you feel untouchable."],
			["object", "Ask Erin to put her exit on hold for your collapsing workplace.", 0, "resentment", 15, "You tell her the timing is insane—with federal investigators on site and Harold making threats, she needs to stay in town. Erin's eyes flash with fury: ‘Stay in town for what, Daniel? To be Voss's hostage? I'm taking this shot with or without your blessing.’"]]},
		"contradiction": {"day": 2, "actor": "cole", "place": "station", "title": "Two accounts", "text": "Investigator Cole slams two exhibits onto the steel table under a swinging halogen bulb: Exhibit A is the employer incident report with your signed initial statement. Exhibit B is the blown-up 11x14 forensic photo of Line 4’s bypass wire crimped around the interlock switch. Cole clicks a heavy tape recorder, leaning in like a bulldog.\n\n‘Document A says Line 4 was factory-spec and safe. Exhibit B shows a premeditated 12-gauge hotwire bypass that nearly decapitated Nate Bell. You’re looking at six years in state penitentiary for filing fraudulent accident reports to shield Harold Voss, Daniel. I suggest you start talking before I call the county sheriff to cuff you.’", "responses": [
			["admit", "Detonate your own cover story before Cole does it for you.", 0, "respect", 6, "You look Cole dead in the eye: ‘Harold Voss threatened to fire me and blacklist my family if I didn't sign his whitewash. It was coercion, Cole, and I'm ready to blow his whole cover story wide open.’ Cole's pen scratches furiously across his pad: ‘That’s what I wanted to hear. Give me the ammunition and I’ll keep you out of lockup.’"],
			["uncertain", "Stake your answer on uncertainty while Cole studies the clock.", 0, "trust", -10, "You try to play dumb, claiming the screaming press and blood spray made the timeline hazy. Cole slams his clipboard onto the table with an explosive crack: ‘Don't insult my intelligence, Daniel! The metadata proves the bypass was live before Nate clocked in! You play cute with me and you'll do it from a jail cell!’"],
			["pressure", "Describe Harold’s request, without blaming him for the wire.", 0, "trust", 4, "You detail the exact shakedown: Harold cornering you by the lockers, spitting threats about mortgages and deadlines, while refusing to speculate on who physically twisted the copper. Cole nods with cold satisfaction: ‘Textbook supervisor extortion. This lines up with three other whistleblowers.’"],
			["pause", "Hit pause on the interrogation before another answer traps you.", 0, "trust", -3, "You stand up and demand a union representative before answering another question. Cole punches the stop button on the tape recorder with a heavy thud: ‘Fine, Daniel. But remember: the first guy who cooperates gets the immunity deal. Voss is talking to corporate lawyers right now.’"]]},
		"loyalty": {"day": 2, "actor": "harold", "place": "plant", "title": "A signature", "text": "Harold Voss drags you into his private office, locking two deadbolts and dropping the blinds. A police helicopter thumps somewhere in the low clouds above Briar Glen. Harold pulls a heavy steel lockbox from under his desk and drops an envelope stuffed with $150 in crisp fifties onto the mahogany, right over a pre-shift safety sign-off sheet.\n\n‘Corporate dispatched a rapid-response legal team,’ Harold barks, his hands trembling as he gulps cold black coffee. ‘Sign line four certifying the safety gate was locked out before Nate's shift. One signature, Daniel. You pocket a hundred and fifty bucks in untraceable cash, your family eats steak, and we stonewall OSHA until this storm blows over. Play ball with me, or I swear you'll never work in this state again.’", "responses": [
			["sign", "Sell Harold your signature for $150.", 150, "trust", 12, "You grab Harold's gold pen, sign your name across line four, and shove the envelope of cash into your coat. Harold gives an unhinged, triumphant laugh, slapping your shoulder: ‘I knew you had ice in your veins, Mercer! We run this plant, not the feds!’ The cash burns in your coat—you just committed felony conspiracy."],
			["refuse", "Push Harold's money back across the desk. Refuse the fiction.", 0, "resentment", 12, "You shove the cash right back into Harold's chest: ‘Shove your dirty money, Harold. I'm not perjuring myself for your crooked operation.’ Harold's face twists into pure rage, veins bulging in his throat: ‘You self-righteous punk! When corporate shutters Line 4, you’re the first body getting thrown under the bus!’"],
			["copy", "Take the unsigned trap home and inspect every clause.", 0, "trust", -15, "You snatch the rider and back toward the door: ‘I’m having my attorney look over this language before I sign anything.’ Harold lunges out of his chair: ‘That’s classified company property, Daniel! Bring that back here!’ But you’re already out the door and down the corridor."],
			["amend", "Gut the false claim with your pen before Harold can buy it.", 0, "respect", 5, "You slash a bold red line through the safety clause, write *LINE 4 HOTWIRED WITHOUT SUPERVISOR CONSENT*, and sign below. Harold stares at the defaced document, his eyes bulging: ‘You just lit our payroll on fire to make a grandstand play! Get off my floor!’"]]},
		"nate_bill": {"day": 2, "actor": "nate", "place": "hospital", "title": "The cost of recovery", "text": "Nate Bell is propped up in his hospital bed, surrounded by tangled IV lines and a blizzard of denied workers' comp notices. A surgical brace encases his mangled right arm in carbon steel. He's smashing the bedside remote against the mattress in furious agony as news anchors talk about Mercer Works on the muted TV.\n\n‘Mercer Works’ insurer retroactively canceled my medical rider!’ Nate roars, veins pulsing along his scarred neck. ‘The pharmacy is holding ninety dollars worth of high-potency nerve blockers hostage at the front desk, and I’ve got sixty bucks to my name! Voss’s lawyers are already trying to paint me as an unhinged tweaker who cut his own machine! How the hell am I going to survive this, Dan?!’", "responses": [
			["money", "Put $60 between Nate and the financial meat grinder.", -60, "trust", 10, "You slap three crisp twenty-dollar bills onto the sheets: ‘Take it, Nate. Go buy the pills and feed your family. No payback, no strings. We fight Voss together.’ Nate stares at the money, a choked sob breaking from his throat as he clutches your arm: ‘You're a real brother, Dan. Voss will burn for this!’"],
			["forms", "Attack the insurance paperwork with Nate. Make the system answer.", 0, "respect", 8, "You pull up a stool, rip open the legal envelopes, and spend ninety frantic minutes filling out emergency state trauma relief and whistleblower hardship forms. By the time you're done, the state express courier is dispatched. Nate breathes a sigh of pure relief: ‘You just saved my life, Dan.’"],
			["hear", "Stay in the room and take the full force of Nate's anger.", 0, "affection", 6, "You stay by the bed, letting Nate scream out his rage, fear, and betrayal until the panic monitor stops beeping. You don't sugarcoat the chaos; you stand shoulder-to-shoulder with him in the fire."],
			["distance", "Abandon Nate's crisis to defend your own collapsing life.", 0, "resentment", 9, "You step back toward the door: ‘Nate, federal agents are raiding my house and my own heating is getting cut. I can't take on your hospital bills.’ Nate's eyes turn to cold daggers: ‘Right. Company supervisor bails when the blood starts pouring. Get lost, Mercer.’"]]},
		"matt_van": {"day": 3, "actor": "matt", "place": "diner", "title": "A borrowed tomorrow", "text": "Matt is pacing like a maniac beside the jukebox at the Juniper Diner, his leather jacket drenched in grease and motor oil. A smoking starter motor sits directly on the vinyl bench beside a $120 emergency garage estimate. State troopers are parked across the street, lights flickering.\n\n‘Dan, I’m in the deepest hole of my life!’ Matt gasps, pulling you into the booth by your collar. ‘My delivery van blew its starter on route 9 loaded with five crates of high-priority racing nitrous! If I miss the noon drop-off in Scranton, the dispatch company will void my contract and send repo muscle after my wheels! I need a hundred and twenty bucks cash right now to buy this replacement starter, or I'm completely finished!’", "responses": [
			["lend", "Stake $120 on Matt's comeback. Get the debt in writing.", -120, "trust", 8, "You slap six twenties onto the laminate table and shove a diner napkin at him: ‘Sign the napkin, Matt. You pay me back by the fifteenth or I impound your nitrous myself.’ Matt scribbles his signature with wild, manic gratitude: ‘I swear on everything, Dan! You just saved my skin!’"],
			["ride", "Engineer a delivery comeback around Matt's dead van.", 0, "respect", 7, "You grab your truck keys: ‘I’m not giving you cash, but throw those crates into the back of my pickup. We’re running this Scranton delivery together right now.’ Matt’s jaw drops: ‘You’re crazy, Dan! Let’s haul ass!’ You burn rubber down route 9, saving his contract with pure horsepower."],
			["decline", "Tell Matt the family rescue fund is empty.", 0, "trust", 3, "You shake your head: ‘Matt, I have an overdue heating notice and federal investigators watching my driveway. I can’t fund your emergencies.’ Matt kicks the jukebox in bitter fury: ‘Big shot supervisor! When the chips are down, you leave your own brother to drown!’ He storms into the storm."],
			["blame", "Turn the diner booth into a showdown over Matt's disasters.", 0, "resentment", 12, "You slam the invoice onto the counter: ‘Racing nitrous on route 9?! Are you out of your mind?! When are you going to stop running criminal stunts and act like an adult?!’ Matt glares at you with burning hatred: ‘Save the lecture for church, Dan!’ He grabs the starter and bolts."]]},
		"meeting": {"day": 3, "actor": "luis", "place": "diner", "title": "The people on the rota", "text": "The entire graveyard shift—ten burly machinists, pipefitters, and hydraulic techs—has taken over the back room of the Juniper Diner. Mercer Works has just declared a plant-wide lockout and slashed everyone's wages to zero! Luis Ortega stands at the head of the table, slamming a heavy steel pipe wrench down like a gavel!\n\n‘Voss just locked the gates and hired private security guards from Philadelphia to keep us off the floor!’ Luis bellows, eyes blazing. ‘They want to starve us out so we don't testify to OSHA! We’ve drafted a wildcat strike declaration demanding full hazard pay and Voss’s immediate removal! But nobody will take a crew revolt seriously unless our night supervisor signs the top of the petition!’ All ten workers lock their eyes on you.", "responses": [
			["join", "Put your signature at the front of the workers' challenge.", 0, "trust", 10, "You snatch the pen from Luis and write *Daniel Mercer — Night Shift Supervisor* in giant block letters at the top of the strike petition! The room explodes into an earth-shaking roar! Pressmen pound the tables, Luis hoists his wrench in triumph: ‘The line holds! Mercer's leading the charge!’"],
			["quiet", "Write the challenge from the shadows. Keep your name out.", 0, "respect", 4, "You sharpen their legal language, inserting clauses on OSHA emergency worker protections, but decline to sign: ‘If Voss sees my name first, he gets an injunction. Let the floor crew take the frontline.’ Luis nods in shrewd tactical agreement: ‘Smart play, Dan. We hit him from both sides.’"],
			["wait", "Ask a furious room to hold fire until the findings arrive.", 0, "trust", -4, "You urge the men to stand down until Cole wraps up his federal inquiry. A massive press operator named Biggs spits on the floor: ‘Stand down?! My landlord is serving an eviction notice tomorrow while you sit on your supervisor salary! You're with management!’"],
			["leave", "Walk away from the workers to defend your own paycheck.", 0, "resentment", 8, "You push your chair back and head for the door: ‘I can’t be caught at an illegal strike rally.’ Boos, curses, and flying paper napkins chase you out into the gravel lot."]]},
		"neighbor": {"day": 4, "actor": "rebecca", "place": "home", "title": "An ordinary kindness", "text": "A heavy knock rattles the kitchen door amidst howling winds and swirling sleet. It’s Rebecca Shaw, your shotgun-toting, straight-shooting neighbor from down the ridge. She stomps snow off her tactical boots, hoisting a massive, steaming cast-iron casserole dish of turkey, dumplings, and melted cheddar in one arm, with a pump-action shotgun slung over her shoulder.\n\n‘I saw state police cruisers circling your cul-de-sac like vultures, Daniel,’ Rebecca says with a razor-sharp smirk. ‘And I know Voss’s repo thugs have been sniffing around. I brought enough hot food to feed an army, and my spare room has reinforced locks if Chloe needs a safehouse while you take Voss down.’", "responses": [
			["accept", "Welcome Rebecca and her casserole into the family command post.", 0, "affection", 10, "You pull the door wide, take the piping-hot feast, and welcome her into the warm kitchen. Rebecca sits with Chloe, coaching her on school exams while you and Erin inhale the best meal you’ve had in weeks. For tonight, your house is an impenetrable fortress."],
			["share", "Tell Rebecca how close the household is to going under.", 0, "trust", 7, "You confess how close the family is to the edge—the frozen heating bills and the threat of total plant closure. Rebecca tosses a brass key onto the counter: ‘My generator is wired for winter. If your heat gets cut, your family moves into my place. Nobody messes with my neighbors.’"],
			["private", "Accept the emergency casserole. Keep your secrets locked down.", 0, "respect", 3, "You thank her gratefully, take the casserole, but keep the door cracked: ‘We love the food, Rebecca, but things might get noisy around here tonight.’ She nods with tactical respect: ‘Understood. Keep your powder dry, Dan.’"],
			["reject", "Send the cavalry home. Let pride guard the front door.", 0, "trust", -6, "Stubborn pride takes over: ‘We don't need charity or armed guards, Rebecca.’ Rebecca’s face hardens: ‘It’s not charity, it’s survival, you stubborn mule.’ She stomps back through the snow with the hot dish, leaving the porch freezing."]]},
		"promise_due": {"day": 4, "actor": "chloe", "place": "home", "title": "You said Friday", "text": "Friday morning, 07:15 AM. Chloe stands in the front hallway in her Springfield track uniform, spikes slung over her shoulder, tapping her foot with intense anticipation. Outside, the morning sky is ablaze with golden light. The yellow slip in her hand reads *FRIDAY NOON DEADLINE* in bold purple marker.\n\n‘The Springfield team bus engines are idling in the school lot right now, Dad,’ Chloe says, looking straight into your eyes with absolute, unblinking focus. ‘Coach needs the cash envelope on his clipboard by second period. Did you get the forty-five dollars, or am I staying behind while my team goes to state?’", "responses": [
			["pay", "Deliver the $45 before the championship deadline slams shut.", -45, "trust", 10, "You whip out a fresh fifty-dollar bill and slap it into her hand, winking: ‘Keep the change for victory burgers, kid. Go burn up that Springfield track.’ Chloe lets out an ecstatic scream, throwing her arms around you in a flying tackle hug: ‘You're the best dad on earth! I’m winning that gold medal for you!’ She charges down the driveway at full sprint!"],
			["sorry", "Own the broken promise. Tell Chloe the money never materialized.", 0, "trust", -5, "You drop to one knee with an aching chest: ‘Chloe... between the emergency utility bills and the plant shutdown, I couldn't scrape the forty-five together. I'm so sorry, sweetheart.’ Chloe bites her lip, blinking back furious tears: ‘I get it, Dad... the plant always wins.’ She walks toward the bus stop with slumped shoulders."],
			["ask", "Face Chloe's disappointment without a shield or an excuse.", 0, "affection", 2, "You sit with her on the porch steps, talking through the terrifying pressure of the week. Chloe cries on your shoulder, admitting how scared she is that Harold Voss is going to ruin everything. You hold her tight, promising her that the family will rise above it."],
			["deny", "Rewrite your own promise to Chloe's face.", 0, "resentment", 20, "You snap that you never made a firm promise and that she needs to stop being so demanding. Chloe stares in utter disbelief, her jaw trembling with fury: ‘You looked me in the eye and swore you'd have the cash! You're a liar, Dad!’ She kicks the storm door wide open and storms into the morning."]]},
		"erin_offer": {"day": 5, "actor": "erin", "place": "home", "title": "A letter from Millfield", "text": "An armored courier van idles in the gravel driveway as Erin throws open a certified express packet at the kitchen table. Gold-embossed letterhead gleams under the chandelier: Millfield Operations — Official Employment Contract. Forty-eight thousand salary, executive healthcare coverage, and stock options.\n\n‘They accepted my terms, Daniel!’ Erin shouts, waving the documents with triumphant ecstasy. ‘Full benefits starting Monday! We can tell Harold Voss to go straight to hell! But it means highway 4 every single day, sixty miles an hour, five days a week. We take this leap together right now and blow the dust off our lives, or we stay rotting in Briar Glen forever!’", "responses": [
			["celebrate", "Celebrate Erin's breakthrough. Back her escape from the mill.", 0, "trust", 15, "You scoop Erin off her feet in a spinning bear-hug, popping the cork on a kitchen cider bottle: ‘Sign that damn paper right now! We are breaking out of this cage together!’ Erin laughs with tears streaming down her face: ‘We did it, Dan! We beat them!’"],
			["practical", "Turn the family calendar into a plan for life beyond Voss.", 0, "respect", 8, "You grab the calendar and organize a high-speed logistical schedule: carpooling, bus runs, meal preps, and fuel stops. Seeing the master plan come together turns a scary change into an unstoppable mission."],
			["fear", "Let panic speak: ask whether Erin's escape includes leaving you.", 0, "affection", -5, "Insecurity creeps in: ‘Is this just your golden ticket to leave me behind in this mill town?’ Erin's joy turns into bitter heartbreak: ‘I'm trying to lift our family out of the dirt, Daniel, and you think I'm running away? How little you know me.’"],
			["refuse", "Try to slam the door on Erin's new life.", 0, "resentment", 18, "You slam your fist on the table, demanding she reject the offer to stay in town. Erin’s gaze turns into pure arctic ice. She slowly caps her pen, sliding the contract into her purse: ‘I asked for your blessing, Daniel. I don't need your permission.’"]]},
		"harold_cornered": {"day": 5, "actor": "harold", "place": "diner", "title": "Across the linoleum", "text": "Harold Voss kicks open the door of the Juniper Diner, looking like a manic fugitive. His trench coat is soaked in freezing rain, his tie is ripped, and his eyes bulge with unhinged desperation. He slides into the booth, smelling of black coffee and burnt wiring, clutching a heavy crowbar under his coat.\n\n‘The state forensic task force is executing a search warrant on Mercer Works at dawn, Daniel!’ Harold hisses, slamming his fists on the table. ‘They're bringing hydraulic engineers to rip open Line 4! If that pre-shift maintenance log stays in the booth, I go to federal prison and corporate liquidates the plant! You have the master keys to the tool crib. Break in with me tonight and torch that ledger! One gallon of kerosene, Daniel! Thirty jobs saved and we walk away clean! Do it or we both burn!’", "responses": [
			["refuse", "Refuse Harold's midnight evidence bonfire to his face.", 0, "resentment", 15, "You grab Harold's wrist and stare straight through him: ‘I'm not committing arson to save your skin, Harold. You hotwired that press, you maimed Nate, and you're going down for it.’ Harold's face contorts with rabid hatred: ‘You traitorous bastard! I built this town and I will drag you down to the boiler room with me!’ He knocks his chair over and flees into the downpour!"],
			["bargain", "Counter Harold's panic with a demand for worker protection.", 0, "respect", 6, "You lean across: ‘Deposit six months of full wages into escrow for every floor worker right now, or I walk straight to Cole.’ Harold laughs like a madman: ‘Corporate would execute me before they pay severance! You’re out of your mind!’"],
			["leave", "Leave Harold alone with his crowbar and collapsing scheme.", 0, "trust", -5, "You slide out of the booth, toss down two dollars for coffee, and leave Voss muttering to himself in the shadows of the diner."]]},
		"strike_vote": {"day": 6, "actor": "luis", "place": "plant", "title": "The front gate", "text": "The entrance to Mercer Works is an all-out battleground! Sleet lashes against forty floor workers, mechanics, and welding crews blockading the main gate with burning oil drums and steel scaffolding! Two charter buses filled with corporate replacement scabs are trapped on the access road, their headlights glaring through the frozen mist. Luis Ortega stands on an overturned forklift, screaming into a siren megaphone!\n\n‘Corporate brought in union-busters to fire Nate Bell and restart the death trap!’ Luis bellows, his voice echoing across the valley! ‘They think Briar Glen is going to roll over! We vote right now: do we weld these gates shut in a full wildcat strike, or do we crawl back in like dogs?! Daniel Mercer is our supervisor—what’s the call, Dan?!’ Every single worker raises their wrench and awaits your command!", "responses": [
			["picket", "Stand at the barricade. Put your name behind the strike.", 0, "trust", 12, "You leap onto the forklift bumper, grab a flare, and ignite it into a roaring red torch: ‘WELD THE GATES SHUT! STRIKE!’ A deafening roar shakes the valley as workers cheer, beating tire irons against the drums! Luis pumps his fist in ecstatic brotherhood: ‘WE HOLD THE LINE!’"],
			["mediate", "Walk between the factions and demand one last negotiation.", 0, "respect", 6, "You plead through the megaphone for two hours to confront Voss before shutting the plant down. Luis shakes his head grimly: ‘Voss doesn't negotiate with men he thinks he owns, Dan. But if you want to try, godspeed.’"],
			["walk", "Leave the line for your family while the crew watches.", 0, "resentment", 10, "You turn your back on the barricade and walk toward your truck. Chants of ‘Scab!’ and cold jeers echo through the freezing rain as you start the engine."]]},
		"the_reckoning": {"day": 6, "actor": "cole", "place": "station", "title": "The closed file", "text": "Investigator Cole’s headquarters is surrounded by state police cruisers and flashing strobe lights. Inside, Cole stands behind a mountain of sealed evidence boxes, forensic photography albums, and impounded machine blueprints. He drops a massive, gold-stamped binder onto the desk with an earth-shattering thud: *DEPARTMENT OF LABOR & JUSTICE — THE MERCER WORKS STAMPING INCIDENT*.\n\n‘The state inquiry is officially locked down, Daniel,’ Cole says, lighting a cigar with steady, hardened calm. ‘Every photo of that hotwired bypass, every doctored inspection sheet, every tap on Voss's burner phone, and your testimony have been entered into the federal record. The grand jury is being convened. What you did this week determined who goes to federal prison, what Nate Bell gets for his arm, and whether Mercer Works survives.’", "responses": [
			["listen", "Hear the official findings and accept what comes next.", 0, "respect", 8, "You stand tall as Cole reads the damning findings: deliberate mechanical sabotage, supervisor extortion, and corporate liability. The truth stands bulletproof."],
			["ask", "Ask what will happen to Harold Voss and the plant.", 0, "trust", 5, "You ask about Voss's fate. Cole smiles like a shark: ‘Voss was arrested thirty minutes ago trying to board a flight to Montreal with two suitcases of cash. The plant is under federal receivership.’"],
			["silence", "Sign the receipt of notice without a word.", 0, "trust", 2, "You take the silver pen and sign the state receipt with absolute composure. The week of chaos and steel has come to an end."]]}
	}

func available(w) -> Array[String]:
	var result: Array[String] = []
	if w.data.scene != "town" or w.flag("week_complete"):
		return result
	var day = int(w.data.minute / 1440)
	for key in catalogue():
		var e: Dictionary = catalogue()[key]
		if day < e.day or w.flag("encounter_" + key) or e.actor == w.data.player or not w.data.characters[e.actor].alive:
			continue
		if key in ["school", "promise_due"] and not w.data.player in ["daniel", "erin"]:
			continue
		if key in ["interview", "contradiction", "loyalty", "matt_van"] and w.data.player != "daniel":
			continue
		if key == "luis_statement" and (w.data.player != "daniel" or w.flag("luis_spoke") or w.flag("log_shared")):
			continue
		if key == "interview" and not w.flag("job_applied"):
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
		if key == "the_reckoning" and day < 6:
			continue
		result.append(key)
	return result

func start(w, key: String) -> String:
	var e: Dictionary = catalogue()[key]
	w.data.flags["encounter_" + key] = true
	w.data.flags.encounter = key
	w.data.scene = "encounter"
	w.player().location = e.place
	w.data.characters[e.actor].location = e.place
	if key == "interview":
		w.record("Erin told Daniel she applied for the job two towns away.", ["erin", "daniel"], "Erin’s disclosure", false, "important", "erin")
	var text: String = e.text
	if not w.flag("introduced_" + w.data.player + "_" + e.actor):
		var context = Stakes.connection(w, e.actor)
		if not context.is_empty():
			text = context + "\n\n" + text
		w.data.flags["introduced_" + w.data.player + "_" + e.actor] = true
	var stakes = Stakes.encounter_stakes(key)
	if not stakes.is_empty():
		text += "\n\n" + stakes
	if key == "the_reckoning":
		text = "Cole sets the week's file on his desk. ‘Let's take stock of what has actually reached this office.’" if w.flag("case_open") else "Cole opens the incident report. ‘We have no formal safety investigation underway. We can review what was reported, but I cannot announce findings we haven't established.’"
	return w.data.locations[e.place] + "\n\n" + text

func trigger(w) -> String:
	for key in available(w):
		# A local scene may follow an activity, but never changes its destination.
		if key != "the_reckoning" and catalogue()[key].place == w.player().location:
			if Schedule.encounter_open(w, key, catalogue()[key], w.data.minute):
				return start(w, key)
	return ""

func choices(w) -> Array:
	var result: Array = []
	var e: Dictionary = catalogue()[w.data.flags.encounter]
	if not Schedule.encounter_open(w, w.data.flags.encounter, e, w.data.minute):
		return [{"id": "return_later", "label": "Arrange to continue when you can both be here.", "minutes": 5, "why": "This conversation cannot continue outside the person's available hours."}]
	if w.data.flags.encounter == "the_reckoning":
		return [{"id": "listen", "label": "Review the week's record and finish this chapter.", "minutes": 35, "why": "Summarizes the evidence and your choices. Unfinished conversations will close; ordinary town life can continue."}, {"id": "later", "label": "Come back after finishing other conversations.", "minutes": 5, "why": "Leaves the week's review available at the safety office."}]
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
	for c in result:
		var motive = Stakes.response_stakes(w.data.flags.encounter, c.id)
		if not motive.is_empty():
			var row: Array = e.responses.filter(func(r): return r[0] == c.id)[0]
			var cost = maxi(0, -int(row[2]))
			c.why = motive + (" Costs $%d; any cash shortfall becomes debt." % cost if cost > 0 else "")
		if w.data.flags.encounter == "matt_van" and c.id == "ride":
			c.minutes = 120
		if w.data.flags.encounter == "nate_bill" and c.id == "forms":
			c.minutes = 90
		if w.data.flags.encounter == "luis_statement" and c.id == "named":
			c.minutes = 90
	result = result.filter(func(c): return Schedule.encounter_open(w, w.data.flags.encounter, e, w.data.minute, c.minutes) and (w.data.flags.encounter != "luis_statement" or c.id != "named" or Schedule.person_available("cole", w.data.minute, c.minutes)))
	return result

func resolve(w, id: String) -> String:
	var key: String = w.data.flags.encounter
	if id == "return_later":
		w.data.flags["encounter_" + key] = false
		w.data.scene = "town"
		return "You leave the conversation unfinished and agree to return during available hours."
	if key == "the_reckoning" and id == "later":
		w.data.flags.encounter_the_reckoning = false
		w.data.scene = "town"
		return "Cole closes the folder for now. ‘Come back when you're ready to review it.’"
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
	w.data.flags["decision_" + key] = id
	w.data.flags["decision_day_" + key] = int(w.data.minute / 1440)
	w.record(w.player().name + " chose to: " + r[1], [w.data.player, e.actor], "direct conversation about " + e.title, false, "important", w.data.player)
	if key == "luis_statement":
		if id == "named":
			w.data.flags.luis_spoke = true
			w.data.flags.luis_named = true
			w.player().location = "station"
			w.data.characters.luis.location = "station"
			w.data.characters.cole.location = "station"
			w.record("Luis gave Cole a signed account of the blank inspection line he saw before the accident.", ["daniel", "luis", "cole"], "signed witness statement", false, "important", "luis")
		elif id == "protect":
			w.data.flags.luis_protected = true
			w.record("Luis says the maintenance log had a blank inspection line before the accident.", ["daniel", "luis"], "private recollection", true, "important", "luis")
	if key == "neighbor" and id in ["accept", "share"]:
		w.data.flags.family_refuge = true
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
	if key == "matt_van" and id == "ride":
		w.data.flags.matt_delivery_plan = true
		w.data.flags.matt_contract_saved = true
		w.record("Matt arranged shared delivery routes and retained his courier contract.", [w.data.player, "matt"], "delivery arrangement", false, "important", "matt")
	if key == "nate_bill" and id == "money":
		w.data.characters.nate.finances.cash += 60
	if key == "nate_bill" and id == "forms":
		w.data.flags.nate_claim_filed = true
		w.record("Nate submitted the benefit forms with Daniel's help; the claim is awaiting review.", [w.data.player, "nate"], "benefit claim receipt", false, "important", "nate")
	if key == "school" and id == "dismiss" or key == "promise_due" and id == "deny":
		w.data.characters.chloe.beliefs.append({"belief": "Promises about money are difficult to rely on.", "source": w.data.events.back().id, "confidence": 0.7})
	w.data.scene = "town"
	if key == "the_reckoning":
		return finish_week(w)
	return r[5]

func finish_week(w) -> String:
	var lines: Array[String] = ["THE WEEK'S RECORD"]
	var investigated = w.flag("case_open")
	if investigated:
		if not w.flag("plant_closed"):
			w.data.flags.plant_closed = true
			w.record("The plant suspended production pending corrective safety work.", w.data.characters.keys(), "public review notice", false, "important", "harold")
		lines.append("The safety inquiry is still open. Cole can summarize the accounts and documents received, but cannot promise final findings after one week. Production remains suspended pending the safety review. Responsibility for installing the wire remains unproven.")
	else:
		lines.append("The incident report remains inconclusive. No formal safety findings or citations have been established. The person who installed the wire is still unknown.")
	for item in [["evidence_shared", "Your photograph preserved the bypass as it appeared that night."], ["log_shared", "The maintenance-log account is included, with its limits recorded."], ["luis_spoke", "Luis's statement documents the pressure to coordinate accounts."], ["recording_shared", "The voice memo documents Harold's response to being recorded; it contains no confession."], ["statement_careful", "Your statement explicitly separates observations from assumptions."], ["signed_form", "Your signed inspection claim remains on file; it cannot be treated as a verified inspection."]]:
		if w.flag(item[0]):
			lines.append(item[1])
	if w.flag("lied"):
		lines.append("Your correction accompanies the original misleading statement." if w.flag("corrected") else "Your misleading statement remains uncorrected. It has not become established fact.")
	if w.flag("blamed"):
		lines.append("The allegation against Nate remains unsupported; he remembers who made it.")
	if w.flag("delayed_statement") and not w.flag("statement_completed"):
		lines.append("The fuller statement you deferred was never supplied.")
	lines.append("Matt kept his delivery contract through the shared-route plan." if w.flag("matt_delivery_plan") else ("Your loan helped Matt fund his van repair." if w.flag("matt_loan_given") else "Matt received no repair loan or alternative delivery plan from you."))
	if w.flag("job_accepted"):
		lines.append("Erin accepted the Millfield job. " + ("You made a household plan together." if str(w.data.flags.get("decision_erin_offer", "")) in ["celebrate", "practical"] else "The household arrangements still need a conversation."))
	elif w.flag("job_offered"):
		lines.append("Erin's job offer remains unresolved between you.")
	if w.data.flags.bills.school.status == "paid":
		lines.append("Chloe did not have to give up the trip to make room for the adults' crisis. You kept that part of her week intact.")
	elif w.flag("school_promised"):
		lines.append("Chloe is still carrying the promise about the trip that you did not keep.")
	if w.flag("family_refuge"):
		lines.append("Rebecca's spare key gave your family someone else to turn to.")
	for key in ["meeting", "strike_vote", "luis_statement", "nate_bill"]:
		if w.data.flags.has("outcome_" + key):
			lines.append(w.data.flags["outcome_" + key])
		elif w.data.flags.has("decision_" + key):
			var decision: String = w.data.flags["decision_" + key]
			var response: Array = catalogue()[key].responses.filter(func(row): return row[0] == decision)[0]
			lines.append("You chose to: " + str(response[1]) + " The crew's response is still pending and can arrive if you continue town life.")
	w.data.flags.case_closed = false
	w.data.flags.case_open = investigated
	w.data.flags.week_complete = true
	w.data.flags.week_summary = "\n\n".join(lines)
	w.record(w.data.flags.week_summary, [w.data.player, "cole"], "week review", false, "important", "cole")
	return w.data.flags.week_summary + "\n\nEND OF ONE BAD WEEK\n\nYou can continue ordinary town life, or start a new story from the menu."
