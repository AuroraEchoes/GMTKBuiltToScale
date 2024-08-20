extends Node
class_name Audio

const audio_scn = preload("res://scenes/Audio.tscn")

var metal_crash: AudioStreamPlayer2D
var wood_crash: AudioStreamPlayer2D
var scale_down: AudioStreamPlayer2D
var scale_up: AudioStreamPlayer2D

func _ready() -> void:
	add_child(audio_scn.instantiate())
	StaticEventManager.audio_collision.connect(_play_collision)
	StaticEventManager.audio_scale_effect.connect(_play_scale_effect)
	wood_crash = $Audio/WoodCrash
	metal_crash = $Audio/MetalCrash
	scale_down = $Audio/ScaleDown
	scale_up = $Audio/ScaleUp

func _play_collision(material: Global.MaterialType, velocity: float, scl: float, position: Vector2):
	var audio_player: AudioStreamPlayer2D
	if material == Global.MaterialType.Metal:
		audio_player = metal_crash
	else:
		audio_player = wood_crash
	if !audio_player.playing:
		audio_player.position = position
		audio_player.pitch_scale = (1 / scl) * 1000
		audio_player.volume_db = (min(velocity, 200) - 10.0) / 20
		audio_player.play()

func _play_scale_effect(position: Vector2, up: bool):
	var audio_player: AudioStreamPlayer2D
	if up:
		audio_player = scale_up
	else:
		audio_player = scale_down
	if !audio_player.playing:
		audio_player.position = position
		audio_player.play()
