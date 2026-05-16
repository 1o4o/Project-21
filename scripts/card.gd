extends MeshInstance3D

enum Side { FRONT, BACK }

@export var value: int = 0
@export var hidden: bool = false
@export var cardOwner = null

@onready var frontSide = $frontside
@onready var backSide = $backside
@onready var hiddenText = $hiddenText

var currentSide = Side.BACK

func _ready() -> void:
	$flip.pitch_scale = randf_range(0.5, 1.5)
	updateValueVisual()
	
	if hidden:
		hiddenText.visible = true
		if cardOwner == GLOBAL.entity.ENEMY:
			hiddenText.text = "?"
	else:
		currentSide = Side.FRONT
		create_tween().tween_property(self, "rotation_degrees:z", rotation_degrees.z + 180.0, 0.5).set_trans(Tween.TRANS_SPRING)

func updateValueVisual() -> void:
	frontSide.texture.region = GLOBAL.getAtlasTexture(value)
	hiddenText.text = str(value)

func revealCard() -> void:
	if currentSide == Side.FRONT: 
		return
		
	if is_instance_valid(hiddenText):
		hiddenText.queue_free()
		
	currentSide = Side.FRONT
	hidden = false
	GLOBAL.findMyArray(cardOwner, self).hidden = false
	GLOBAL.updateCounter()
	flip180Degrees()

func flip180Degrees() -> void:
	var tween = create_tween()
	var startY = position.y
	
	tween.tween_property(self, "position:y", startY + 0.05, 0.1).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "rotation_degrees:z", rotation_degrees.z + 180.0, 0.5).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "position:y", startY, 0.1).set_trans(Tween.TRANS_SINE)

func spawnAnimation(startPos: Vector3, targetPos: Vector3) -> void:
	global_position = startPos
	rotation_degrees = Vector3.ZERO
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position", targetPos, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees:y", 360.0, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

func destroy() -> void:
	var targetDeck = GLOBAL.playerDeck if cardOwner == GLOBAL.entity.PLAYER else GLOBAL.enemyDeck
	var targetData = GLOBAL.findMyArray(cardOwner, self)
	targetData.value = 0
	GLOBAL.updateCounter()
	if is_instance_valid(hiddenText):
		hiddenText.queue_free()

	var tween = create_tween().set_parallel(true)
	var fadeTime = 0.3
	
	tween.tween_property(self, "position:y", position.y + 0.12, fadeTime).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rotation_degrees:z", rotation_degrees.z + randi_range(-10, 30), fadeTime).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + randi_range(-30, 30), fadeTime).set_trans(Tween.TRANS_SPRING)
	
	var frontAlpha = 0.3 if currentSide == Side.FRONT else 0.1
	var backAlpha = 0.3 if currentSide == Side.BACK else 0.1
	
	tween.tween_property(frontSide, "modulate:a", 0.0, frontAlpha)
	tween.tween_property(backSide, "modulate:a", 0.0, backAlpha)
	
	await tween.finished
	targetDeck.erase(targetData)
	queue_free()
