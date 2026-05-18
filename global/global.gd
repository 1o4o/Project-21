extends Node

enum state {INTRO, NEWROUND, PLAYERTURN, ENEMYTURN, PROCESS, SHOWDOWN, RESULT}
enum entity {PLAYER, ENEMY}
enum tab {TRUMPCARD, ABILITIES, OVERVIEW}

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
const cardStartX = -0.25
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
		return Vector3(cardStartX + (playerDeck.size() * nextX), -0.29, 2.05)
	elif target == entity.ENEMY:
		return Vector3(cardStartX + (enemyDeck.size() * nextX), -0.29, 1.6)
	
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
