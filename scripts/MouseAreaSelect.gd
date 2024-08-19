extends Control

@onready var selection_nine_patch: NinePatchRect = $SelectionNinePatch

var selection_start: Vector2

func _ready() -> void:
	# Start off with the selection hidden
	selection_nine_patch.hide()

func _process(_delta: float) -> void:
	_take_selection()

func _take_selection():
	var mouse_pos: Vector2 =  get_global_mouse_position()
	# We've just started a selection
	if Input.is_action_just_pressed("region_select"):
		selection_start = mouse_pos
		# Since our ninepatch is hidden by deselecting, reshow it
		selection_nine_patch.show()
	# We're continuing a preexisting selection.
	# As a result, we want to render the temporary selected region,
	# as a preview.
	elif Input.is_action_pressed("region_select"):
		_nine_patch_select_region(selection_start, mouse_pos)
	# We've just completed the selection. We want to indicate that
	# the tiles themselves have now been selected
	elif Input.is_action_just_released("region_select"):
		# Don't set it to null because that could cause problems
		# This shouldn't show anyway, because the ninepatch is hidden
		selection_nine_patch.hide()
		selection_start = Vector2.ZERO
		# TODO: Send some sort of signal to the terrain shader
		# ... indicating the selected region

func _nine_patch_select_region(start: Vector2, end: Vector2):
	# Normalising our points so we have a position and a scale
	var top_left: Vector2 = Vector2(min(start.x, end.x), min(start.y, end.y))
	var bottom_right: Vector2 = Vector2(max(start.x, end.x), max(start.y, end.y))
	selection_nine_patch.position = top_left
	selection_nine_patch.size = abs(bottom_right - top_left)
