extends Node

enum state {INTRO, NEWROUND, PLAYERTURN, ENEMYTURN, PROCESS, SHOWDOWN, RESULT}
enum entity {PLAYER, ENEMY}
enum tab {TRUMPCARD, ABILITIES, OVERVIEW}

var testNo = 1

var deck = []
var playerDeck = []
var enemyDeck = []

var playerInventory = []
var enemyInventory = []

var isInventoryOpen = false
var inventoryTab = tab.TRUMPCARD

func resetMatchData():
	deck.clear()
	playerDeck.clear()
	enemyDeck.clear()
	playerInventory.clear()
	enemyInventory.clear()
	isInventoryOpen = false
	inventoryTab = tab.TRUMPCARD
	TRUMP.data.clear()
	ROUND.targetValue = 21
	ROUND.playerValue = 0
	ROUND.enemyValue = 0
	ROUND.playerLives = 7
	ROUND.enemyLives = 7
	ROUND.roundBet = 1
	ROUND.baseRoundBet = 1
	ROUND.phase = GLOBAL.state.INTRO
	ROUND.toProcess = null

var dialogue = {
	"playerDraw": [
		"Hit me!",
		"Another one.",
		"One more."
	],
	"stand": [
		"I'll stay.",
		"I'll keep this.",
		"I'll stand."
	],
	"showdown": [
		"And the winner is..",
		"Winner is..",
		"Prepare for the worst.."
	],
	"overkill": ["OVERKILL!", "MAXED!", "TOO FAR!", "NUH UH!", "GREEDY!"]
}

var gameData = {
	"topCard": null,
	"blueprintCopy": null
}

# 1. Preload the scene (more efficient than loading every time)
const CARD_SCENE = preload("res://scenes/card.tscn")


const cardWidth = 256
const cardHeight = 320
const startingX = -0.25
const nextX = 0.15

