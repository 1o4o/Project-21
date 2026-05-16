extends Panel

@onready var tooltipLabel = $text # Change this to match your actual Label node name
var offset = Vector2(20, 10)

var tooltipTexts = [
	"Manage and play Trump Cards that systematically break the rules of the table.",
	"Review passive external traits and use currently equipped active charm.",
	"Monitor historical card counting data and live match performance metrics."
]

var activeTween: Tween

func _process(_delta: float) -> void:
	if !GLOBAL.isInventoryOpen or !visible:
		return
	global_position = get_global_mouse_position() + offset

func showTooltip(index):
	if index != null:
		offset = Vector2(20, 10)
		if index < 0 or index >= tooltipTexts.size():
			return
		
		tooltipLabel.text = tooltipTexts[index]
		size.y = 60
	else:
		tooltipLabel.text = get_tree().current_scene.get_node("canvasUI/inventory").tooltipText
		size.y = 20 + (($text.get_line_count() - 1) * 20)
		offset = Vector2(-200, -size.y)
	
	if activeTween:
		activeTween.kill()
		
	visible = true
	activeTween = create_tween()
	activeTween.tween_property(self, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE)

func hideTooltip():
	if activeTween:
		activeTween.kill()
		
	activeTween = create_tween()
	activeTween.tween_property(self, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE)
	activeTween.finished.connect(func(): visible = false)
