extends RigidBody3D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("target"):
		visible = false
		set_deferred("freeze", true)
		$CollisionShape3D.set_deferred("disabled", true)
		if body.has_method("register_hit"):
			body.register_hit()


func _on_body_exited(body: Node) -> void:
	pass # Replace with function body.
