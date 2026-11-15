
extends Marker3D

@export var customer_scene: PackedScene
@export var spawn_on_start: bool = true
@export var customer_scale: float = 1.0

var spawned_customer: Node3D = null


func _ready() -> void:
	print("CUSTOMER SPAWNER LOADED!")

	if spawn_on_start:
		spawn_customer()


func spawn_customer() -> void:
	# Check whether a character scene is assigned.
	if customer_scene == null:
		push_warning("No customer scene assigned!")
		return

	# Prevent spawning the same customer twice.
	if is_instance_valid(spawned_customer):
		return

	# Create the customer.
	var customer = customer_scene.instantiate() as Node3D

	if customer == null:
		push_error("Customer scene needs a 3D root node!")
		return

	# Add her to the kitchen.
	get_parent().add_child(customer)

	# Move her to the spawn point.
	customer.global_transform = global_transform

	# Adjust her size if needed.
	customer.scale *= customer_scale

	spawned_customer = customer

	print("CUSTOMER SPAWNED SUCCESSFULLY!")
