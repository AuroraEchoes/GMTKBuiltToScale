extends RigidBody2D

@export var door_number = 0
@export var door_enable_disble = false
@export var go_to: String

@onready var door: ExitDoor = $Door

func _ready() -> void:
	door.door_number = self.door_number
	door.door_enable_disable = self.door_enable_disble
	door.go_to = self.go_to
	StaticEventManager.door_hack_setup.emit(door_number)
