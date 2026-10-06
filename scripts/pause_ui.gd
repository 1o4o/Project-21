extends Control

var fade_tween: Tween
var is_transitioning: bool = false

func _ready() -> void:
	get_parent().visible = false
	modulate.a = 0.0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_transitioning:
			return
			
		if get_tree().paused:
			unpause_game()
		else:
			pause_game()

func pause_game() -> void:
	is_transitioning = true
	
	get_parent().visible = true
	get_tree().paused = true
	
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
		
	fade_tween = create_tween()
	# Removed the incorrect process mode line completely.
	# Because this node runs on 'Always', this tween will run while paused automatically.
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.35)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	fade_tween.tween_callback(func():
		is_transitioning = false
	)

func unpause_game() -> void:
	is_transitioning = true
	
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
		
	fade_tween = create_tween()
	
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.25)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
		
	fade_tween.tween_callback(func():
		get_parent().visible = false
		get_tree().paused = false
		is_transitioning = false
	)

func _on_resume_button_pressed() -> void:
	if not is_transitioning:
		unpause_game()

func _on_sever_button_pressed() -> void:
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
