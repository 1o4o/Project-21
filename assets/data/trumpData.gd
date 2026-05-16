extends Node
var trumpSize = 41
var data = []

func random():
	var total_weight = 5.0

	for card in data:
		total_weight += card.get("weight", 50)

	var roll: float = randf_range(0.0, total_weight)
	var current_sum = 0.0

	for card in data:
		current_sum += card.get("weight", 50)
		if roll <= current_sum:
			return card
			
	return data.back() # Fallback for floating point errors
