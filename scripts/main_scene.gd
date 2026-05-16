extends Node3D

@onready var light = $lightTable
@export var textLabelPath: PackedScene
var isToggleOnCooldown = false
@export var inventoryCooldownTime = 0.3 # Cooldown in seconds

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		print("\nTest No. " + str(GLOBAL.testNo))
		print("Player Value: " + str(ROUND.playerValue) + " vs. AI Value: " + str(ROUND.enemyValue) + " (Target value: 21)")
		GLOBAL.testNo += 1
		await GLOBAL.resetMatchData()
		get_tree().reload_current_scene()
		return
	
	if Input.is_action_just_pressed("debug2"):
		ROUND.passTurn(GLOBAL.entity.ENEMY)
		return
		
		
	if event is InputEventMouseButton and event.pressed:
		if GLOBAL.isInventoryOpen:
			return
		if ROUND.phase != GLOBAL.state.PLAYERTURN:
			return
		if event.double_click:
			if ROUND.phase != GLOBAL.state.PLAYERTURN:
				return
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					if overkillCheck():
						spawnTextLabel(GLOBAL.dialogue["overkill"].pick_random(), event.position, Color.RED)
						return
					spawnTextLabel("DRAW!", event.position)
					ROUND.playerDraw()
				MOUSE_BUTTON_RIGHT:
					spawnTextLabel("STAND!", event.position)
					ROUND.playerStand()
		else:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					if overkillCheck():
						spawnTextLabel(GLOBAL.dialogue["overkill"].pick_random(), event.position, Color.RED)
						return
					spawnTextLabel("Draw?", event.position)
				MOUSE_BUTTON_RIGHT:
					spawnTextLabel("Stand?", event.position)

func spawnTextLabel(content: String, mousePos: Vector2, color: Color = Color.WHITE):
	var label = Label.new()
	label.text = content
	label.scale = Vector2.ZERO
	var settings = LabelSettings.new()
	settings.font_color = color
	settings.outline_size = 12
	settings.outline_color = Color.BLACK
	label.label_settings = settings
	var uiLayer = get_tree().current_scene.find_child("CanvasLayer", true, false)
	if uiLayer:
		uiLayer.add_child(label)
	else:
		add_child(label)

	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(100, 50)
	await get_tree().process_frame
	label.pivot_offset = label.size / 2.0
	label.position = mousePos - (label.size / 2.0)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.chain().tween_property(label, "scale", Vector2.ONE, 0.1)
	tween.tween_property(label, "position:y", label.position.y + 100.0, 0.8).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "rotation_degrees", randf_range(-30, 30), 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(label.queue_free)


func _ready() -> void:
	TRUMP.data = BASE.data.duplicate()
	for i in range(3):
		GLOBAL.playerInventory.append(TRUMP.random())
	ROUND.initializeRound()
	while true:
		await await GLOBAL.wait(randi_range(5, 30))
		flicker()

func flicker():
	var tween = create_tween()
	for i in range(randi_range(3, 6)):
		tween.tween_property(light, "light_energy", randf_range(0.2, 4.0), 0.05)

	tween.tween_property(light, "light_energy", 4.0, 0.05)

func overkillCheck():
	if ROUND.playerValue >= ROUND.targetValue:
		return true

func _unhandled_input(event):
	if event.is_action_pressed("openInventory"):
		if isToggleOnCooldown:
			return # Ignore the press if we are on cooldown
			
		toggle_inventory()
		get_viewport().set_input_as_handled()

func toggle_inventory():
	var inventoryScene = $canvasUI/inventory
	if GLOBAL.isInventoryOpen:
		inventoryScene.close()
	else:
		inventoryScene.open()
	GLOBAL.isInventoryOpen = !GLOBAL.isInventoryOpen
	
	# Start the cooldown lock
	startCooldown()

func startCooldown():
	isToggleOnCooldown = true
	# Dynamically create a quick timer in the scene tree
	await get_tree().create_timer(inventoryCooldownTime).timeout
	isToggleOnCooldown = false
