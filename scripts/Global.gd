extends Node

const SCALE_AMOUNT: float = 0.2
const MAX_SCALE: float = 2.5
const MIN_SCALE: float = 0.1

var level_weight_remaining: float = 500.0

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
