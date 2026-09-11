extends RefCounted
const NODES = {
	"cake": {
		"title": "Your funeral, apparently",
		"text": "You wake inside a seven-tier wedding cake. Someone outside is delivering your eulogy badly.\n\n“Alex Vale loved two things,” says the voice. “Swimming, and being legally dead.” You hate swimming.\n\nYou punch through the icing. A hundred guests turn toward you. Every guest has your face. A woman in a red diving helmet leans close and whispers, “Don't let them see your teeth.”\n\nOn your tongue sits a tiny brass key.",
		"choices": [
			{
				"label": "Eat the key.",
				"next": "banquet",
				"outcome": "You swallow. A lock clicks somewhere inside your chest. Every guest stands up at once.",
				"flag": "key_inside"
			},
			{
				"label": "Spit it out.",
				"next": "banquet",
				"outcome": "The woman catches the key in her helmet. “Excellent. You're only mostly an idiot.” She pockets it.",
				"flag": "mox_key"
			},
			{
				"label": "Smile.",
				"next": "mirror",
				"outcome": "You show your teeth. The guests scream and fold flat, one after another, until the ballroom floor is tiled with portraits of you.",
				"flag": "teeth"
			}
		]
	},
	"mirror": {
		"title": "The wrong reflection",
		"text": "The last guest is still standing. It is you, wearing a crown made of hotel teaspoons.\n\n“I'm your replacement,” it says. “You're early.” It steps out of its shoes and into the mirror behind the bar. Your reflection stays behind, tapping impatiently on the glass from your side.\n\nThe woman in the diving helmet introduces herself as Mox. “That happens. Move.”",
		"choices": [
			{
				"label": "Follow it.",
				"next": "lift",
				"outcome": "You step through the mirror into a service lift. Mox follows, swearing. Your replacement is gone, but its spoon crown lies on the floor. You take it.",
				"flag": "crown"
			},
			{
				"label": "Break the mirror.",
				"next": "banquet",
				"outcome": "The glass shatters into tiny screaming birds. Your reflection escapes under the door. Mox scoops a glass feather from your shoulder.",
				"flag": "glass"
			},
			{
				"label": "Wave goodbye.",
				"next": "banquet",
				"outcome": "Your reflection mouths something rude and evaporates. Mox decides she likes you.",
				"flag": "mox_friend"
			}
		]
	},
	"banquet": {
		"title": "Please sign for yourself",
		"text": "A hotel manager with an aquarium for a head rolls a coffin up to the ruined cake. Inside the aquarium, one goldfish pilots the body with little brass levers.\n\n“Routine checkout,” says the fish. “One signature.”\n\nThe coffin knocks three times. Outside the windows, the moon develops a long, wet crack. Something pink pushes against it from inside.\n\nMox grabs your elbow. “We have until that hatches.”",
		"choices": [
			{
				"label": "Open the coffin.",
				"next": "coffin",
				"outcome": "You throw back the lid. Inside, your shadow sits up wearing pajamas.",
				"flag": ""
			},
			{
				"label": "Sign it.",
				"next": "lift",
				"outcome": "You sign ALEX VALE. The ink crawls off the form and under the manager's sleeve. You can no longer remember what your name sounds like.",
				"flag": "signed"
			},
			{
				"label": "Grab the fish.",
				"next": "kitchen",
				"outcome": "You lift the aquarium lid and scoop the manager into a champagne bucket. The empty body runs into a wall. Mox takes the bucket.",
				"flag": "fish"
			}
		]
	},
	"coffin": {
		"title": "Your shadow resigns",
		"text": "“I quit,” says your shadow. “Twenty-nine years of copying you. No holidays. No pockets.” It puts on a pair of actual trousers.\n\nIt has booked passage on the moon. It says the creature inside is a baby, and somebody has been feeding it whole days. Yesterday went missing first. Tomorrow is next.\n\nMox looks at the shadow's trousers. “Those are mine.”",
		"choices": [
			{
				"label": "Let it go.",
				"next": "lift",
				"outcome": "Your shadow shakes your hand, which feels like a cold breeze, and walks up the wall. “I'll remember this.”",
				"flag": "shadow_free"
			},
			{
				"label": "Ask it to stay.",
				"next": "kitchen",
				"outcome": "“One more night,” it says. “And I get to choose the music.” It peels itself off the floor and walks beside you.",
				"flag": "shadow_friend"
			},
			{
				"label": "Steal the trousers.",
				"next": "kitchen",
				"outcome": "Your shadow curses and vanishes into the ceiling. In its stolen trousers you find a railway ticket labeled ONE LARGE MISTAKE.",
				"flag": "ticket"
			}
		]
	},
	"kitchen": {
		"title": "Soup of the day",
		"text": "The kitchen is flooded ankle-deep with alphabet soup. A chef with six arms is stirring a pot labeled THURSDAY. Tiny commuters circle inside it on tiny buses.\n\n“The baby's dinner,” Mox says. “They've been cooking the calendar.”\n\nA spoon the size of a canoe hangs above the pot. The chef offers you a taste without turning around.",
		"choices": [
			{
				"label": "Taste it.",
				"next": "tram",
				"outcome": "It tastes like a dentist appointment you haven't had yet. A memory of tomorrow slides into your head: a red button, a broken lullaby, a sky full of teeth.",
				"flag": "tomorrow"
			},
			{
				"label": "Tip the pot.",
				"next": "aquarium",
				"outcome": "Thursday spills over the tiles. An entire afternoon rushes past your ankles. The chef shrinks into a small, furious egg. Mox carries it out.",
				"flag": "saved_day"
			},
			{
				"label": "Climb the spoon.",
				"next": "lift",
				"outcome": "You swing onto the hanging spoon. It catapults you through the serving hatch into the lift. Mox lands on top of you, laughing despite herself.",
				"flag": "mox_friend"
			}
		]
	},
	"lift": {
		"title": "Floor thirteen and a half",
		"text": "The lift operator is a horse in a dinner jacket. It asks you which floor, then says, “Wrong,” before you answer.\n\nThe doors open onto the roof. The city below is drifting apart into separate floating blocks. A train made of teeth winds between them. A public aquarium floats upside down above the station.\n\nMox points up. A cord runs from the hotel's roof directly into the crack in the moon.",
		"choices": [
			{
				"label": "Take the train.",
				"next": "tram",
				"outcome": "The horse kicks a hole through the lift wall. You and Mox fall neatly into the last carriage.",
				"flag": ""
			},
			{
				"label": "Go swimming.",
				"next": "aquarium",
				"outcome": "You jump toward the upside-down aquarium. Water reaches down like a hand and pulls you through the glass.",
				"flag": ""
			},
			{
				"label": "Pull the cord.",
				"next": "roof",
				"outcome": "You pull. The moon hiccups. The hotel roof retracts, revealing an enormous baby bottle full of glowing hours.",
				"flag": "cord"
			}
		]
	},
	"tram": {
		"title": "Mind the gums",
		"text": "The tooth-train snaps shut behind you. Its conductor, a moth the size of a priest, punches holes in passengers' dreams instead of tickets.\n\n“Fare,” it says.\n\nMox searches her pockets. All she has is a dead lighter and a photograph of an empty chair. The conductor extends six patient hands.",
		"choices": [
			{
				"label": "Give it a dream.",
				"next": "court",
				"outcome": "You surrender your recurring dream of flying. The moth pins it to its coat. You remember that you once dreamed something lovely, but not what.",
				"flag": "dream_paid"
			},
			{
				"label": "Bite it.",
				"next": "court",
				"outcome": "You bite one gloved hand. “A local!” the moth says delightedly. It gives you a silver punch and opens the doors.",
				"flag": "punch"
			},
			{
				"label": "Hide under Mox.",
				"next": "aquarium",
				"outcome": "Mox throws her coat over you both. The conductor picks up the entire bundle and drops it into the aquarium's lost property chute.",
				"flag": "mox_friend"
			}
		]
	},
	"aquarium": {
		"title": "Lost property",
		"text": "Fish swim through the air around shelves of missing umbrellas, lost voices, and one misplaced volcano. A young man named Pip sits in a dry bathtub, holding your missing birthday in a jar.\n\n“Been waiting ages,” he says. “You left this here before you were born.”\n\nBehind him a whale, small enough to ride, is chewing through a filing cabinet. A sign around its neck reads DO NOT EMPLOY.",
		"choices": [
			{
				"label": "Open the jar.",
				"next": "court",
				"outcome": "Everyone sings Happy Birthday at once, including the volcano. You suddenly remember your mother calling you Alex. The memory stays even if your name does not.",
				"flag": "birthday"
			},
			{
				"label": "Ride the whale.",
				"next": "roof",
				"outcome": "The whale smashes through a skylight with you and Mox on its back. Pip waves from the bathtub. You land on the hotel's exposed roof.",
				"flag": "whale"
			},
			{
				"label": "Take Pip.",
				"next": "court",
				"outcome": "“Finally.” Pip folds the bathtub into his pocket and comes with you. He says he can hear the thing inside the moon crying.",
				"flag": "pip"
			}
		]
	},
	"court": {
		"title": "The trial of gravity",
		"text": "You arrive in court halfway through the trial of gravity. Gravity is chained to a chair, sobbing. Without it, the judge's wig floats around the ceiling like an angry jellyfish.\n\nThe judge is a vending machine. It lights up when it sees you: WITNESS ARRIVED.\n\n“Did gravity push you?” asks the prosecutor, who is a pile of coats.\n\nOutside, another city block drifts past upside down.",
		"choices": [
			{
				"label": "Say yes.",
				"next": "sky",
				"outcome": "The vending machine flashes GUILTY. Gravity is taken away. The floor gives up entirely. You and Mox tumble into open sky.",
				"flag": "gravity_gone"
			},
			{
				"label": "Say no.",
				"next": "roof",
				"outcome": "The machine spits out an acquittal. Gravity hugs your knees. Everyone drops six feet onto the floor, then pretends this is dignified.",
				"flag": "gravity_saved"
			},
			{
				"label": "Kick the judge.",
				"next": "sky",
				"outcome": "A packet of crisps and a tiny thunderstorm fall from the judge. You pocket the storm before the coats chase you through a window.",
				"flag": "storm"
			}
		]
	},
	"sky": {
		"title": "A bad place for a phone call",
		"text": "You fall sideways through a flock of office buildings. Mox catches a streetlamp and catches you by the collar.\n\nA telephone rings inside your mouth. When you open it, a voice says, “This is the moon. I would like to cancel my reservation.”\n\nAbove you, an enormous eye opens in the shell. The pupil follows you.",
		"choices": [
			{
				"label": "Hear it out.",
				"next": "roof",
				"outcome": "The voice belongs to the baby, impossibly calm. “They keep feeding me days. I'm full. Please turn it off.” It tells you where the feeding hose ends.",
				"flag": "heard_baby"
			},
			{
				"label": "Hang up.",
				"next": "roof",
				"outcome": "You cough out the receiver. It falls upward, still ringing. Mox hauls you onto a passing roof and refuses to comment.",
				"flag": ""
			},
			{
				"label": "Sing to it.",
				"next": "roof",
				"outcome": "You sing the only tune you remember. The eye closes for a moment. Mox quietly joins in.",
				"flag": "song"
			}
		]
	},
	"roof": {
		"title": "The bottle",
		"text": "The hotel roof is a nursery. A feeding hose runs from the enormous bottle of hours into the moon.\n\nA woman named Aunt Zero sits in a rocking chair, knitting tomorrow. Every time her needles meet, another clock below stops.\n\n“Oh, there you are,” she says. “I made the copies because one of you was bound to cooperate.”\n\nMox goes very still. Aunt Zero has Mox's face, forty years older.",
		"choices": [
			{
				"label": "Ask Mox.",
				"next": "mox",
				"outcome": "Mox lifts the red helmet. A little seawater runs down her neck. “I was hoping we could avoid this bit.”",
				"flag": ""
			},
			{
				"label": "Cut the hose.",
				"next": "nursery",
				"outcome": "You tear through the soft hose with a broken roof tile. Hours spill into the air. Aunt Zero screams as the moon begins to descend.",
				"flag": "hose_cut"
			},
			{
				"label": "Sit with Zero.",
				"next": "zero",
				"outcome": "Aunt Zero pats the chair beside her. “At last. Someone with manners.” She pours tea that falls upward.",
				"flag": ""
			}
		]
	},
	"mox": {
		"title": "The woman in the helmet",
		"text": "“She's me,” Mox says. “Or I'm her. It depends which way the night goes.”\n\nShe has lived this night eleven times. Each time the baby eats tomorrow, Mox grows older and everyone else forgets. This time she woke you before the hotel could use your body as its new clock.\n\n“I didn't know you would be in the cake,” she says. “That was new.”\n\nAunt Zero resumes knitting.",
		"choices": [
			{
				"label": "Hug her.",
				"next": "nursery",
				"outcome": "Mox grips you hard. “No more practice runs,” she says. Together you pull the nursery door off its hinges.",
				"flag": "mox_trusted"
			},
			{
				"label": "Take her helmet.",
				"next": "nursery",
				"outcome": "Mox lets you take it. Inside the helmet, eleven trapped nights whisper at once. You can hear where this one is tearing.",
				"flag": "helmet"
			},
			{
				"label": "Walk away.",
				"next": "zero",
				"outcome": "You leave Mox by the broken hose. Aunt Zero pours a second cup without looking up.",
				"flag": "mox_left"
			}
		]
	},
	"zero": {
		"title": "Tea with the end",
		"text": "“The baby isn't evil,” says Aunt Zero. “It is simply hungry. Neither are we evil for eating breakfast.”\n\nShe wants you to become the hotel's clock: a living person whose memories can be wound back whenever the baby finishes another day. She calls this renewable dining.\n\nShe offers you a biscuit shaped exactly like your heart. It beats against the saucer.",
		"choices": [
			{
				"label": "Eat the biscuit.",
				"next": "nursery",
				"outcome": "It bites you back. You bite harder. Aunt Zero laughs, and for a moment you can hear every thought in the hotel.",
				"flag": "heart"
			},
			{
				"label": "Throw the tea.",
				"next": "nursery",
				"outcome": "The tea hangs in the air between you. In each drop is a different failed tomorrow. You smash the cup and walk through the rain.",
				"flag": "zero_angry"
			},
			{
				"label": "Agree.",
				"next": "nursery",
				"outcome": "Aunt Zero ties a ribbon around your wrist. “Come back when the nursery settles.” Beneath the ribbon, something starts ticking.",
				"flag": "clock_promise"
			}
		]
	},
	"nursery": {
		"title": "Inside the moon",
		"text": "The moon settles over the roof like a great cracked lampshade. You step through its shell.\n\nInside lies a baby the size of a cathedral. It has tiny folded wings, an old man's mustache, and your face. A hotel bell hangs above its cradle. A red button sits beside the feeding tube.\n\nIt opens one eye. “I do not want to be a hotel,” it says.",
		"choices": [
			{
				"label": "Press the button.",
				"next": "button",
				"outcome": "The button plays a recorded voice: THANK YOU FOR EXTENDING YOUR STAY. The cradle starts converting into a reception desk.",
				"flag": "button"
			},
			{
				"label": "Ring the bell.",
				"next": "bell",
				"outcome": "A door opens in the baby's forehead. The goldfish manager's voice calls, “Complaint department.”",
				"flag": ""
			},
			{
				"label": "Climb into bed.",
				"next": "bed",
				"outcome": "You climb onto the pillow beside a nostril big enough to park in. The baby stops crying so it can inspect you.",
				"flag": ""
			}
		]
	},
	"button": {
		"title": "Your stay has been extended",
		"text": "The walls fill with identical doors. Behind every door, another Alex is waking in another cake. The red button wasn't a stop button. It was a snooze button.\n\nA brass socket opens in the reception desk. A loudspeaker asks for the master key.\n\nMox is on the other side of the shrinking doorway, holding out her hand.",
		"choices": [
			{
				"label": "Use the key.",
				"next": "key",
				"outcome": "You reach for the socket.",
				"flag": "use_key"
			},
			{
				"label": "Take her hand.",
				"next": "bed",
				"outcome": "You jump as the doorway closes. Mox catches you, and you both land on the baby's enormous pillow.",
				"flag": "mox_trusted"
			},
			{
				"label": "Stay here.",
				"next": "clock_end",
				"outcome": "You sit at reception. The desk fits around your body. Somewhere behind you, a phone begins ringing.",
				"flag": ""
			}
		]
	},
	"key": {
		"title": "Something unlocks",
		"text": "The hotel holds its breath.",
		"choices": [
			{
				"label": "Open it.",
				"next": "unlocked",
				"outcome": "You turn what you brought to the socket.",
				"flag": ""
			},
			{
				"label": "Leave it.",
				"next": "bed",
				"outcome": "You wrench yourself away from reception and crawl through the laundry chute into the cradle.",
				"flag": ""
			},
			{
				"label": "Swallow the socket.",
				"next": "wild_end",
				"outcome": "It is a terrible fit. You persevere. The hotel folds inward like an umbrella.",
				"flag": ""
			}
		]
	},
	"bell": {
		"title": "Complaint department",
		"text": "Inside the baby's forehead, a clerk made of bees stamps a form without reading it.\n\n“The birth has been delayed because the guest has no destination,” the bees explain. “The hotel will retain the moon until one is provided.”\n\nOn the counter sit a globe, a snow globe, and a badly drawn picture of the sea. The sea in the drawing is moving.",
		"choices": [
			{
				"label": "Choose the sea.",
				"next": "sea",
				"outcome": "The bees stamp the drawing. A salt wind pours from the baby's nose.",
				"flag": "sea"
			},
			{
				"label": "Choose the globe.",
				"next": "earth_end",
				"outcome": "The bees stamp the Earth. Outside, the baby stretches. Entire constellations move out of its way.",
				"flag": ""
			},
			{
				"label": "Eat the form.",
				"next": "wild_end",
				"outcome": "The bees look at one another. Without the form, there is officially no baby, no hotel, and no jurisdiction. Reality takes this personally.",
				"flag": ""
			}
		]
	},
	"bed": {
		"title": "A very big child",
		"text": "“Nobody asked what I wanted,” says the baby. “They just kept bringing Wednesdays.”\n\nIts eyelashes are covered in little sleeping birds. Beyond the shell, the city clings to the hotel with washing lines.\n\n“Will it hurt?” it asks.\n\nYou have absolutely no idea.",
		"choices": [
			{
				"label": "Tell the truth.",
				"next": "sea",
				"outcome": "“Probably,” you say. The baby nods. “Thank you.” It asks to see the sea.",
				"flag": "honest"
			},
			{
				"label": "Sing.",
				"next": "lullaby",
				"outcome": "You start a tune. The birds on its eyelashes lift their heads.",
				"flag": ""
			},
			{
				"label": "Kiss its nose.",
				"next": "wild_end",
				"outcome": "The baby sneezes. You, Mox, the hotel, and several disputed weekdays shoot out through the crack in the moon.",
				"flag": ""
			}
		]
	},
	"lullaby": {
		"title": "The smallest sound",
		"text": "The first note makes the shell tremble. The baby watches you, trying to remember something older than the hotel.",
		"choices": [
			{
				"label": "Keep singing.",
				"next": "sea",
				"outcome": "You keep going.",
				"flag": ""
			},
			{
				"label": "Let Mox sing.",
				"next": "sea",
				"outcome": "You stop. Mox takes the tune, quietly at first, then loud enough to shake the rocking chair.",
				"flag": "mox_trusted"
			},
			{
				"label": "Shout instead.",
				"next": "wild_end",
				"outcome": "You shout until your voice cracks. The baby joins in. All the hotel's windows become open mouths, and the entire building screams itself loose.",
				"flag": ""
			}
		]
	},
	"sea": {
		"title": "The edge of morning",
		"text": "The baby draws the sea on its blanket, then folds the drawing until it becomes a door. Beyond it: black water, real wind, no hotel.\n\nThe shell splits. Aunt Zero calls from the rocking chair. If everyone leaves, the hotel will collapse with her inside. Mox looks back but does not move.\n\nThe baby lowers one hand to the doorway. It can carry you out.",
		"choices": [
			{
				"label": "Go with it.",
				"next": "sea_end",
				"outcome": "You step onto the baby's hand. The sea rises to meet you.",
				"flag": ""
			},
			{
				"label": "Get Zero.",
				"next": "rescue_end",
				"outcome": "You turn back. Aunt Zero drops her knitting when she sees you coming.",
				"flag": "rescue_zero"
			},
			{
				"label": "Stay behind.",
				"next": "clock_end",
				"outcome": "You push the others through the doorway and close it. The hotel is suddenly very quiet.",
				"flag": ""
			}
		]
	},
	"unlocked": {
		"title": "Vacancy",
		"text": "Every door in the hotel opens at once. The copies of you wander out, blinking. They do not want your life. They want their own.\n\nThe hotel is coming apart. One copy offers you the teaspoon crown. Another points toward the sea. A third has already stolen a lift.",
		"choices": [
			{
				"label": "Take the crown.",
				"next": "crown_end",
				"outcome": "You put it on. A hundred versions of you bow, badly out of sync.",
				"flag": ""
			},
			{
				"label": "Follow the sea.",
				"next": "sea_end",
				"outcome": "You leave the crown hanging on a doorknob. The baby carries you and the copies toward morning.",
				"flag": ""
			},
			{
				"label": "Steal the lift.",
				"next": "wild_end",
				"outcome": "You cram into the lift with Mox and six copies. The horse presses every button with its face.",
				"flag": ""
			}
		]
	},
	"sea_end": {
		"title": "An ordinary-sized morning",
		"text": "The baby unfolds its wings over a sea that has never seen the moon this close. It is still enormous. It is still frightened. It is free.\n\nYou reach a beach with Mox and a hotel towel. Behind you the baby swims toward the horizon, making whale noises badly. Tomorrow arrives late, smelling of salt.\n\nOn the towel's label, in tiny print: CHECKOUT SUCCESSFUL.\n\nTHE END",
		"choices": []
	},
	"rescue_end": {
		"title": "Nobody left upstairs",
		"text": "You carry Aunt Zero out over your shoulder while she insists this is terrible service. Mox takes her younger, older hand. Neither disappears. Apparently the universe has bigger problems.\n\nThe baby dives into the sea. The hotel collapses into a single wet room key.\n\nOn the beach, two versions of Mox argue over who gets to apologize first. You let them. You have had enough of deciding things for one night.\n\nTHE END",
		"choices": []
	},
	"clock_end": {
		"title": "The night manager",
		"text": "The clock in your chest begins to tick. The guests return. The cake repairs itself. You know every room and every sorrow inside it.\n\nBut this time you leave the doors unlocked. You give the trapped days names and teach the lift horse to say yes.\n\nA child rings reception from the sea. “Are you coming out?” it asks.\n\n“Soon,” you tell it. For the first time, the hotel has somewhere to go.\n\nTHE END",
		"choices": []
	},
	"earth_end": {
		"title": "Congratulations, it's a moon",
		"text": "The baby curls around the Earth like a kitten around a warm bowl. Dawn comes with an enormous mustache across the horizon.\n\nThe hotel falls onto the beach as an ordinary, deeply confused bungalow. Mox opens a window. People everywhere look up at the new face in the sky.\n\nThe baby asks what breakfast is. Every clock on Earth pauses to hear your answer.\n\nTHE END",
		"choices": []
	},
	"wild_end": {
		"title": "A small administrative explosion",
		"text": "For six seconds, you are a weather event. Then you land in a field beside Mox and a horse wearing the hotel's front doors.\n\nThe hotel has become a flock of migrating bathtubs. The moon is gone. Somewhere high above, something huge is laughing.\n\nMox checks that you still have a pulse. “Right,” she says. “Breakfast?”\n\nA bathtub lands beside you. Its meter starts running.\n\nTHE END",
		"choices": []
	},
	"crown_end": {
		"title": "All of you, at once",
		"text": "You become monarch of a hundred Alexes. Your first decree is that nobody has to be Alex anymore.\n\nThe copies argue over names until sunrise. The hotel breaks into a hundred little houses and follows them out onto the sea. You keep the spoon crown because it opens bottles.\n\nMox writes your original name on your wrist. “Just in case.”\n\nTHE END",
		"choices": []
	}
}
