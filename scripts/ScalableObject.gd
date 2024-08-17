extends MeshInstance2D

const SCALE_DELTA: Vector2 = Vector2(Global.SCALE_AMOUNT, Global.SCALE_AMOUNT)
const MAX_SCALE: Vector2 = Vector2(Global.MAX_SCALE, Global.MAX_SCALE)
const MIN_SCALE: Vector2 = Vector2(Global.MIN_SCALE, Global.MIN_SCALE)

@onready var collision: StaticBody2D = $StaticBody2D

@export var material_type: Global.MaterialType

var selected: bool = false

func _ready() -> void:
	collision.mouse_entered.connect(_select)
	collision.mouse_exited.connect(_deselect)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("increase_scale") and selected:
		scale = clamp(scale + SCALE_DELTA, MIN_SCALE, MAX_SCALE)
	elif Input.is_action_just_pressed("decrease_scale") and selected:
		scale = clamp(scale - SCALE_DELTA, MIN_SCALE, MAX_SCALE)

# Weight is defined as area (percentage of the screen)
# multipled by the material weight coefficient
func _calculate_weight() -> float:
	# Find area
	var mesh_size: Vector2 = mesh.size
	var window_size = get_window().size
	var area: float = (mesh_size.x * mesh_size.y) / (window_size.x * window_size.y)
	# Find material weight coefficient
	var mwc: float = Global.material_weight_coefficient(material_type);
	# Calculate weight
	var weight = area * mwc
	return weight

func _select():
	selected = true
	StaticEventManager.scalable_element_selected.emit(material_type, _calculate_weight())
	# TODO: Activate selected shader

func _deselect():
	selected = false
	StaticEventManager.scalable_element_deselected.emit()
	# TODO: Deactivate selected shader
