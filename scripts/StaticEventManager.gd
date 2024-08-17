extends Node

signal scalable_element_selected(mat_type: Global.MaterialType, weight: float)
signal scalable_element_deselected()
signal element_scaled(mat_type: Global.MaterialType, delta: float, new_weight: float)
signal failed_element_scale()
