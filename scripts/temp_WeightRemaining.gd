extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StaticEventManager.element_scaled.connect(_on_element_scaled)
	_set_weight_remaining()

func _on_element_scaled(_mat_type: Global.MaterialType, _delta: float, _new: float):
	_set_weight_remaining()

func _set_weight_remaining():
	text = "Weight remaining: " + str(int(Global.level_weight_remaining)) + "kg"
