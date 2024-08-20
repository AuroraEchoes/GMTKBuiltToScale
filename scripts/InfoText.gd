extends PanelContainer

@onready var text: RichTextLabel = $MarginContainer/Text

func _ready() -> void:
	StaticEventManager.not_enough_weight.connect(_not_enough_weight)
	StaticEventManager.already_at_max_size.connect(_already_at_max_size)
	StaticEventManager.already_at_min_size.connect(_already_at_min_size)
	StaticEventManager.w_to_enter_door.connect(_w_to_enter_door)
	StaticEventManager.say_door_unlocked.connect(_door_unlocked)
	hide()

func _not_enough_weight():
	text.text = "[b][color=#ad1b38]You don’t have enough weight left to do that[/color][/b]"
	_tween_alpha()

func _already_at_max_size():
	text.text = "[b][color=#ad1b38]This can’t be enlarged further[/color][/b]"
	_tween_alpha()

func _already_at_min_size():
	text.text = "[b][color=#ad1b38]This can’t be shrunk further[/color][/b]"
	_tween_alpha()

func _w_to_enter_door():
	text.text = "[b]Press [W] to enter[/b]"
	_tween_alpha()

func _door_unlocked():
	text.text = "[b][color=#42a426]Exit door unlocked[/color][/b]"
	_tween_alpha()


func _tween_alpha():
	show()
	modulate.a = 0.0
	await create_tween().tween_property(self, "modulate:a", 1.0, 0.25).finished
	await get_tree().create_timer(1.0).timeout
	await create_tween().tween_property(self, "modulate:a", 0.0, 0.25).finished
	hide()
