extends Button

@export var normal_color = Color("e0e0e0ff") # Dark Grey
@export var hover_color = Color("ffffffff")  # Slightly lighter
@export var click_scale = Vector2(0.95, 0.95)

func _ready():
	pivot_offset = size / 2.0
	modulate = normal_color
	
	# Connect signals via code so you don't have to do it manually for every button
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_mouse_entered():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate", hover_color, 0.1)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1) # Slight pop out

func _on_mouse_exited():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate", normal_color, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_button_down():
	var tween = create_tween()
	tween.tween_property(self, "scale", click_scale, 0.05)

func _on_button_up():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.05)