func wait(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout

func getAtlasTexture(index: int) -> Rect2:
	var column = index % 3
	@warning_ignore("integer_division")
	var row = floor(index / 3)
	var x_pos = column * cardWidth
	var y_pos = row * cardHeight
	return Rect2(x_pos, y_pos, cardWidth, cardHeight)
	
func getTrumpTexture(index: int) -> Rect2:
	var column = index % 7
	@warning_ignore("integer_division")
	var row = floor(index / 7)
	var x_pos = column * 256
	var y_pos = row * 256
	return Rect2(x_pos, y_pos, 256, 256)

func drawCard(target, isHidden, _isForced = false):
	if deck.size() == 0:
		return
	var randomIndex = randi_range(0, deck.size() - 1)
	var drawNumber = deck[randomIndex]
	deck.pop_at(randomIndex)
	var cardInstance = CARD_SCENE.instantiate()
	cardInstance.hidden = isHidden
	cardInstance.value = drawNumber
	cardInstance.cardOwner = target
	var card = {"value": drawNumber, "hidden": isHidden, "instance": cardInstance}
	get_tree().current_scene.add_child(cardInstance)
	cardInstance.spawnAnimation(Vector3(0.6, -0.2, 1.8), getCardPosition(target))
	if target == entity.PLAYER:
		playerDeck.append(card)
	elif target == entity.ENEMY:
		enemyDeck.append(card)
		
	updateCounter()
	
func getCardPosition(target):
	if target == entity.PLAYER:
		return Vector3(startingX + (playerDeck.size() * nextX), -0.29, 2.05)
	elif target == entity.ENEMY:
		return Vector3(startingX + (enemyDeck.size() * nextX), -0.29, 1.6)
	
	return null

func updateCounter():
	ROUND.playerValue = 0
	ROUND.enemyValue = 0
	var hasHiddenCard = false

	# Calculate Player Total
	for card in playerDeck:
		ROUND.playerValue += card.value

	# Calculate Enemy Total (visible cards only)
	for card in enemyDeck:
		if card.hidden:
			hasHiddenCard = true
		else:
			ROUND.enemyValue += card.value

	var scene = get_tree().current_scene
	var playerLabel = scene.get_node("playerLabel")
	var enemyLabel = scene.get_node("enemyLabel")
	playerLabel.text = str(ROUND.playerValue) + "/" + str(ROUND.targetValue)

	if ROUND.playerValue < ROUND.targetValue:
		playerLabel.modulate = Color.WHITE
	elif ROUND.playerValue == ROUND.targetValue:
		playerLabel.modulate = Color.GREEN
	else:
		playerLabel.modulate = Color.RED
	
	if hasHiddenCard:
		if enemyDeck.size() == 1:
			enemyLabel.text = "?/" + str(ROUND.targetValue)
		else:
			enemyLabel.text = "?+" + str(ROUND.enemyValue) + "/" + str(ROUND.targetValue)
	else:
		# No hidden cards at all
		enemyLabel.text = str(ROUND.enemyValue) + "/" + str(ROUND.targetValue)
		if ROUND.enemyValue < ROUND.targetValue:
			enemyLabel.modulate = Color.WHITE
		elif ROUND.enemyValue == ROUND.targetValue:
			enemyLabel.modulate = Color.GREEN
		else:
			enemyLabel.modulate = Color.RED

func findMyArray(ownerEntity, instance):
	var targetDeck = playerDeck if ownerEntity == entity.PLAYER else enemyDeck
	for cardData in targetDeck:
		if cardData.instance == instance:
			return cardData

func subtitle(content: String, duration: float = 2.0):
	var label = Label.new()
	label.text = content
	var settings = LabelSettings.new()
	settings.font_size = 28
	settings.outline_size = 10
	settings.outline_color = Color.BLACK
	label.label_settings = settings
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# 2. Add to UI Layer
	var uiLayer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	(uiLayer if uiLayer else get_tree().current_scene).add_child(label)
	
	# 3. Bottom-Center Positioning
	
	var viewSize = get_viewport().get_visible_rect().size
	
	label.position.x = (viewSize.x / 2.0) - (label.size.x / 2.0)
	label.position.y = viewSize.y * 0.9
	
	# 4. Smooth Animation
	label.modulate.a = 0.0
	var tween = create_tween()
	
	# Clean fade in
	tween.tween_property(label, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(duration)
	tween.tween_property(label, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(label.queue_free)

func processAI():
	var myValue = ROUND.enemyValue + enemyDeck[0]["value"]
	var target = ROUND.targetValue
	
	var visiblePlayerValue = ROUND.playerValue - playerDeck[0]["value"] 
	
	# --- PARANOIA AND ENVIRONMENT CALCULATIONS ---
	# 1. Paranoia (Target value shifts)
	# If the target value changes dynamically or via player trump cards, 
	# standing right at the target boundary becomes dangerous.
	var is_target_volatile: bool = ROUND.has_method("is_target_dynamic") and ROUND.is_target_dynamic()
	
	# 2. Player Inventory Threat Level
	# If player holds a massive hand of trump cards, they can easily manipulate values later
	var player_trump_count: int = playerInventory.size() if "playerInventory" in self else 0
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
		
	for card in enemyDeck:
		judgementCounting.erase(card["value"])
		
	for i in range(1, playerDeck.size()):
		judgementCounting.erase(playerDeck[i]["value"])
		
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
	#print("--- AI TURN) ---")
	#print("AI Hand: ", myValue, " | Target: ", target)
	#print("Modified Player Win Chance: ", player_likely_winning_chance * 100.0, "%")
	
	# Rule 1: Absolute Cap Check
	if visiblePlayerValue >= target:
		#print("AI stands (Player is visibly busted. Victory guaranteed).")
		ROUND.enemyStand()
		
	elif myValue >= target:
		#print("AI stands (At or over target layout limitations).")
		ROUND.enemyStand()
		
	# Rule 2: Dynamic Target Paranoia Override
	# If the target is volatile and the player has a heavy threat pool, standing exactly 
	# 1 or 2 points beneath the target leaves the AI vulnerable to value manipulation.
	elif is_target_volatile and myValue <= (target - 2) and safe_draw_chance > 0.60 and player_trump_count >= 3:
		#print("AI hits due to Target Paranoia! (Fears player will shift the boundaries or crush a close margin).")
		ROUND.enemyDraw()

	# Rule 3: Extreme Desperation
	elif safe_draw_chance < safety_threshold and player_likely_winning_chance > desperation_trigger:
		#print("AI hits on Desperation! (Low safety, but passing means definitive death).")
		ROUND.enemyDraw()
		
	# Rule 4: Standard Defensive Play
	elif safe_draw_chance < safety_threshold:
		if myValue > visiblePlayerValue:
			pass
			#print("AI stands (High risk, holding a visible lead).")
		else:
			pass
			#print("AI stands (High risk, betting on player variance or bust).")
		ROUND.enemyStand()
			
	# Rule 5: Standard Aggressive Play
	else:
		#print("AI hits (Calculated safety parameters met).")
		ROUND.enemyDraw()
		
