extends Control
class_name DialogueManager

@onready var portrait: TextureRect = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/CharacterPortrait
@onready var dialogue_text: RichTextLabel = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Dialogue
@onready var name_text: RichTextLabel = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Name

@export var queued_dialogue: Array[DialogueEntry] = []

var next_dialogue_locked = true;
var running_dialogue = false;

enum CharacterPortrait {
	ROBOT_TEMP
}

# Ideally we'd just include the signals directly
# in the resources. But Godot won't allow it.
# So we're such with this instead...
enum DialogueStartTrigger {
	END_OF_PREVIOUS,
	LMB_CLICK
}

func _ready():
	hide()

func _process(_delta: float):
	# Try and unlock next dialogue
	_try_unlock_next_dialogue()
	# Set up next dialogue
	if !queued_dialogue.is_empty() and !next_dialogue_locked:
		# Lock dialogue
		running_dialogue = true
		show()
		var dialogue: DialogueEntry = queued_dialogue.pop_front()
		portrait.texture = _load_character_portrait(dialogue.portrait)
		name_text.text = dialogue.name
		dialogue_text.text = dialogue.dialogue
		# Text write on
		dialogue_text.visible_ratio = 0.0
		var tween := create_tween()
		tween.tween_property(dialogue_text, "visible_ratio", 1.0, dialogue.display_time)
		tween.finished.connect(func(): running_dialogue = false)
	elif queued_dialogue.is_empty() and Input.is_action_just_pressed("left_click"):
		hide()

func _try_unlock_next_dialogue():
	if !queued_dialogue.is_empty():
		var dialogue: DialogueEntry = queued_dialogue.front()
		match dialogue.start_trigger:
			DialogueStartTrigger.END_OF_PREVIOUS:
				next_dialogue_locked = running_dialogue
			DialogueStartTrigger.LMB_CLICK:
				next_dialogue_locked = running_dialogue or !Input.is_action_just_pressed("left_click")


func _load_character_portrait(character: CharacterPortrait) -> ImageTexture:
	var image: Image
	match character:
		CharacterPortrait.ROBOT_TEMP:
			image = Image.load_from_file("res://assets/textures/high_quality_protagonist.png")
		# You chose a thing which does exist, you silly billy
		# Here, have a lead pipe instead :)
		_:
			image = Image.load_from_file("res://assets/textures/temp_metal_texture.png")
	return ImageTexture.create_from_image(image)
