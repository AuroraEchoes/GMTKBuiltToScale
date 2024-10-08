extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	StaticEventManager.request_player_node_path.connect(_on_request_player_node_path)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")

	var direction := Input.get_axis("move_left", "move_right")
	if abs(direction) > 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_request_player_node_path():
	StaticEventManager.player_node_path.emit(get_path())
