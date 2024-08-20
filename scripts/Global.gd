extends Node

const SCALE_AMOUNT: float = 0.2
const MAX_SCALE: float = 2.5
const MIN_SCALE: float = 0.1
const GRAB_RANGE: float = 500.0

const LVL_SELECT: PackedScene = preload("res://scenes/levels/LevelSelect.tscn")
const LVL_ONE: PackedScene = preload("res://scenes/levels/Level1.tscn")
const LVL_TWO: PackedScene = preload("res://scenes/levels/Level2.tscn")
const LVL_THREE: PackedScene = preload("res://scenes/levels/Level3.tscn")

var level_weight_remaining: float = 7.5

enum MaterialType {
	Metal,
	Wood
}

# Since we calculate a material's quantity by the percentage of the screen
# it takes up, this is going to be a pretty high number
func material_weight_coefficient(material: MaterialType) -> float:
	match material:
		MaterialType.Metal:
			return 2000.0
		MaterialType.Wood:
			return 800.0
		_:
			return 0.0

func load_level(level_name: String, to_remove: Node):
	to_remove.queue_free()
	get_tree().paused = false
	await get_tree().create_timer(0.005).timeout
	print("Loading level " + level_name)
	match level_name:
		"lvl_select":
			get_parent().add_child(LVL_SELECT.instantiate())
		"lvl_one":
			get_parent().add_child(LVL_ONE.instantiate())
		"lvl_two":
			get_parent().add_child(LVL_TWO.instantiate())
		"lvl_three":
			get_parent().add_child(LVL_THREE.instantiate())
