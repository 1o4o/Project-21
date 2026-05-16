extends TextureButton

var id: int
var data: Dictionary
var count = 1

@export var clickScale = Vector2(0.95, 0.95)

func _ready():
	# Crucial: Forces the scale animation to expand outwards from the exact center
	pivot_offset = size / 2.0
	
	# Connect signals programmatically to avoid human error in the editor
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
	button_down.connect(onButtonDown)
	button_up.connect(onButtonUp)
	
	await get_tree().process_frame
	texture_normal.region = GLOBAL.getTrumpTexture(id + 1)

func onMouseEntered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_SINE)

func onMouseExited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func onButtonDown():
	var tween = create_tween()
	tween.tween_property(self, "scale", clickScale, 0.05).set_trans(Tween.TRANS_SINE)
	get_tree().current_scene.get_node("canvasUI/inventory").update(data)
	get_tree().current_scene.get_node("canvasUI/inventory/trumpcard/Panel/name/count").text = "Owned: " + str(count)
	if data.tooltip != null:
		get_tree().current_scene.get_node("canvasUI/inventory/trumpcard/Panel/name/infoHover").visible = true
		get_tree().current_scene.get_node("canvasUI/inventory").tooltipText = data.tooltip
	else:
		get_tree().current_scene.get_node("canvasUI/inventory/trumpcard/Panel/name/infoHover").visible = false 

func onButtonUp():
	var tween = create_tween()
	# Check if mouse is still hovering to decide whether to return to pop-out or normal size
	var targetScale = Vector2(1.05, 1.05) if get_global_rect().has_point(get_global_mouse_position()) else Vector2.ONE
	tween.tween_property(self, "scale", targetScale, 0.05).set_trans(Tween.TRANS_SINE)
