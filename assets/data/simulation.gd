extends Node

const TARGET_VALUE = 21

# Track overall statistics
var ai_1_wins : int = 0
var ai_2_wins : int = 0
var ties : int = 0

func _ready():
	run_mass_simulation(300)

func run_mass_simulation(runs: int):
	print("Starting sandboxed AI battle simulation (", runs, " rounds)...")
	
	for match_idx in range(runs):
		var match_result = simulate_single_round()
		if match_result == 1:
			ai_1_wins += 1
		elif match_result == 2:
			ai_2_wins += 1
		else:
			ties += 1
			
	# Print Final Results Report
	print("\n================ SIMULATION REPORT ================")
	print("Total Matches Conducted: ", runs)
	print("AI 1 (Conservative - 40% Threshold) Wins: ", ai_1_wins, " (", (float(ai_1_wins)/runs)*100, "%)")
	print("AI 2 (Aggressive   - 25% Threshold) Wins: ", ai_2_wins, " (", (float(ai_2_wins)/runs)*100, "%)")
	print("Ties / Double Busts: ", ties, " (", (float(ties)/runs)*100, "%)")
	print("===================================================\n")

# Simulates one fast-paced round of blackjack between two independent AIs
func simulate_single_round() -> int:
	# 1. Create a fresh, shuffled 1-11 deck replica
	var deck = []
	for i in range(11): deck.append(i + 1)
	deck.shuffle()
	
	# 2. Setup hands: Format mimics your exact card dictionary structure
	var ai1_deck = [{"value": deck.pop_back(), "hidden": true}]
	var ai2_deck = [{"value": deck.pop_back(), "hidden": true}]
	
	# Give them their second open card
	ai1_deck.append({"value": deck.pop_back(), "hidden": false})
	ai2_deck.append({"value": deck.pop_back(), "hidden": false})
	
	var ai1_standing = false
	var ai2_standing = false
	
	# 3. Fast Headless Game Loop
	var loop_count = 0
	while (not ai1_standing or not ai2_standing) and loop_count < 20:
		loop_count += 1
		
		# AI 1 Turn
		if not ai1_standing:
			var action = get_ai_decision(ai1_deck, ai2_deck, 0.40) # 40% risk tolerance
			if action == "hit" and not deck.is_empty():
				ai1_deck.append({"value": deck.pop_back(), "hidden": false})
			else:
				ai1_standing = true
				
		# AI 2 Turn
		if not ai2_standing:
			var action = get_ai_decision(ai2_deck, ai1_deck, 0.25) # 25% risk tolerance (More aggressive!)
			if action == "hit" and not deck.is_empty():
				ai2_deck.append({"value": deck.pop_back(), "hidden": false})
			else:
				ai2_standing = true

	# 4. Evaluate Final Scores
	var score1 = calculate_hand_total(ai1_deck)
	var score2 = calculate_hand_total(ai2_deck)
	
	# Determine Winner (Returns 1 for AI 1, 2 for AI 2, 0 for Tie)
	if score1 > TARGET_VALUE and score2 > TARGET_VALUE:
		return 0 # Both bust
	elif score1 > TARGET_VALUE:
		return 2 # AI 1 bust, AI 2 wins
	elif score2 > TARGET_VALUE:
		return 1 # AI 2 bust, AI 1 wins
	else:
		if score1 > score2: return 1
		elif score2 > score1: return 2
		else: return 0 # Flat tie

# Isolated tactical math engine from your script
func get_ai_decision(my_deck: Array, opponent_deck: Array, risk_threshold: float) -> String:
	var my_value = calculate_hand_total(my_deck)
	var visible_opponent_value = calculate_visible_total(opponent_deck)
	
	# Initialize local simulation memory pool
	var memory = [1,2,3,4,5,6,7,8,9,10,11]
	for card in my_deck: memory.erase(card["value"])
	for i in range(1, opponent_deck.size()): memory.erase(opponent_deck[i]["value"])
	
	# Safety calculations
	var safe_cards = 0.0
	var total_unknown = float(memory.size())
	for rc in memory:
		if my_value + rc <= TARGET_VALUE: safe_cards += 1.0
	var safe_draw_chance = safe_cards / total_unknown if total_unknown > 0 else 0.0
	
	# Enemy prediction calculations
	var cards_that_beat_me = 0.0
	for hc in memory:
		var sim_opp_total = visible_opponent_value + hc
		if sim_opp_total <= TARGET_VALUE and sim_opp_total >= my_value:
			cards_that_beat_me += 1.0
	var player_likely_winning_chance = cards_that_beat_me / total_unknown if total_unknown > 0 else 0.0
	
	# Decision matrix
	if my_value >= TARGET_VALUE:
		return "stand"
	elif safe_draw_chance < risk_threshold and player_likely_winning_chance > 0.70:
		return "hit" # Desperation hit
	elif safe_draw_chance < risk_threshold:
		return "stand"
	else:
		return "hit"

func calculate_hand_total(deck: Array) -> int:
	var total = 0
	for card in deck: total += card["value"]
	return total

func calculate_visible_total(deck: Array) -> int:
	var total = 0
	for i in range(1, deck.size()): total += deck[i]["value"]
	return total
