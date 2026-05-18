extends Node

var debugReport = true

func processAI():
	var report = ""
	var myValue = ROUND.enemyValue + GLOBAL.enemyDeck[0]["value"]
	var target = ROUND.targetValue
	
	var visiblePlayerValue = ROUND.playerValue - GLOBAL.playerDeck[0]["value"] 
	
	# --- PARANOIA AND ENVIRONMENT CALCULATIONS ---
	# 1. Paranoia (Target value shifts)
	# If the target value changes dynamically or via player trump cards, 
	# standing right at the target boundary becomes dangerous.
	var is_target_volatile: bool = ROUND.has_method("is_target_dynamic") and ROUND.is_target_dynamic()
	
	# 2. Player Inventory Threat Level
	# If player holds a massive hand of trump cards, they can easily manipulate values later
	var player_trump_count: int = GLOBAL.playerInventory.size() if "playerInventory" in self else 0
	var player_threat_multiplier: float = 1.0 + (player_trump_count * 0.08) # +8% paranoia per card held
	
	# 3. Desperate Measures (AI Life Tracking)
	# If the AI's round-ending health/lives are critically low, it plays with intense urgency
	var ai_lives: int = ROUND.enemyLives if "enemyLives" in ROUND else 3
	var is_critically_low_health: bool = (ai_lives <= 1)
	
	# Adjust dynamic decision thresholds based on environmental dread
	var safety_threshold: float = 0.40
	var desperation_trigger: float = 0.55
	
	if is_critically_low_health:
		safety_threshold = 0.30       # Desperate AI takes crazier card risks to avoid losing
		desperation_trigger = 0.45    # Lower panic bar to force strategic over-draws
	
	# --- TACTICAL MEMORY RECONSTRUCTION ---
	var judgementCounting = []
	for i in range(11):
		judgementCounting.append(i + 1)
		
	for card in GLOBAL.enemyDeck:
		judgementCounting.erase(card["value"])
		
	for i in range(1, GLOBAL.playerDeck.size()):
		judgementCounting.erase(GLOBAL.playerDeck[i]["value"])
		
	# --- TACTICAL JUDGEMENT MATH ---
	var safe_cards: float = 0.0
	var total_unknown_cards: float = float(judgementCounting.size())
	
	for remaining_card in judgementCounting:
		if myValue + remaining_card <= target:
			safe_cards += 1.0
			
	var safe_draw_chance: float = 0.0
	if total_unknown_cards > 0.0:
		safe_draw_chance = safe_cards / total_unknown_cards

	# --- PREDICTIVE ANALYSIS ---
	var cards_that_beat_me: float = 0.0
	for hidden_card_possibility in judgementCounting:
		var simulated_player_total = visiblePlayerValue + hidden_card_possibility
		if simulated_player_total <= target and simulated_player_total >= myValue:
			cards_that_beat_me += 1.0
			
	var player_likely_winning_chance: float = 0.0
	if total_unknown_cards > 0.0:
		player_likely_winning_chance = cards_that_beat_me / total_unknown_cards
		
	# Apply threat modifier to player win calculation
	player_likely_winning_chance *= player_threat_multiplier

	# --- PARANOIA EXECUTION ENGINE ---
	#REPORT MAIN
	if debugReport:
		print("--- AI TURN) ---")
		print("AI Hand: ", myValue, " | Target: ", target)
		print("Modified Player Win Chance: ", player_likely_winning_chance * 100.0, "%")
	
	# Rule 1: Absolute Cap Check
	if visiblePlayerValue >= target:
		report += "\nAI stands (Player is visibly busted. Victory guaranteed)."
		ROUND.enemyStand()
		
	elif myValue >= target:
		report += "\nAI stands (At or over target layout limitations)."
		ROUND.enemyStand()
		
	# Rule 2: Dynamic Target Paranoia Override
	# If the target is volatile and the player has a heavy threat pool, standing exactly 
	# 1 or 2 points beneath the target leaves the AI vulnerable to value manipulation.
	elif is_target_volatile and myValue <= (target - 2) and safe_draw_chance > 0.60 and player_trump_count >= 3:
		report += "\nAI hits due to Target Paranoia! (Fears player will shift the boundaries or crush a close margin)."
		ROUND.enemyDraw()

	# Rule 3: Extreme Desperation
	elif safe_draw_chance < safety_threshold and player_likely_winning_chance > desperation_trigger:
		report += "\nAI hits on Desperation! (Low safety, but passing means certain death)."
		ROUND.enemyDraw()
		
	# Rule 4: Standard Defensive Play
	elif safe_draw_chance < safety_threshold:
		if myValue > visiblePlayerValue:
			report += "\nAI stands (High risk, holding a visible lead)."
		else:
			report += "\nAI stands (High risk, betting on player variance or bust)."
		ROUND.enemyStand()
			
	# Rule 5: Standard Aggressive Play
	else:
		report += "\nAI hits (Calculated safety parameters met)."
		ROUND.enemyDraw()
	
	if debugReport:
		print(report)
		
