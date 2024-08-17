extends CanvasLayer

@onready var info_text: RichTextLabel = $MarginContainer/PanelContainer/MarginContainer/InfoText

func _ready() -> void:
	StaticEventManager.scalable_element_selected.connect(_on_scaleable_element_selected)
	# Hide UI whenever nothing is selected
	StaticEventManager.scalable_element_deselected.connect(func(): hide())
	StaticEventManager.element_scaled.connect(_on_element_scaled)
	StaticEventManager.failed_element_scale.connect(_on_failed_element_scale)
	# And start hiding
	hide()

func _on_scaleable_element_selected(mat_type: Global.MaterialType, weight: float):
	show()
	# This is a janky way of doing this, but it'll work for now
	info_text.text = str(Global.MaterialType.keys()[mat_type]) + " | " + str(weight) + "kg | " + str(Global.level_weight_remaining) + "kg remaining"

func _on_element_scaled(_mat_type: Global.MaterialType, delta: float, _new: float):
	info_text.text = "[color=green]SCALED OBJECT for " + str(delta) + " kg[/color]"

func _on_failed_element_scale():
	info_text.text = "[color=red] NOT ENOUGH LEVEL WEIGHT REMAINING[/color]"
