extends ScaleableObject

@export var required_force: float = 50.0

@onready var weight_label: Label = $WeightRemaining

var weight: float = 0.0

func _ready() -> void:
	super._ready()
	collision.body_entered.connect(func(node): print(node.get_path()))

func _process(delta: float) -> void:
	super._process(delta)
	weight_label.text = str(ceili(required_force - self.weight)) + "kg"

func _physics_process(delta: float) -> void:
	collision.apply_central_force(Vector2.UP)
	super._physics_process(delta)
	var weight_count: float = 0.0
	for body in collision.get_colliding_bodies():
		print("body!")
		if body.is_class("RigidBody2D"):
			weight_count += body.mass
		elif body.is_class("CharacterBody2D"):
			weight_count += 10.0
	weight = weight_count
