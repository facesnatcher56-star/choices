extends RefCounted
## Simulates organic rumor and information propagation among co-located NPCs.
## Gossip and observations travel through interpersonal relationships,
## distorting subjectively based on trust, resentment, and personality biases.

static func propagate(w) -> Array[String]:
	var notes: Array[String] = []
	var by_location: Dictionary = {}
	for id in w.data.characters:
		var c: Dictionary = w.data.characters[id]
		if not c.alive or c.health <= 25:
			continue
		var loc: String = c.location
		if not by_location.has(loc):
			by_location[loc] = []
		by_location[loc].append(id)
	
	# Check interactions at each location with 2+ characters
	var locs: Array = by_location.keys()
	locs.sort()
	for loc in locs:
		var people: Array = by_location[loc]
		people.sort()
		if people.size() < 2:
			continue
		
		# Sample a pair
		var a_idx = w.rng.randi() % people.size()
		var b_idx = (a_idx + 1 + (w.rng.randi() % (people.size() - 1))) % people.size()
		var a_id: String = people[a_idx]
		var b_id: String = people[b_idx]
		
		# Never simulate player talking to player
		if a_id == w.data.player and b_id == w.data.player:
			continue
			
		var rel_key = a_id + ":" + b_id
		var trust_val = 40
		if w.data.relationships.has(rel_key):
			trust_val = int(w.data.relationships[rel_key].trust)
			
		# Knowledge sharing depends on trust
		var a_memories = w.knowledge_for(a_id)
		if a_memories.is_empty():
			continue
			
		# Pick a memory of interest to share
		var candidate = a_memories[w.rng.randi() % a_memories.size()]
		var fact: String = candidate.fact
		
		# If listener already knows this, skip
		if w.knows(b_id, fact.substr(0, mini(30, fact.length()))):
			continue
			
		# Sensitive facts require higher trust
		var is_sensitive = "lied" in fact or "Harold" in fact or "guard" in fact or "bypassed" in fact or "Cole" in fact
		if is_sensitive and trust_val < 45:
			continue
			
		# Subjective interpretation and distortion
		var subject: String = candidate.get("subject", "")
		var distorts = false
		var distorted_fact = fact
		var is_claim = candidate.possibly_false
		
		if not subject.is_empty() and w.data.relationships.has(a_id + ":" + subject):
			var res = int(w.data.relationships[a_id + ":" + subject].resentment)
			if res > 35:
				distorts = true
				is_claim = true
				if "suggested" in fact:
					distorted_fact = fact.replace("suggested", "insisted")
				elif "looked normal" in fact:
					distorted_fact = fact.replace("looked normal", "falsely claimed it looked normal")
				elif "accident" in fact:
					distorted_fact = fact + " (Word has it corner-cutting was standard on shift.)"
					
		# Listener's caution affects confidence
		var listener_caution = float(w.data.characters[b_id].personality.get("caution", 0.5))
		var confidence = 0.85 if not is_claim else 0.55
		if listener_caution > 0.6:
			confidence *= 0.8
			is_claim = true
			
		var source_chain = candidate.source + " -> " + w.data.characters[a_id].name
		w.data.knowledge.append({
			"fact": distorted_fact,
			"character": b_id,
			"source": source_chain,
			"confidence": confidence,
			"timestamp": w.data.minute,
			"possibly_false": is_claim
		})
		
		# Track relationship impact from gossip
		if distorts and not subject.is_empty():
			w.relationship(b_id, subject, "trust", -4)
			w.relationship(b_id, subject, "resentment", 3)
			
		# If player is in the same room, they might overhear
		if loc == w.player().location and a_id != w.data.player and b_id != w.data.player:
			if w.rng.randf() < 0.35:
				notes.append("Overheard at " + w.data.locations[loc] + ": " + w.data.characters[a_id].name + " speaking quietly with " + w.data.characters[b_id].name + " about the plant.")
				
	return notes
