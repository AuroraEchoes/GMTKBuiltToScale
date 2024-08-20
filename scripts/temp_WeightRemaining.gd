extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StaticEventManager.element_scaled.connect(_on_element_scaled)
	_set_weight_remaining()

func _on_element_scaled(_mat_type: Global.MaterialType, _delta: float, _new: float):
	_set_weight_remaining()

func _process(_delta):
	_set_weight_remaining()

func _set_weight_remaining():
	var par: Node2D = get_node("/root/Level")
	if par is LevelInfo:
		text = "Weight remaining: " + str(int(par.weight_remaining)) + "kg"
	else:
		hide()
