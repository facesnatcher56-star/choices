extends RefCounted
## Single-responsibility financial system for One Bad Week.
## Principle: Money pressures decisions through context, trade-offs, and timing,
## rather than through constant micro-management or shopping menus.

static func ensure_bills(w) -> Dictionary:
	if not w.data.flags.has("bills") or not w.data.flags.bills is Dictionary:
		w.data.flags.bills = {
			"heating": {"title": "Overdue heating bill", "amount": 80, "due_day": 1, "status": "unpaid"},
			"school": {"title": "Chloe's school field trip", "amount": 45, "due_day": 4, "status": "pending"}
		}
	return w.data.flags.bills

static func available_cash(w) -> int:
	var p = w.player()
	return int(p.finances.get("cash", 0))

static func total_debt(w) -> int:
	var p = w.player()
	return int(p.finances.get("debt", 0))

static func credit_limit(w) -> int:
	var p = w.player()
	return int(p.finances.get("credit_limit", 2500))

static func available_credit(w) -> int:
	return maxi(0, credit_limit(w) - total_debt(w))

static func bills_due(w) -> int:
	var bills = ensure_bills(w)
	var total = 0
	var current_day = int(w.data.minute / 1440) + 1
	for id in bills:
		var b = bills[id]
		if b.status in ["unpaid", "overdue"] and b.get("due_day", 1) <= current_day:
			total += int(b.get("amount", 0))
	return total

static func status_line(w) -> String:
	return "Available $%d  ·  Debt $%d  ·  Bills due $%d" % [available_cash(w), total_debt(w), bills_due(w)]

## Tier 1: Background spending & scheduled income waves (no micro-transactions)
static func daily_tick(w, day: int, _before_day: int) -> Array[String]:
	var visible: Array[String] = []
	var p = w.player()
	var who = w.data.player
	var bills = ensure_bills(w)

	# Routine household living costs (groceries, routine fuel, domestic overhead)
	var daily_cost = 24
	p.finances.cash = maxi(0, int(p.finances.cash) - daily_cost)
	visible.append("Another day has passed. Food and household costs take $24 per day from your available cash.")

	# Check pending bills maturing into overdue status
	for id in bills:
		var b = bills[id]
		if b.status == "pending" and day >= b.get("due_day", 1):
			b.status = "unpaid"

	# Tier 3: Crisis spending triggers from neglected bills
	if bills.has("heating") and bills.heating.status == "unpaid" and day >= 3:
		bills.heating.status = "overdue"
		w.data.flags.heat_shutoff_warning = true
		visible.append("A final shutoff notice from the gas utility is taped to the front door: pay $80 immediately or supply will be terminated.")

	if bills.has("heating") and bills.heating.status == "overdue" and day >= 5 and not w.flag("heat_cut"):
		w.data.flags.heat_cut = true
		visible.append("The radiator pipes in the house are ice cold. The gas utility technician disconnected the meter this morning.")
		w.relationship("erin", who, "resentment", 15)

	# Income Waves: Varying financial pressure (no permanent artificial scarcity)
	if day == 5 and who == "daniel":
		if not w.flag("plant_closed") and not w.flag("fired_daniel"):
			var paycheck = 360
			p.finances.cash += paycheck
			visible.append("Friday plant direct deposit clears: +$%d lands in your account. The financial knot loosens slightly." % paycheck)
			w.record("Daniel received his weekly factory payroll direct deposit of $360.", ["daniel"], "payroll deposit", false, "important", "daniel")
		else:
			visible.append("Friday payroll: direct deposit failed. Production suspension halted all worker disbursements.")
			w.record("Daniel's Friday payroll deposit was withheld due to plant shutdown.", ["daniel"], "payroll notice", false, "important", "daniel")

	return visible

## Tier 2: Meaningful spending alternatives (Realistic trade-offs instead of hard-locks)
static func pay_bill(w, bill_id: String, method: String) -> Dictionary:
	var bills = ensure_bills(w)
	if not bills.has(bill_id):
		return {"success": false, "text": "No bill found."}
	var b = bills[bill_id]
	var p = w.player()
	var amount = int(b.get("amount", 0))

	match method:
		"cash":
			if p.finances.cash >= amount:
				p.finances.cash -= amount
				b.status = "paid"
				w.record(p.name + " paid the $" + str(amount) + " " + b.title + " in full with cash.", [w.data.player], "receipt", false, "important", w.data.player)
				return {"success": true, "text": "You count out $" + str(amount) + " in cash. The bill is paid."}
			return {"success": false, "text": "Not enough cash on hand."}
		"credit":
			p.finances.debt += amount
			b.status = "paid"
			w.record(p.name + " charged the $" + str(amount) + " " + b.title + " to the credit card.", [w.data.player], "credit statement", false, "important", w.data.player)
			return {"success": true, "text": "You charge the $" + str(amount) + " to the credit card. The bill is resolved, but the card balance increases to $" + str(p.finances.debt) + "."}
		"half":
			var half_amount = int(amount / 2)
			if p.finances.cash >= half_amount:
				p.finances.cash -= half_amount
				b.amount = amount - half_amount
				b.status = "partial"
				w.record(p.name + " made a partial payment of $" + str(half_amount) + " toward the " + b.title + ".", [w.data.player], "receipt", false, "important", w.data.player)
				return {"success": true, "text": "You pay $" + str(half_amount) + " now and agree to pay the remaining $" + str(b.amount) + " next week."}
			return {"success": false, "text": "Not enough cash for partial payment."}
		"defer":
			b.status = "overdue"
			return {"success": true, "text": "You slide the notice under a mug on the counter. The payment will have to wait."}

	return {"success": false, "text": "Unknown payment method."}
