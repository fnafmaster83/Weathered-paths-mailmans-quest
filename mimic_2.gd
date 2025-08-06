extends CharacterBody2D

# Exported variables for editor customization
@export var target_path: NodePath = NodePath()  # Path to the target node
@export var speed: float = 200.0  # Max movement speed
@export var rotation_speed: float = 5.0  # Rotation speed
@export var acceleration: float = 1000.0  # Acceleration
@export var friction: float = 500.0  # Friction
@export var player_respawn_position: Vector2 = Vector2(100, 100)  # Where player respawns

# Internal variables
var _target: Node2D = null
var _velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if target_path:
		_target = get_node_or_null(target_path)
	
	# Connect the killzone signal
	var killzone = $KillZone
	if killzone:
		killzone.connect("body_entered", Callable(self, "_on_killzone_body_entered"))

func _physics_process(delta: float) -> void:
	if not _target:
		return
	
	# Direction and rotation
	var direction: Vector2 = (_target.global_position - global_position).normalized()
	var target_angle: float = direction.angle()
	var current_angle: float = global_rotation
	var angle_diff: float = wrapf(target_angle - current_angle, -PI, PI)
	var max_rotation: float = rotation_speed * delta
	global_rotation += clamp(angle_diff, -max_rotation, max_rotation)

	# Acceleration and movement
	var desired_velocity: Vector2 = direction * speed
	var accel: Vector2 = (desired_velocity - _velocity) * acceleration * delta
	if accel.length() < 0.01:
		accel = -_velocity * friction * delta
	
	_velocity += accel
	_velocity = _velocity.limit_length(speed)
	velocity = _velocity
	move_and_slide()


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Or use `body.is_in_group("Player")`
		print("Player hit by killzone. Resetting position.")
		body.global_position = player_respawn_position
		
		if body.has_method("reset"):
			body.reset()
