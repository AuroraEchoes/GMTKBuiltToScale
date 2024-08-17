extends CanvasLayer

@onready var info_text: RichTextLabel = $MarginContainer/PanelContainer/MarginContainer/InfoText

func _ready() -> void:
	StaticEventManager.scalable_element_selected.connect(_on_scaleable_element_selected)
	# Hide UI whenever nothing is selected
	StaticEventManager.scalable_element_deselected.connect(func(): hide())
	# And start hiding
	hide()

func _on_scaleable_element_selected(mat_type: Global.MaterialType, weight: float):
	show()
	# This is a janky way of doing this, but it'll work for now
	info_text.text = str(Global.MaterialType.keys()[mat_type]) + " | " + str(weight) + "kg |  TBD WEIGHT REMAINING"
