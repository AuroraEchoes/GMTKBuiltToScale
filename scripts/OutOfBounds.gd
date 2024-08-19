extends Area2D

var ticks_since_in_level: int = 0

func _process(_delta: float) -> void:
	var contains_player: bool = false
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			contains_player = true
			ticks_since_in_level = 0
	if not contains_player:
		ticks_since_in_level += 1
	if ticks_since_in_level > 20:
		Global.load_level(get_parent().level_name, get_parent())
