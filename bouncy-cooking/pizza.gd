
extends RigidBody3D


func _ready() -> void:
	# Keep pizza hidden until cooking is complete.
	deactivate()


func deactivate() -> void:
	# Hide the pizza.
	visible = false
	freeze = true

	# Disable its collision until activated.
	$CollisionShape3D.set_deferred("disabled", true)

	# Prevent picking up inactive pizza.
	if is_in_group("pickupable"):
		remove_from_group("pickupable")

	print("PIZZA INACTIVE - Waiting for ingredients")


func activate() -> void:
	# Show the finished pizza.
	visible = true
	$Pizza.visible = true

	# Restore physics and collisions.
	set_deferred("freeze", false)
	$CollisionShape3D.set_deferred("disabled", false)

	# Make the finished pizza pickupable.
	if not is_in_group("pickupable"):
		add_to_group("pickupable")

	# Preserve the original target functionality.
	if not is_in_group("target"):
		add_to_group("target")

	print("PIZZA ACTIVATED - Ready to pick up!")


func _on_body_entered(_body: Node) -> void:
	# Do not automatically remove pizza when
	# the player touches it.
	# The pickup system handles interaction.
	pass
