
extends StaticBody3D

@export var new_gltf_scene: PackedScene
@export var hits: int = 3

@onready var model_holder: Node3D = $ModelHolder
@onready var pizza: Node = get_node_or_null("../Pizza")

var hit_count: int = 0
var has_swapped: bool = false


func _ready() -> void:
	print("STOVETOP SYSTEM LOADED!")
	print("Ingredients required: ", hits)

	if pizza == null:
		push_warning("Pizza node was not found!")
	else:
		print("Pizza node found!")

	if new_gltf_scene == null:
		print("No replacement stove model assigned.")


func register_hit() -> void:
	if has_swapped:
		return

	hit_count += 1

	print("INGREDIENT REGISTERED: ", hit_count, "/", hits)

	if hit_count >= hits:
		has_swapped = true
		print("THREE HITS REGISTERED! Cooking complete!")

		swap_model()

		if is_instance_valid(pizza):
			if pizza.has_method("activate"):
				pizza.call("activate")
				print("PIZZA ACTIVATION REQUESTED!")
			else:
				push_warning("Pizza does not have activate()!")
		else:
			push_warning("Cannot activate pizza: node missing!")


func swap_model() -> void:
	if new_gltf_scene == null:
		print("Skipping stove model swap.")
		return

	var old_transform := Transform3D.IDENTITY

	if model_holder.get_child_count() > 0:
		var first_model = model_holder.get_child(0) as Node3D

		if first_model != null:
			old_transform = first_model.transform

	var instance = new_gltf_scene.instantiate()

	if not instance is Node3D:
		push_warning("Replacement model must have a Node3D root!")
		instance.queue_free()
		return

	for child in model_holder.get_children():
		model_holder.remove_child(child)
		child.queue_free()

	model_holder.add_child(instance)
	instance.transform = old_transform

	print("STOVETOP MODEL SWAPPED!")
