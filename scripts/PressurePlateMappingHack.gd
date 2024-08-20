extends RigidBody2D

@export var required_force: float
@export var action: PressurePlate.PressurePlateAction
@export var action_id: int

@onready var pressure_plate: PressurePlate = $PressurePlate

func _ready() -> void:
	pressure_plate.required_force = self.required_force
	pressure_plate.action = self.action
	pressure_plate.action_id = action_id
