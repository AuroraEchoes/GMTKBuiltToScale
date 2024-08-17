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
	_set_shader_enabled(false)
	# TODO: REMOVE THIS ITS A BAD HACK
	material = material.duplicate()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("increase_scale") and selected:
		_change_scale(SCALE_DELTA)
	elif Input.is_action_just_pressed("decrease_scale") and selected:
		_change_scale(-SCALE_DELTA)

func _change_scale(amount: Vector2):
	# Make sure we're not scaling outside of our range
	var clamped_scale: Vector2 = clamp(scale + amount, MIN_SCALE, MAX_SCALE)
	# Check we have enough weight to scale
	var current_weight: float = _calculate_weight()
	var new_weight: float = _calculate_weight(clamped_scale)
	# We now have two cases. If this is something we've already scaled and we're
	# reverting that change, we should get that weight back into our pool
	# Otherwise, we take the weight away
	# If clamped_scale is closer to 1 than self.scale is, we know we're going
	# to regain that weight
	var curr_dist_from_base_scl: float = abs((self.scale - Vector2(1, 1)).length())
	var new_dist_from_base_scl: float = abs((clamped_scale - Vector2(1, 1)).length())
	# For constency, we always want delta to be close to base - further from base
	# Note the abs() here —  growing and shrinking BOTH cost the weight budget
	var delta_weight: float
	if new_dist_from_base_scl < curr_dist_from_base_scl:
		delta_weight = abs(current_weight - new_weight)
	else:
		delta_weight = abs(new_weight - current_weight)
	# We're returning to the base scale, and thus we're gaining weight
	if new_dist_from_base_scl < curr_dist_from_base_scl:
		Global.level_weight_remaining += delta_weight
	# This is going to cost us weight, so check we have enough banked
	elif delta_weight <= Global.level_weight_remaining:
		Global.level_weight_remaining -= delta_weight
	# We can't scale, and early return so as not to scale
	else: 
		StaticEventManager.failed_element_scale.emit()
		return

	# We know we're scaling, so let's do it!
	# TODO: Check for clipping
	create_tween().tween_property(self, "scale", clamped_scale, 0.1)
	StaticEventManager.element_scaled.emit(material_type, delta_weight, new_weight)

# Weight is defined as area (percentage of the screen)
# multipled by the material weight coefficient
# Scale factor parameter —  if you want to calculate a 
# prospective scale by that amount. Default argument
# will ignore it
func _calculate_weight(scale_factor: Vector2 = self.scale) -> float:
	# Find area
	var mesh_size: Vector2 = mesh.size * scale_factor
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
	_set_shader_enabled(true)

func _deselect():
	selected = false
	StaticEventManager.scalable_element_deselected.emit()
	_set_shader_enabled(false)

# Set the value of the enabled parameter in the shader
# This should toggle it highlighting
func _set_shader_enabled(enabled: bool):
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("enabled", enabled)
