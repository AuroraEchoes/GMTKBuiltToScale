extends ScaleableObject
class_name PressurePlate

@export var required_force: float = 50.0
@export var action: PressurePlateAction
@export var action_id: int

@onready var weight_label: Label = $WeightRemaining
@onready var pressure_area: Area2D = $WeighArea
@onready var pressure_area_collider: CollisionShape2D = $WeighArea/CollisionShape2D

var weight: float = 0.0
var area_base_size: Vector2
var enabled: bool = false

enum PressurePlateAction {
	OPEN_DOOR
}

func _ready() -> void:
	super._ready()
	area_base_size = pressure_area_collider.shape.size

func _process(delta: float) -> void:
	super._process(delta)
	var weight_count: float = 0.0
	for body in pressure_area.get_overlapping_bodies():
		if body.is_class("RigidBody2D") and !body.freeze:
			weight_count += body.mass
		elif body.is_class("CharacterBody2D"):
			weight_count += 10.0
	weight = weight_count
	weight_label.text = str(max(ceili(required_force - self.weight), 0)) + "kg"
	if weight >= required_force:
		match action:
			PressurePlateAction.OPEN_DOOR:
				if !enabled:
					StaticEventManager.say_door_unlocked.emit()
				enabled = true
				StaticEventManager.enable_door.emit(action_id)
