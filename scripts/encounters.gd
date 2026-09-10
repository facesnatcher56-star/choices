extends RefCounted
const Stakes = preload("res://scripts/choice_stakes.gd")
const Schedule = preload("res://scripts/town_schedule.gd")
## Authored, conditional storylets add human situations to the local simulation.
## Each one is offered once, only when its actors and prerequisites exist.

func catalogue() -> Dictionary:
	return {
		"luis_statement": {"day": 1, "actor": "luis", "place": "diner", "title": "Put my name on it", "text": "Luis Ortega slides a folded sheet of yellow legal pad across the vinyl booth, his dark eyes darting to the diner door as the bell chimes. He rubs the faded eagle tattoo on his forearm, his calloused knuckles scarred from twenty years on industrial presses. On the pad, he has written down the blank line he saw in the pre-shift inspection book before Nate's shift. The signature line at the bottom is completely empty.\n\n‘Harold knows every single man who was clocked in on graveyard,’ Luis whispers, his jaw tight as he watches your supervisor's badge. ‘If my legal signature goes on this paper, Harold will make sure I can’t get hired to sweep parking lots in this county. You know what happened to Pete Jackson when Pete called the county inspectors. You're the night supervisor, Daniel. You tell me: if I sign this, do you stand with me or do you leave me to hang?’", "responses": [
			["named", "Ask Luis to sign it. Take the statement to Cole together.", 0, "respect", 8, "‘I won't lie to you, Luis. I can't guarantee Harold won't try to hurt us. But if we don't stand together, he buries Nate's life and nothing ever changes.’ Luis stares at you for five agonizing seconds, searching your face for any hint of deceit. His hand trembles as he takes your pen and signs his full legal name. ‘Don't leave me out in the cold, Daniel.’ At the county safety office, Cole takes his signed affidavit in person."],
			["protect", "Keep his name out of it. Check the log yourself.", 0, "trust", 12, "You slide the unsigned sheet back across the laminate table. ‘Keep your name clear, Luis. You've got kids to feed. I'll get into the supervisor booth and put my own signature on the line.’ Luis's shoulders sag in profound relief; he folds the yellow paper into his canvas jacket and nods with deep gratitude. You know what to look for, but the target will be on your back."],
			["back_off", "Tell him he has already risked enough. Let the lead go.", 0, "affection", 6, "‘You've already put too much on the line just meeting me here, Luis. Let it go.’ Luis stares down at the yellow paper, then slowly tears it into four pieces, dropping them into his cold coffee. ‘I needed someone to know the truth,’ he mutters, eyes hollow. ‘Even if the truth dies right here in this booth.’ Understanding does not give Cole a witness."]]},
		"school": {"day": 1, "actor": "chloe", "place": "home", "title": "Forty-five dollars", "text": "Chloe lingers by the kitchen table after clearing her breakfast bowl, nervously chewing her bottom lip. She slides a yellow permission slip between your coffee mug and the salt shaker. Her track team is heading to the regional invitational in Springfield. Bus fee and meet registration: $45.\n\n‘Coach says the bus fee is due by third period,’ she says, keeping her hands tucked inside her oversized hoodie sleeves. She watches your eyes carefully, reading the tension in your face before adding in a quiet rush: ‘I mean... I can just tell him I twisted my ankle. It’s no big deal if money’s tight right now.’ She is offering you an easy way out, watching to see whether you take it.", "responses": [
			["pay", "Pay for the school trip.", -45, "trust", 8, "You pull out your wallet and count out forty-five dollars, smoothing the bills flat on the table, and sign your name on the permission line. Chloe's face lights up with sheer, unburdened relief. ‘Thanks, Dad!’ She hugs your neck quickly before stuffing the form into her backpack. For a morning, she gets to worry about running hurdles instead of her family's bankruptcy."],
			["explain", "Explain the money situation without blaming her.", 0, "trust", 5, "You pull the permission slip closer and meet her eyes honestly. ‘Chloe, we’re two weeks behind on the furnace oil, and Dad’s hours at the plant are up in the air. I want you to run, but forty-five dollars is half our grocery money this week.’ Chloe looks down at her worn sneakers, swallowing hard. ‘Then just tell me no, Dad. Don’t make me lie to Coach and pretend I didn’t care.’"],
			["promise", "Promise you will find the money soon.", 0, "trust", 2, "You sign the slip and hand it back with a determined nod. ‘Take the form in, Chloe. Tell Coach I'll bring the cash to the athletic office before the bus rolls out on Friday.’ Chloe writes *FRIDAY - CASH* in purple pen across the margin. ‘Before two o’clock, Dad. That’s when the bus leaves.’ The promise is stamped with an unforgiving deadline."],
			["dismiss", "Tell her there are bigger problems right now.", 0, "resentment", 12, "You push the slip away with an exhausted wave of your hand. ‘Chloe, Nate is in trauma surgery and the whole plant might get shut down. I don’t have time to worry about track buses right now.’ Chloe’s eyes flash with sudden, bitter tears. She snatches the form off the table. ‘Right. It’s always Mercer Works first.’ She slams the back door on her way out to the bus stop."]]},
		"interview": {"day": 2, "actor": "erin", "place": "home", "title": "Two towns away", "text": "Erin sits at the kitchen island, smoothing out a printed email confirmation from Millfield Accounting Services. Two towns over—a forty-minute drive each morning on state highway 4. Her fingers are steady, but her breath is shallow.\n\n‘They called while you were sleeping, Daniel,’ Erin says, looking straight into your eyes without blinking. ‘Preliminary interview on Thursday. It’s forty-eight thousand a year with family dental and health coverage. I know the commute is rough. But I need something of our own that Harold Voss can’t threaten to take away.’", "responses": [
			["support", "Offer to handle the morning so she can go.", 0, "trust", 10, "You reach across the counter and take her hand, squeezing her fingers. ‘You take that interview, Erin. I’ll make sure Chloe gets to school and dinner is ready when you get back.’ Erin’s breath shudders, her guarded posture melting into warm gratitude. ‘Thank you, Daniel. I needed to know we were still partners in this.’"],
			["listen", "Ask what she wants from the job.", 0, "affection", 8, "You sit beside her and ask her what she hopes this job will feel like. Erin looks out the window at the gray November sky, a faint smile touching her lips. ‘I want to walk into a clean building where nobody screams over stamping quotas. I want to earn a paycheck that isn't paid in blood and secrets.’"],
			["cost", "Work through the travel costs together.", 0, "respect", 6, "You grab a notepad and run the numbers together: highway gas, tolls, extra maintenance on the truck. The expenses take a chunk out of the salary, but seeing the figures laid out in black and white gives both of you a shared anchor."],
			["object", "Ask her to stay until the trouble at work settles.", 0, "resentment", 15, "You tell her the timing is impossible—with the investigation swirling and shift cuts coming, the family needs her home. Erin’s jaw tightens. She snaps her laptop shut with a loud click. ‘There is always an excuse to stay trapped in Briar Glen, Daniel. Always.’"]]},
		"contradiction": {"day": 2, "actor": "cole", "place": "station", "title": "Two accounts", "text": "Investigator Cole lays two documents side-by-side on the green felt blotter of his desk: the company incident notification with your initial statement, and the 8x10 glossy photograph of Line 4’s bypassed guard. He doesn't raise his voice; he simply taps a silver mechanical pencil against the desk blotter in a slow, rhythmic cadence.\n\n‘In document A, Supervisor Mercer certifies that Line 4’s interlock was inspected and normal. In exhibit B, taken twenty minutes after EMS departed, a stiff copper bypass wire is cinched around the micro-switch with linesman pliers. Walk me through the gap between these two realities, Daniel. Because right now, the gap looks like a six-month jail sentence for filing false statements.’", "responses": [
			["admit", "Admit that the first account was misleading.", 0, "respect", 6, "You take a deep breath and tell him plainly that Harold Voss pressured you to sign a clean statement under threat of immediate termination. Cole writes without looking up, his pencil scratching methodically. ‘Coercion is an explanation, Daniel; it’s not an excuse. But putting it on the record now is the only reason you’re walking out of this office today.’"],
			["uncertain", "Say you are uncertain about the timing.", 0, "trust", -10, "You look at your boots and claim the adrenaline and blood made the timeline blurry. Cole stops writing. He looks over his glasses with cold, piercing skepticism: ‘An adrenaline lapse doesn’t explain eight sentences of precise technical certification, Daniel. The state forensic board checks image metadata down to the millisecond.’"],
			["pressure", "Describe Harold’s request, without blaming him for the wire.", 0, "trust", 4, "You describe Harold cornering you against the locker bank by the time clock, quoting Harold’s exact words about plant closures and mortgages, while strictly separating Harold’s threats from who physically placed the wire. Cole’s eyebrows raise slightly: ‘A supervisor protecting his budget with extortion. That matches two confidential complaints we received last year.’"],
			["pause", "Ask to stop the interview for now.", 0, "trust", -3, "You tell Cole you need to consult legal counsel before answering further questions about that timeline. Cole calmly caps his pencil and slides the manila folder shut with an ominous snap. ‘Take your time, Daniel. But remember: the first party to cooperate gets the consideration.’"]]},
		"loyalty": {"day": 2, "actor": "harold", "place": "plant", "title": "A signature", "text": "Harold Voss summons you into his wood-paneled office, locking the brass latch behind you. He opens a center desk drawer and slides a white company envelope across the mahogany. Inside is $150 in crisp fifty-dollar bills, attached to a formal Pre-Shift Certification Retention slip.\n\n‘Corporate approved retention bonuses for key supervisors,’ Harold murmurs, giving you a warm, conspiratorial grin that doesn't reach his cold eyes. He taps line 4 of the attached memo: Supervisor certifies all pre-operational mechanical safety interlocks were functional during shift 11-04. ‘Sign off on the certification rider, Daniel. Takes two seconds. Your family gets groceries, and corporate sees a unified management front.’", "responses": [
			["sign", "Sign the form and take the payment.", 150, "trust", 12, "You pick up the pen and sign your name, slipping the three fifty-dollar bills into your pocket. Harold’s smile widens into a smug, triumphant grin: ‘I knew you were a company man, Daniel. We take care of our own.’ The cash warms your wallet, but you have legally ratified a fabricated safety record."],
			["refuse", "Refuse to sign something you cannot verify.", 0, "resentment", 12, "You push the envelope and the pen back across the desk. ‘I'm not signing off on a certification I didn't perform, Harold.’ Harold’s grin instantly vanishes into a snarling sneer. He snatches the envelope back and slams his drawer shut: ‘Then you better hope your resume is polished, Mercer. Because when Line 4 restarts, your name won't be on the supervisor rota.’"],
			["copy", "Ask for a blank copy to review at home before signing.", 0, "trust", -15, "You fold the unsigned rider and tuck it into your notebook. ‘Let me take this home and review the legal wording with Erin.’ Harold flushes purple, his hand slamming onto the desk: ‘That’s internal company property, Daniel! You sign it here or nowhere!’ But your hand is already on the door handle."],
			["amend", "Cross out the inspection claim before signing.", 0, "respect", 5, "You draw a thick black line through the interlock certification clause, write EXCEPT LINE 4 — BYPASS NOTED, and sign below. Harold stares at the ink as if you had spat on his desk: ‘Payroll will void this check immediately. You just threw away a hundred and fifty bucks to prove a point nobody cares about.’"]]},
		"nate_bill": {"day": 2, "actor": "nate", "place": "hospital", "title": "The cost of recovery", "text": "Nate Bell is sitting in the corner armchair of Room 314, his left hand clumsily trying to sort a four-inch stack of medical bills and workers’ comp claim rejections across his blanket. A metal brace locks his right arm straight. When you enter, he doesn't look up, but his breath comes fast and ragged.\n\n‘Hospital pharmacy wants ninety dollars for the nerve blockers, and Mercer Works’ insurer denied the initial claim pending investigation into operator misconduct,’ Nate says, his voice shaking with humiliation and despair. ‘I got sixty-two dollars in my checking account, Daniel. How am I supposed to pay rent when I can’t even hold a fork with my dominant hand?’", "responses": [
			["money", "Offer $60 toward groceries, with no conditions.", -60, "trust", 10, "You pull out three twenty-dollar bills and press them gently into his good hand. ‘Take it, Nate. No interest, no strings. Just get the prescriptions filled.’ Nate stares down at the green paper, his jaw working as his eyes well with tears of gratitude. ‘I'll pay you back the second the union steps in, Dan. I swear it.’"],
			["forms", "Help him sort through the benefit forms.", 0, "respect", 8, "You pull up a chair beside his hospital bed and spend two hours translating the bureaucratic legalese, filling out the medical necessity appeals and documenting the emergency surgery codes. By the time you finish, the appeal packet is addressed and stamped. Nate lets out a shuddering breath: ‘I couldn't have figured that out alone. Thanks, Dan.’"],
			["hear", "Let him talk without offering a solution.", 0, "affection", 6, "You sit beside him in silence, letting him vent every drop of terror, rage, and grief—about how his girlfriend looked at his mangled arm, about the dread of permanent disability, about the humiliation of being labeled careless. You don't offer platitudes; you just stay until the storm passes."],
			["distance", "Say you have too much of your own to handle.", 0, "resentment", 9, "You tell him you’re sorry, but with the plant facing suspension and your own bills piling up, you can’t get involved in his insurance fight. Nate’s face turns stony cold. ‘Yeah. Course not. Company supervisors gotta protect their own skin, right?’ He looks away and ignores you until you leave."]]},
		"matt_van": {"day": 3, "actor": "matt", "place": "diner", "title": "A borrowed tomorrow", "text": "Matt sits across from you at the Juniper Diner, nervously stirring cold diner coffee with a plastic straw until the ice cubes have melted away. A printed repair invoice from Briar Glen Radiator & Auto is crumpled beneath his fist. $120 for a replacement alternator and starter relay.\n\n‘Dan, listen to me,’ Matt pleads, his voice cracking with desperation. He leans over the table, glancing sideways to make sure the waitress isn't listening. ‘The courier company told me if I miss tomorrow morning’s delivery run to the regional depot, they terminate my contractor lease. That van is my entire life. If I lose that route, I'm sleeping in my car by next month. I need a hundred and twenty bucks.’", "responses": [
			["lend", "Lend him $120 and put a repayment date in writing.", -120, "trust", 8, "You count out $120 in cash onto the table, then pull out a diner napkin and a pen. ‘Sign the napkin, Matt. Repayment by the fifteenth of the month. If you blow this on beer or scratch-offs, I'm done helping you.’ Matt signs with a shaking hand, grasping your forearm: ‘I swear on Mom's grave, Dan. You won't regret this.’"],
			["ride", "Help him plan deliveries without the van.", 0, "respect", 7, "You tell him you don't have $120 to spare, but you offer to use your truck to help him run his afternoon route so his contract isn't voided. Matt blinks, surprised: ‘You’d do that? It’s fifty miles of back roads.’ It costs you half a day and a tank of fuel, but Matt's livelihood survives without digging into your cash reserves."],
			["decline", "Tell him plainly that you cannot afford it.", 0, "trust", 3, "You look your brother in the eye and tell him flatly that with the plant investigation and overdue heating bills, you cannot hand him cash. Matt looks down into his mug, his face reddening with shame and bitter resentment. ‘Right. Big brother Daniel always has an excuse. Thanks for nothing, Dan.’ He storms out into the rain."],
			["blame", "Ask why you always have to rescue him.", 0, "resentment", 12, "You push the crumpled invoice back into his chest. ‘Every six months it’s an emergency, Matt! When are you going to grow up and take responsibility for your own equipment?!’ Matt flinches as if struck, his eyes hardening: ‘I came to you for help, not a sermon.’ He leaves the booth without finishing his coffee."]]},
		"meeting": {"day": 3, "actor": "luis", "place": "diner", "title": "The people on the rota", "text": "Eight machine operators from the second and third shifts are huddled in the back booth of Juniper Diner after Mercer Works posts a temporary suspension notice on Line 4. The mood is tense and volatile; Luis Ortega is at the center of the table, tapping a legal pad with his calloused thumb.\n\n‘Harold’s telling corporate this shutdown is on us,’ Luis speaks in a low, fierce murmur. ‘They're cutting our base pay to forty percent standby rate while the state reviews the press. We can draft a joint petition demanding full standby wages and an independent union inspection, but Harold will only take it seriously if someone with supervisory authority signs the top line.’ Every eye around the table turns to you.", "responses": [
			["join", "Put your name on the request for paid leave.", 0, "trust", 10, "You take the pen from Luis and sign Daniel Mercer — Night Shift Supervisor across the top line of the petition. A quiet, electric ripple of solidarity runs through the booth. Luis grips your shoulder with fierce approval: ‘That takes guts, Dan. Now they can’t claim this is just a floor revolt.’"],
			["quiet", "Help draft it, but leave your name off.", 0, "respect", 4, "You help them polish the legal language and cite the state labor code clauses, but slide the paper back before signing. ‘I’ll help you frame the arguments, but if my name is on the top, Harold rejects it out of spite.’ Luis nods slowly, understanding the tactical reality even if he wishes you stood bolder."],
			["wait", "Suggest waiting for the inspection findings.", 0, "trust", -4, "You urge them to hold off until Investigator Cole releases the preliminary inspection findings on Thursday. A burly press operator named Miller sneers across the table: ‘Wait? My landlord doesn't wait for state inspectors, Mercer. Easy for a supervisor with a guaranteed salary to preach patience.’"],
			["leave", "Say you need to protect your own position.", 0, "resentment", 8, "You shake your head and slide out of the booth. ‘I can’t be seen meeting with floor crews while an active safety inquiry is ongoing.’ Disappointed, hostile glares follow you all the way out to your truck."]]},
		"neighbor": {"day": 4, "actor": "rebecca", "place": "home", "title": "An ordinary kindness", "text": "A gentle knock rattles your back kitchen door. It’s Rebecca Shaw, your next-door neighbor and local school librarian, holding a steaming, towel-wrapped Pyrex casserole dish. Her coat is dusted with wet snow, and her eyes carry the gentle, perceptive empathy of someone who has known your family for two decades.\n\n‘I saw the squad car at the plant gates this morning, Daniel,’ Rebecca says softly, stepping inside onto the welcome mat and kicking off her boots. ‘And I know Erin’s been carrying the weight of the world on her shoulders. I brought a turkey and noodle bake. Chloe can come over to my place for quiet study tonight if things get heavy here.’", "responses": [
			["accept", "Thank her and invite her in.", 0, "affection", 10, "You thank her warmly, take the warm casserole, and invite her into the kitchen. Rebecca sits with Chloe, helping her with algebra homework while you and Erin share a moment of profound, quiet relief. For the first time in days, the house feels like a sanctuary."],
			["share", "Tell her you are worried about money.", 0, "trust", 7, "You confide in Rebecca about the terrifying financial strain and the threat of plant closure. Rebecca listens with deep, compassionate focus, handing you an envelope with an extra key to her house: ‘If the power gets shut off or things get scary, your daughter has a warm room next door. No questions asked.’"],
			["private", "Accept the soup but keep the conversation brief.", 0, "respect", 3, "You thank her politely, accept the casserole, but keep the conversation on the doorstep. ‘We appreciate the food, Rebecca, truly. We just need an early night.’ She smiles with understanding grace and steps back into the snow: ‘Tell Erin I'm right across the yard whenever she needs me.’"],
			["reject", "Tell her you do not need looking after.", 0, "trust", -6, "Pride flares up in your chest; you hold up your hand and tell her the Mercer family doesn't take charity. Rebecca's smile fades into quiet sorrow: ‘It isn’t charity, Daniel. It’s being neighbors.’ She takes the dish back, leaving the porch colder than before."]]},
		"promise_due": {"day": 4, "actor": "chloe", "place": "home", "title": "You said Friday", "text": "Friday morning at 07:15 AM. Chloe stands by the front door with her backpack slung over one shoulder, holding the Springfield invitational track form in her fingers. The purple ink reads FRIDAY - CASH. Her eyes are searching your face, half-expecting to be let down again.\n\n‘The bus rolls out of the school lot at two o’clock, Dad,’ Chloe says quietly, her voice trembling slightly. ‘Coach said he has to turn the roster into the athletic office by noon. Did you... were you able to get the forty-five dollars?’", "responses": [
			["pay", "Keep the promise. Give her the $45.", -45, "trust", 10, "You pull out a crisp fifty-dollar bill and press it into her palm, folding her fingers over it. ‘Go run fast, Chloe. Make us proud.’ Chloe's eyes widen, and she throws her arms around your chest in a fierce, breathless hug: ‘Thank you, Dad! I promise I'll place in the top three!’ She runs down the driveway to catch the bus with a radiant smile."],
			["sorry", "Apologize and explain why you cannot.", 0, "trust", -5, "You drop to one knee and look her in the eye, speaking with painful, unvarnished honesty: ‘Chloe, I'm so sorry. I couldn't get the cash together before noon. I had to choose between the bus fee and keeping the heat on.’ Chloe swallows hard, tears welling in her eyes: ‘I know, Dad. It’s okay.’ She walks out the door with slumped shoulders, leaving a hollow ache in your chest."],
			["ask", "Ask whether she wants to talk about it.", 0, "affection", 2, "You sit her down on the bottom step of the stairs and ask her how she’s feeling about everything going on at home. Chloe breaks down, admitting how terrified she is that you and Erin are going to divorce or lose the house. You hold her tight, letting her cry until the panic subsides."],
			["deny", "Say you never made a definite promise.", 0, "resentment", 20, "You snap at her that you never promised fifty dollars in cash, claiming she misunderstood what you said on Monday. Chloe's face hardens with cold fury: ‘You did promise! You looked me right in the eye! You just can’t admit that you failed!’ She slams the front door, the glass rattling in the frame."]]},
		"erin_offer": {"day": 5, "actor": "erin", "place": "home", "title": "A letter from Millfield", "text": "Erin sits at the kitchen table beneath the warm yellow light, a certified courier packet from Millfield Accounting lying open on the placemat. It is an official employment agreement: $48,000 annual salary, full medical, paid family leave, starting the first of next month. Her hands tremble as she traces the company seal.\n\n‘They want the signed contract postmarked by tomorrow morning, Daniel,’ Erin whispers, looking up with tears glistening in her eyes. ‘It’s a real job. Real stability. But it means forty-five minutes on highway 4 each way, five days a week. It means our entire routine changes. We have to decide right now whether we do this together or let fear keep us drowning in Briar Glen.’", "responses": [
			["celebrate", "Tell her you’re proud of her and want her to take it.", 0, "trust", 15, "You pull her out of the chair into a long, tight embrace, kissing her temple. ‘You sign that contract tonight, Erin. You earned this. We will make the mornings work, whatever it takes.’ Erin buries her face in your shoulder, weeping with sheer joy and relief: ‘We’re going to be okay, Daniel. We’re going to make it.’"],
			["practical", "Ask how you will manage Chloe’s track schedule and the commute.", 0, "respect", 8, "You pull up the kitchen calendar and map out the logistics hour-by-hour: Chloe's school bus pick-ups, grocery shifts, oil changes for the commuter car. It’s tight and demanding, but looking at the plan together turns an intimidating mountain into a clear path forward."],
			["fear", "Ask if this means she’s planning to leave you.", 0, "affection", -5, "You stare at the paper with bitter insecurity, asking if this job is just her first step toward packing her bags and leaving you. Erin looks at you with profound sorrow: ‘I’m trying to save our family from bankruptcy, Daniel! The fact that you see an enemy in my success breaks my heart.’"],
			["refuse", "Tell her the family cannot survive her being away all day.", 0, "resentment", 18, "You tell her flatly that the family cannot survive her being gone ten hours a day, demanding she reject the offer. Erin’s expression turns ice-cold. She slowly folds the contract, slides it back into the envelope, and puts it in her purse: ‘I asked for your support, Daniel. I didn’t ask for your permission.’"]]},
		"harold_cornered": {"day": 5, "actor": "harold", "place": "diner", "title": "Across the linoleum", "text": "Harold Voss slides into the vinyl booth across from you at Juniper Diner, looking like a ghost of himself. His tie is crooked, his eyes bloodshot from insomnia, his gray hair wildly uncombed. The state forensic inspector arrives at Mercer Works tomorrow morning at 08:00 to dismantle the stamping head on Line 4.\n\n‘The state board wants the maintenance binder, Daniel,’ Harold rasps, leaning over the table until you can smell the liquor on his breath. He clutches a burning cigarette in trembling fingers. ‘If that pre-shift inspection log disappears from the booth tonight, the state writes this off as an unforeseen mechanical seizure. Thirty families keep their jobs. Mercer Works survives. If that log stays in the file, corporate shuts us down by Friday. You have the master keys to the office. Help me make it disappear.’", "responses": [
			["refuse", "Tell Harold you will not destroy evidence for him.", 0, "resentment", 15, "You stare directly into Harold’s desperate eyes and shake your head: ‘I'm not destroying state evidence for you, Harold. You let Nate operate a death trap to hit quota, and you're going to answer for it.’ Harold’s face twists into a snarl of venomous fury: ‘You sanctimonious bastard! You just killed Mercer Works!’ He throws down a crumpled five-dollar bill and storms out."],
			["bargain", "Demand severance protection for the floor workers first.", 0, "respect", 6, "You lean in and demand full severance packages and health coverage for all thirty floor workers before you even consider talking about records. Harold laughs bitterly: ‘Corporate won't give them a nickel, Daniel, and you know it! We sink together!’"],
			["leave", "Stand up and walk out of the diner.", 0, "trust", -5, "You slide out of the booth without saying a word, leaving Harold alone with his cold coffee and his burning cigarette in the dim diner light."]]},
		"strike_vote": {"day": 6, "actor": "luis", "place": "plant", "title": "The front gate", "text": "Freezing slush covers the gravel entrance of Mercer Works. Twenty-five machine operators, tool-and-die specialists, and floor hands stand huddled in thick coats outside the chain-link gates. Luis Ortega is standing on an upturned wooden pallet, his face flushed red against the biting wind, holding a battery-powered megaphone.\n\n‘Corporate just announced they’re hiring temporary replacement scabs from the county line to restart the stamping presses tomorrow!’ Luis roars over the wind. ‘They refuse to install laser light curtains on Line 4, and they refuse to pay Nate Bell’s medical costs! We take a vote right now, right here in the slush: do we shut these gates with a picket line, or do we crawl back inside on our knees?!’ Every worker turns toward you, the night supervisor, waiting to see where you cast your vote.", "responses": [
			["picket", "Vote to hold the picket line and stand with the crew.", 0, "trust", 12, "You step forward through the slush and raise your gloved hand high into the freezing air. ‘Picket line!’ you shout. A thunderous roar of cheers erupts from the crew. Men raise their fists; Luis jumps down from the pallet and grips your hand with fierce brotherhood: ‘Now we fight together, Daniel!’"],
			["mediate", "Urge caution and offer to talk with Harold first.", 0, "respect", 6, "You raise your hands and plead for forty-eight hours to negotiate with the plant board before shutting the gates. Luis shakes his head with bitter sadness: ‘Harold has had twenty years to negotiate, Dan. Talking is just giving them time to bring the scabs in.’"],
			["walk", "Tell Luis you have to take care of your own family first.", 0, "resentment", 10, "You lower your eyes and turn back toward your truck, muttering that you have a mortgage and a daughter to feed. Cold silence falls over the crowd. Former coworkers turn their backs on you in utter contempt as you start your engine."]]},
		"the_reckoning": {"day": 6, "actor": "cole", "place": "station", "title": "The closed file", "text": "Investigator Cole’s office is silent except for the rhythmic ticking of the wall clock. On his steel desk lies a five-hundred-page certified case binder stamped in red ink: STATE DEPARTMENT OF LABOR — FINAL FINDINGS: MERCER WORKS INC. Cole removes his reading glasses, rubbing the bridge of his nose, and looks squarely into your eyes.\n\n‘The technical and forensic review is officially closed, Daniel,’ Cole says, his voice solemn and final. ‘Every photograph, every time-card timestamp, every witness interview, and every page of company paper has been entered into the state archive. What we documented this week will determine who faces criminal negligence charges, what compensation Nate Bell receives, and whether Mercer Works ever opens its doors again.’", "responses": [
			["listen", "Hear the official findings and accept what comes next.", 0, "respect", 8, "You sit upright and listen as Cole reads through the formal findings—the mechanical verification of deliberate bypass, the supervisory timeline, and the certification penalties. The truth is recorded in stone, immune to Harold’s erasers."],
			["ask", "Ask what will happen to Harold Voss and the plant.", 0, "trust", 5, "You ask Cole what will happen to Harold Voss and the stamping floor crew. ‘Harold has been referred to the state prosecutor for evidence tampering,’ Cole answers calmly. ‘As for the plant, corporate has forty-five days to install certified safety cages or face permanent closure.’"],
			["silence", "Sign the receipt of notice without a word.", 0, "trust", 2, "You take the pen from Cole and sign the certified receipt of notice without a single word. The week of terror, lies, and moral reckoning has reached its legal conclusion."]]}
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
