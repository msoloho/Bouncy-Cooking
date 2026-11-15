extends RigidBody3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("pickupable"):
		$AudioStreamPlayer3D.play()
		get_tree().paused = true
