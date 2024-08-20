extends Node2D
class_name LevelInfo

@export var weight_remaining: float
@export var level_name: String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		Global.load_level(level_name, self)
