extends MeshInstance2D
class_name ScaleableObject

@onready var collision: RigidBody2D = $RigidBody2D
@onready var collider: CollisionShape2D = $RigidBody2D/CollisionShape2D
@onready var player_ref: CharacterBody2D

@export var material_type: Global.MaterialType

var selected: bool = false
var tracked_scale: float = 1.0
var base_size: Vector2

func _ready() -> void:
	set_notify_transform(true)
	collision.mouse_entered.connect(_select)
	collision.mouse_exited.connect(_deselect)
	_set_shader_enabled(false)
	# TODO: REMOVE THIS ITS A BAD HACK
	material = material.duplicate()
	# Set collision shape to fit mesh shape
	var quad_mesh: QuadMesh = mesh
	var size: Vector2 = quad_mesh.size
	base_size = size
	var collision_shape: RectangleShape2D = collider.shape
	collision_shape.size = size
	collider.global_position = global_position
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("mesh_size", size * tracked_scale)
	# I feel silly doing this, but I can't think of a nicer way to do this
	StaticEventManager.player_node_path.connect(func(np: NodePath): player_ref = get_node(np))
	StaticEventManager.request_player_node_path.emit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("increase_scale") and selected:
		if _player_in_range(): _change_scale(Global.SCALE_AMOUNT)
	elif Input.is_action_just_pressed("decrease_scale") and selected:
		if _player_in_range(): _change_scale(-Global.SCALE_AMOUNT)

func _player_in_range() -> bool:
	var pos: Vector2 = player_ref.global_position
	var collision_rect: Rect2 = collider.shape.get_rect()
	var p1: Vector2 = collision_rect.position
	var p2: Vector2 = Vector2(collision_rect.end.x, collision_rect.position.y)
	var p3: Vector2 = collision_rect.end
	var p4: Vector2 = Vector2(collision_rect.position.x, collision_rect.end.y)
	var points: Array[Vector2] = [p1, p2, p3, p4]
	var min_dist: Vector2 = Vector2.INF
	for i in range(len(points)):
		var closest: Vector2 = Geometry2D.get_closest_point_to_segment(pos, points[i % 4] + global_position, points[(i + 1) % 4] + global_position)
		if (closest - pos).length() < min_dist.length():
			min_dist = closest
	var dist_from_player = ((min_dist) - pos).length()
	return dist_from_player < Global.GRAB_RANGE

func _physics_process(_delta: float) -> void:
	position += collision.position
	collider.position = Vector2.ZERO

func _change_scale(amount: float):
	# Make sure we're not scaling outside of our range
	var clamped_scale: float = clamp(tracked_scale + amount, Global.MIN_SCALE, Global.MAX_SCALE)
	# Check we have enough weight to scale
	var current_weight: float = _calculate_weight()
	var new_weight: float = _calculate_weight(clamped_scale)
	# We now have two cases. If this is something we've already scaled and we're
	# reverting that change, we should get that weight back into our pool
	# Otherwise, we take the weight away
	# If clamped_scale is closer to 1 than self.scale is, we know we're going
	# to regain that weight
	var curr_dist_from_base_scl: float = abs(tracked_scale - 1)
	var new_dist_from_base_scl: float = abs(clamped_scale - 1)
	# For constency, we always want delta to be close to base - further from base
	# Note the abs() here —  growing and shrinking BOTH cost the weight budget
	collision.mass = new_weight
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
		print("failed")
		return

	# We know we're scaling, so let's do it!
	# TODO: Check for clipping
	tracked_scale = clamped_scale
	tween_scale(self, "mesh:size", base_size * tracked_scale)
	tween_scale(collider, "shape:size", base_size * tracked_scale)
	StaticEventManager.element_scaled.emit(material_type, delta_weight, new_weight)

func tween_scale(node: Node, property: String, value: Vector2):
	create_tween().tween_property(node, property, value, 0.1)

# Weight is defined as area (percentage of the screen)
# multipled by the material weight coefficient
# Scale factor parameter —  if you want to calculate a 
# prospective scale by that amount. Default argument
# will ignore it
func _calculate_weight(scale_factor: float = tracked_scale) -> float:
	# Find area
	var mesh_size: Vector2 = base_size * scale_factor
	var window_size = get_window().size
	var area: float = (mesh_size.x * mesh_size.y) / (window_size.x * window_size.y)
	# Find material weight coefficient
	var mwc: float = Global.material_weight_coefficient(material_type);
	# Calculate weight
	var weight = area * mwc
	return weight

func _select():
	if _player_in_range():
		selected = true
		StaticEventManager.scalable_element_selected.emit(material_type, _calculate_weight())
		_set_shader_enabled(true)

func _deselect():
	selected = false
	StaticEventManager.scalable_element_deselected.emit()
	_set_shader_enabled(false)

func _set_shader_size():
	var quad_mesh: QuadMesh = mesh
	var size: Vector2 = quad_mesh.size
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("mesh_size", size)

# Set the value of the enabled parameter in the shader
# This should toggle it highlighting
func _set_shader_enabled(enabled: bool):
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("enabled", enabled)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_set_shader_size()
