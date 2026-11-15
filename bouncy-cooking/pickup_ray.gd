
extends RayCast3D

@export var pickup_range: float = 3.0
@export var hold_distance: float = 0.3

var held_object: RigidBody3D = null
var old_layer: int = 1
var old_mask: int = 1
var old_freeze: bool = false

var prompt_label: Label
var right_mouse_was_down: bool = false


func _ready() -> void:
	enabled = true
	collide_with_bodies = true
	target_position = Vector3(0, 0, -pickup_range)

	print("PICKUP SYSTEM LOADED!")

	# Ignore the player's collision body.
	var player = get_parent().get_parent() as CollisionObject3D

	if player != null:
		add_exception(player)

	# Create the on-screen interface.
	var canvas = CanvasLayer.new()
	add_child(canvas)

	# Create the crosshair.
	var crosshair = Label.new()
	canvas.add_child(crosshair)

	crosshair.text = "+"
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-12, -18)
	crosshair.size = Vector2(24, 36)
	crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair.add_theme_font_size_override("font_size", 25)
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Create the pickup instruction label.
	prompt_label = Label.new()
	canvas.add_child(prompt_label)

	prompt_label.set_anchors_preset(Control.PRESET_CENTER)
	prompt_label.position = Vector2(-150, 35)
	prompt_label.size = Vector2(300, 35)
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_label.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _physics_process(_delta: float) -> void:

	# Detect right mouse click.
	var right_down = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)

	if right_down and not right_mouse_was_down:
		print("RIGHT CLICK DETECTED!")

		# Drop the currently held ingredient.
		if is_instance_valid(held_object):
			print("Dropping: ", held_object.name)
			drop_object()

		# Otherwise, try picking up an ingredient.
		else:
			force_raycast_update()

			var target = get_collider()
			print("Raycast hit: ", target)

			if target is RigidBody3D:
				if target.is_in_group("pickupable"):
					print("Picking up: ", target.name)
					pick_up_object(target)
				else:
					print("Object is NOT in pickupable group!")
			else:
				print("No pickupable ingredient detected!")

	right_mouse_was_down = right_down

	# Keep held ingredient in front of camera.
	if is_instance_valid(held_object):
		held_object.global_position = (
			global_position
			- global_transform.basis.z * hold_distance
		)

		prompt_label.text = "Right Click - Drop " + held_object.name
		return

	held_object = null

	# Check what the player is looking at.
	var target = get_collider() as RigidBody3D

	if target != null and target.is_in_group("pickupable"):
		prompt_label.text = "Right Click - Pick up " + target.name
	else:
		prompt_label.text = ""


func pick_up_object(body: RigidBody3D) -> void:

	print("PICKUP SUCCESSFUL: ", body.name)

	held_object = body

	# Save original physics settings.
	old_layer = body.collision_layer
	old_mask = body.collision_mask
	old_freeze = body.freeze

	# Temporarily disable physics.
	body.freeze = true
	body.collision_layer = 0
	body.collision_mask = 0

	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO

	# Move ingredient in front of the camera.
	body.global_position = (
		global_position
		- global_transform.basis.z * hold_distance
	)


func drop_object() -> void:

	if not is_instance_valid(held_object):
		held_object = null
		return

	var body = held_object
	held_object = null

	print("DROPPED: ", body.name)

	# Restore original physics.
	body.collision_layer = old_layer
	body.collision_mask = old_mask
	body.freeze = old_freeze

	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO

	body.sleeping = false
