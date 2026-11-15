extends StaticBody3D

@export var new_gltf_scene: PackedScene
@export var hits: int = 3
@onready var model_holder: Node3D = $ModelHolder
@onready var pizza: Node = get_node_or_null("../Pizza")

var hit_count: int = 0
var has_swapped: bool = false

func register_hit() -> void:	
		if has_swapped:
			return
		hit_count += 1
		if hit_count >= hits:
			swap_model()
			if pizza:
				pizza.activate()
			
func swap_model() -> void:
	if new_gltf_scene == null:
		return
		
	has_swapped = true
	
	var old_transform := Transform3D.IDENTITY
	if model_holder.get_child_count() > 0:
		old_transform = model_holder.get_child(0).transform
	
	for child in model_holder.get_children():
		child.queue_free()
	
	var new_model = new_gltf_scene.instantiate()
	new_model.transform = old_transform
	model_holder.add_child(new_model)
