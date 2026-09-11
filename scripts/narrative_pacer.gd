extends RefCounted
## Paces narrative text delivery into bite-sized beats (2-3 sentences each).
## Prevents overwhelming walls of text while keeping dialogue quotes intact.

var beats: Array[String] = []
var current_index: int = 0

func setup(full_text: String, action_header: String = "") -> void:
	beats.clear()
	current_index = 0
	
	var raw = full_text.strip_edges()
	if raw.is_empty():
		if not action_header.is_empty():
			beats.append(action_header)
		return

	# Split by paragraphs first
	var paragraphs = raw.split("\n\n")
	for p in paragraphs:
		var p_str = p.strip_edges()
		if p_str.is_empty():
			continue
		
		# Break long paragraphs into 2-3 sentence chunks
		var chunk_list = _split_into_sentence_chunks(p_str, 2, 3)
		for c in chunk_list:
			beats.append(c)

	if beats.is_empty():
		beats.append(raw)

	# Prepend action header to the first beat if given
	if not action_header.is_empty() and not beats.is_empty():
		beats[0] = action_header + "\n\n" + beats[0]

func _split_into_sentence_chunks(text: String, min_sentences: int, max_sentences: int) -> Array[String]:
	var sentences = _extract_sentences(text)
	if sentences.size() <= max_sentences:
		return [text]

	var chunks: Array[String] = []
	var current: Array[String] = []
	
	for s in sentences:
		current.append(s)
		if current.size() >= max_sentences:
			chunks.append(" ".join(current))
			current.clear()

	if not current.is_empty():
		if chunks.is_empty():
			chunks.append(" ".join(current))
		else:
			# If remainder is small (1 sentence), append to the last chunk if possible
			if current.size() == 1 and not chunks.is_empty():
				chunks[chunks.size() - 1] += " " + current[0]
			else:
				chunks.append(" ".join(current))

	return chunks

func _extract_sentences(text: String) -> Array[String]:
	var result: Array[String] = []
	var current = ""
	var in_single_quote = false
	var in_double_quote = false
	var len_text = text.length()
	var i = 0

	while i < len_text:
		var ch = text[i]
		current += ch
		
		# Dialogue quote tracking
		if ch == "‘" or ch == "“":
			if ch == "‘": in_single_quote = true
			if ch == "“": in_double_quote = true
		elif ch == "’" or ch == "”":
			if ch == "’": in_single_quote = false
			if ch == "”": in_double_quote = false
		elif ch == "\"" and not in_single_quote:
			in_double_quote = not in_double_quote

		# Sentence delimiter check (. ! ?)
		if (ch == "." or ch == "!" or ch == "?") and not in_single_quote and not in_double_quote:
			var next_char = text[i + 1] if i + 1 < len_text else ""
			if next_char == "’" or next_char == "”" or next_char == "\"":
				i += 1
				current += next_char
				next_char = text[i + 1] if i + 1 < len_text else ""

			if next_char == " " or next_char == "\n" or next_char == "":
				var trimmed = current.strip_edges()
				if not trimmed.is_empty():
					result.append(trimmed)
				current = ""
				while i + 1 < len_text and (text[i + 1] == " " or text[i + 1] == "\t"):
					i += 1
		i += 1

	var final_trimmed = current.strip_edges()
	if not final_trimmed.is_empty():
		result.append(final_trimmed)

	return result

func current_beat() -> String:
	if beats.is_empty():
		return ""
	var idx = clampi(current_index, 0, beats.size() - 1)
	return beats[idx]

func advance() -> bool:
	if current_index < beats.size() - 1:
		current_index += 1
		return true
	return false

func is_finished() -> bool:
	return current_index >= beats.size() - 1

func total_beats() -> int:
	return beats.size()

func beat_number() -> int:
	return current_index + 1

func finish_all() -> void:
	if not beats.is_empty():
		current_index = beats.size() - 1
