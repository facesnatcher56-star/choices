extends RefCounted
## Deterministic seeded hidden truths.
## These represent objective reality in the world that no single character omnisciently knows.
## Characters must discover, misinterpret, conceal, or investigate these truths.

const BYPASS_AUTHORS = ["nate", "harold", "luis", "mechanical"]
const PLANT_SOLVENCIES = ["insolvent", "buyout", "stable"]
const NATE_PROGNOSES = ["amputation", "nerve_damage", "complications"]
const INFORMANTS = ["anonymous_worker", "triage_nurse", "none_until_evidence"]

static func generate(seed_number: int) -> Dictionary:
	var r = RandomNumberGenerator.new()
	r.seed = seed_number
	var author = BYPASS_AUTHORS[r.randi() % BYPASS_AUTHORS.size()]
	var solvency = PLANT_SOLVENCIES[r.randi() % PLANT_SOLVENCIES.size()]
	var prognosis = NATE_PROGNOSES[r.randi() % NATE_PROGNOSES.size()]
	var informant = INFORMANTS[r.randi() % INFORMANTS.size()]
	
	var author_motive = ""
	match author:
		"nate":
			author_motive = "Nate wired the guard open to hit his piece-rate target because his mother's care facility raised its rates."
		"harold":
			author_motive = "Harold Voss personally installed the copper bypass over the weekend to prevent a production halt on the automotive contract."
		"luis":
			author_motive = "Luis Ortega wired the guard back during a quick die alignment before the shift and forgot to unclip it before handover."
		"mechanical":
			author_motive = "The safety interlock solenoid was faulty and tripping false emergency stops; third-shift maintenance wedged it open with bailing wire while awaiting spare parts from Germany."
			
	return {
		"bypass_author": author,
		"author_motive": author_motive,
		"plant_solvency": solvency,
		"nate_prognosis": prognosis,
		"informant": informant,
		"investigation_stage": 1,
		"strike_readiness": 15
	}
