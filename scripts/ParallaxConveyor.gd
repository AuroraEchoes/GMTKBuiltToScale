extends ParallaxLayer

@export var scroll_speed: float = 10.0

func _process(delta: float) -> void:
	self.motion_offset.x -= scroll_speed * delta
