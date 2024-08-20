extends RigidBody2D

@onready var obstacle: ScaleableObject = $Obstacle

func _ready() -> void:
	body_entered.connect(_audio_collide)

func _audio_collide(_a: Node2D):
	if linear_velocity.length() > 0.05:
		var area: Vector2 = obstacle.tracked_scale * obstacle.mesh.size
		var visible_size: Vector2 = get_viewport().get_visible_rect().size
		var scl: float = (area.x * area.y) / (visible_size.x / visible_size.y)
		StaticEventManager.audio_collision.emit(obstacle.material_type, linear_velocity.length(), scl, global_position)
