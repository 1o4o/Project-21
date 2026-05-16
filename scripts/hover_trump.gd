extends Panel

var activeTween: Tween

func fadeIn():
	if activeTween:
		activeTween.kill()
	size.y = 90 + (floor(($desc.size.y - 17)/ 20) * 20)
	visible = true
	modulate.a = 0
	activeTween = create_tween()
	activeTween.tween_property(self, "modulate:a", 1, 0.1).set_trans(Tween.TRANS_SINE)

func fadeOut():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_SINE)
