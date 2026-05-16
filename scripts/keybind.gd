extends Control

var isVisible: bool = false

func _process(_delta: float) -> void:
	# Check the state
	var shouldBeVisible = (ROUND.phase == GLOBAL.state.PLAYERTURN and not GLOBAL.isInventoryOpen)
	
	# Only trigger the animation if the state actually changed
	if shouldBeVisible != isVisible:
		isVisible = shouldBeVisible
		fadeUI(isVisible)

func fadeUI(vis) -> void:
	var tween = create_tween()
	var targetAlpha = 1.0 if vis else 0.0
	
	# Use SINE for a smooth, natural transition
	tween.tween_property(self, "modulate:a", targetAlpha, 0.4).set_trans(Tween.TRANS_SINE)
	
	# Optional: Disable mouse interaction when hidden so you don't accidental click through it
	mouse_filter = Control.MOUSE_FILTER_STOP if show else Control.MOUSE_FILTER_IGNORE
