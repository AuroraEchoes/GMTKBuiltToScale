extends Node

signal scalable_element_selected(mat_type: Global.MaterialType, weight: float)
signal scalable_element_deselected()
signal element_scaled(mat_type: Global.MaterialType, delta: float, new_weight: float)
signal request_player_node_path()
signal player_node_path(path: NodePath)
signal enable_door(door_number: int)
signal not_enough_weight()
signal already_at_max_size()
signal already_at_min_size()
signal w_to_enter_door()
