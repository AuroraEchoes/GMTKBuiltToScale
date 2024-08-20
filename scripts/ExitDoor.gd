extends ScaleableObject
class_name ExitDoor

@onready var trigger_area: Area2D = $Area2D
@onready var trigger_area_collider: CollisionShape2D = $Area2D/CollisionShape2D

@export var door_number: int
@export var door_enable_disable: bool
@export var go_to: String

var area_base_size: Vector2
var door_enabled: bool = false
var door_label: Label
var in_area: bool = false

func _ready() -> void:
	super._ready()
	area_base_size = trigger_area_collider.shape.size
	self.self_trigger_scale_change.connect(func(scl: float): trigger_area_collider.shape.size = area_base_size * scl)
	StaticEventManager.door_hack_setup.connect(_ready_setup)
	trigger_area.body_entered.connect(_on_enter_door)
	trigger_area.body_exited.connect(_on_exit_door)
	
func _ready_setup(id: int):
	if id == door_number:
		if door_enable_disable:
			door_label = Label.new()
			door_label.text = "Door Disabled"
			add_child(door_label)
			StaticEventManager.enable_door.connect(_on_enable_door)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if ((door_enabled and door_enable_disable) or not door_enable_disable) and in_area and Input.is_action_just_pressed("enter_door"):
		Global.load_level(go_to, get_node("/root/Level"))

func _on_enable_door(number: int):
	if number == door_number:
		door_enabled = true
		door_label.text = "Door Enabled"

func _on_enter_door(body: Node2D):
	if body is CharacterBody2D:
		if (door_enable_disable and door_enabled) or not door_enable_disable:
			StaticEventManager.w_to_enter_door.emit()
		in_area = true


func _on_exit_door(body: Node2D):
	if body is CharacterBody2D:
		in_area = false
