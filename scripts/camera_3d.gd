extends Camera3D

@export var tilt_amount: float = 10  # How many degrees it can tilt
@export var lerp_speed: float = 5.0   # How smooth the movement feels

@onready var initial_rotation = rotation_degrees

func _process(delta):
	processCardHover()
	# Get mouse position from 0.0 to 1.0 (0 is left/top, 1 is right/bottom)
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Convert to a range of -1.0 to 1.0
	var look_target = Vector2(
		(mouse_pos.x / viewport_size.x) * 2 - 1,
		(mouse_pos.y / viewport_size.y) * 2 + 0.5
	)
	
	# Calculate the target rotation
	var target_rot = initial_rotation
	target_rot.y += -look_target.x * tilt_amount
	target_rot.x += -look_target.y * tilt_amount
	
	# Smoothly interpolate to the target
	rotation_degrees = rotation_degrees.lerp(target_rot, lerp_speed * delta)

var currentHoveredCard = null
@onready var hoverUI = $"../canvasUI/mainUI/hoverTrump"

func processCardHover():
	if GLOBAL.isInventoryOpen:
		hoverUI.visible = false
		return
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = self.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + self.project_ray_normal(mousePos) * 100.0
	
	var world3D = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	
	query.collision_mask = 2 
	query.collide_with_areas = true
	
	var result = world3D.intersect_ray(query)
	
	if result:
		var hitNode = result.collider
		if currentHoveredCard != hitNode:
			currentHoveredCard = hitNode
			hoverUI.get_node("name").text = hitNode.getData().name
			hoverUI.get_node("desc").text = hitNode.getData().desc

			hoverUI.get_node("info").text = "[color=white]Card Chosen: [/color][color=yellow]Insolence[/color]\n" + \
					  "[color=light_gray]Placed by " + ("you" if hitNode.thisOwner == GLOBAL.entity.PLAYER else "opponent") + "[/color]"

			await get_tree().process_frame
			hoverUI.fadeIn()
		hoverUI.position = get_viewport().get_mouse_position() + Vector2(0, hoverUI.size.y * -1)
	else:
		if currentHoveredCard != null:
			currentHoveredCard = null
			hoverUI.fadeOut()
