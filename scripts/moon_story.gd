extends RefCounted
const Nodes = preload("res://scripts/moon_data.gd").NODES

static func configure(w) -> void:
	w.data.scene = "moon"
	w.data.flags = {"moon_story": true, "moon_node": "cake", "bills": {}}
	w.data.minute = 0
	w.data.locations = {"dream": "The Hotel Nobody"}
	w.data.events = []
	w.data.knowledge = []
	w.data.memories = []
	w.data.intentions = []
	w.data.truths = {}
	var cast = {"daniel": ["Alex Vale", "Unexpected funeral guest"], "erin": ["Mox", "Woman in a red diving helmet"], "cole": ["The Manager", "Goldfish hotelier"], "matt": ["Pip", "Lost property resident"], "harold": ["Aunt Zero", "Keeper of tomorrow"]}
	for id in w.data.characters.keys():
		if not cast.has(id):
			w.data.characters.erase(id)
	for id in cast:
		var p: Dictionary = w.data.characters[id]
		p.name = cast[id][0]
		p.occupation = cast[id][1]
		p.location = "dream"
		p.health = 100
		p.fatigue = 0
		p.conditions = []
		p.possessions = []
		p.goals = []
		p.fears = []
		p.secrets = []
		p.beliefs = []
		p.finances = {"cash": 0, "debt": 0}
	w.data.relationships = {}
	w.player().age = 29
	for a in cast:
		for b in cast:
			if a != b:
				w.data.relationships[a + ":" + b] = {"affection": 20, "trust": 40, "attraction": 0, "fear": 0, "respect": 45, "resentment": 0, "dependence": 0, "familiarity": 0, "memories": []}
	# Retain schema slots for older snapshots; no factory objects exist in this story.
	for id in w.data.objects:
		w.data.objects[id] = {"owner": "", "location": "dream", "condition": "absent", "history": []}
	w.story(Nodes.cake.text)

static func choices(w) -> Array:
	var result: Array = []
	var rows: Array = Nodes[w.data.flags.moon_node].choices
	for i in rows.size():
		result.append({"id": "moon_%d" % i, "label": rows[i].label, "minutes": 1, "why": ""})
	return result

static func act(w, id: String) -> bool:
	var offered: Array = choices(w)
	if not offered.any(func(c): return c.id == id):
		return false
	var row: Dictionary = Nodes[w.data.flags.moon_node].choices[int(id.trim_prefix("moon_"))]
	var next: String = row.next
	var outcome: String = row.outcome
	if not row.flag.is_empty():
		w.data.flags["moon_" + row.flag] = true
	if w.data.flags.moon_node == "key" and next == "unlocked":
		if w.flag("moon_key_inside"):
			outcome = "Your chest opens like a little door. You pull out the brass key and turn it. The lock recognizes your heartbeat."
		elif w.flag("moon_mox_key") and not w.flag("moon_mox_left"):
			outcome = "Mox produces the key you spat into her helmet. 'You're welcome.' She turns it before the socket can close."
		elif w.flag("moon_punch"):
			outcome = "The moth's silver punch fits badly. You force it. The lock gives way with a noise like a dentist screaming."
		else:
			next = "bed"
			outcome = "You have nothing that fits. The socket snaps shut. A laundry chute opens under you and drops you back beside the baby."
	if w.data.flags.moon_node == "lullaby" and next == "sea" and row.label == "Keep singing.":
		if w.flag("moon_song"):
			outcome = "The baby recognizes the tune you sang on the telephone. It sings the next line before you do. A door smelling of seawater opens in the shell."
		elif w.flag("moon_dream_paid"):
			outcome = "You reach for a melody from your flying dream and find the hole where it used to be. Mox catches the silence and sings you both through it."
		else:
			outcome = "You invent a dreadful song about a cake. The baby laughs until the shell splits open onto the sea."
	if next.ends_with("_end"):
		if w.flag("moon_shadow_free"):
			outcome += "\n\nYour freed shadow returns with a suitcase. 'Thought you might need company.' It walks beside you, no longer beneath you."
		elif w.flag("moon_shadow_friend"):
			outcome += "\n\nYour shadow has stayed beside you through all of it. It asks for its own name. You let it choose."
		if w.flag("moon_pip"):
			outcome += "\n\nPip unfolds his bathtub and gathers the loose birthdays into it. Yours sits on top."
		if w.flag("moon_saved_day"):
			outcome += "\n\nThe Thursday you spilled out of the kitchen pot returns to the calendar. Millions of people wake with the strange feeling that somebody gave them something back."
		if w.flag("moon_signed") and not w.flag("moon_birthday"):
			outcome += "\n\nYour old name never comes back. Mox offers to help choose another."
	w.data.minute += 1
	w.data.turn += 1
	w.data.flags.moon_node = next
	w.record(outcome, [w.data.player], "experienced", false, "important", w.data.player)
	w.story(outcome + "\n\n" + Nodes[next].text)
	w.data.story_log.back()["action"] = row.label
	return true
