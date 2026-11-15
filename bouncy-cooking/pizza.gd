extends RigidBody3D

func _ready() -> void:
	deactivate()

func deactivate() -> void:
	visible = false
	freeze = true
	$CollisionShape3D.disabled = true

func activate() -> void:
	visible = true
	$Pizza.visible = true
	set_deferred("freeze", false)
	$CollisionShape3D.set_deferred("disabled", false)
	if not is_in_group("target"):
		add_to_group("target")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		visible = false
		set_deferred("freeze", true)
		$CollisionShape3D.set_deferred("disabled", true)
		# Add any points, score, or collection logic here
