#extends RigidBody2D
#
#@export_group("Enemy Car Settings")
#@export var engine_power: float = 700.0
#@export var steering_power: float = 3.5
#@export var drift_factor: float = 0.9
#@export var max_speed: float = 1000.0
#
#@export var player_car: Node
#
#func _ready():
	#gravity_scale = 0
	#linear_damp = 1.0
	#angular_damp = 3.0
	#
	## Find the player car automatically (optional)
	##player_car = get_node_or_null("/root/Main/PlayerCar") # Change to match your scene path
#
#func _physics_process(delta):
	#if player_car == null:
		#return
#
	#var to_target = (player_car.global_position - global_position)
	#var distance = to_target.length()
	#var direction = to_target.normalized()
#
	## Convert global direction to local space
	#var local_direction = global_transform.basis_xform_inv(direction)
#
	## Decide whether to move forward or stop (optional)
	#var throttle = 1.0
	#var steering = 0.0
#
	## Steer towards player
	#if abs(local_direction.x) > 0.1:
		#steering = sign(local_direction.x)
#
	#apply_enemy_physics(throttle, steering, delta)
#
#func apply_enemy_physics(throttle: float, steering: float, delta: float):
	#var local_velocity = global_transform.basis_xform_inv(linear_velocity)
#
	## Engine force in local space (forward only)
	#var engine_force = Vector2(0, -throttle * engine_power)
	#var force = global_transform.basis_xform(engine_force)
	#apply_central_force(force)
#
	## Steering torque
	#var speed = linear_velocity.length()
	#if speed > 5.0:
		#var steer_force = steering * steering_power * speed
		#apply_torque(steer_force)
#
	## Drift control
	#var forward_velocity = global_transform.basis_xform(Vector2(0, local_velocity.y))
	#var side_velocity = global_transform.basis_xform(Vector2(local_velocity.x, 0))
	#linear_velocity = forward_velocity + side_velocity * drift_factor
#
	## Limit max speed
	#if linear_velocity.length() > max_speed:
		#linear_velocity = linear_velocity.normalized() * max_speed
extends CharacterBody2D

# Exported variables for editor customization
@export var target_path: NodePath = NodePath()  # Path to the target node
@export var speed: float = 200.0  # Maximum movement speed
@export var rotation_speed: float = 5.0  # Rotation speed in radians/second
@export var acceleration: float = 1000.0  # Acceleration rate
@export var friction: float = 500.0  # Deceleration rate

# Internal variables
var _target: Node2D = null
var _velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Get the target node from the exported path
	if target_path:
		_target = get_node_or_null(target_path)

func _physics_process(delta: float) -> void:
	if not _target:
		return
	
	# Get direction to target
	var direction: Vector2 = (_target.global_position - global_position).normalized()
	
	# Rotate towards target
	var target_angle: float = direction.angle()
	var current_angle: float = global_rotation
	var angle_diff: float = wrapf(target_angle - current_angle, -PI, PI)
	var max_rotation: float = rotation_speed * delta
	# Smoothly rotate by clamping the rotation change
	global_rotation += clamp(angle_diff, -max_rotation, max_rotation)
	
	# Move towards target
	var desired_velocity: Vector2 = direction * speed
	var accel: Vector2 = (desired_velocity - _velocity) * acceleration * delta
	
	# Apply friction when not accelerating
	if accel.length() < 0.01:
		accel = -_velocity * friction * delta
	
	_velocity += accel
	# Clamp velocity to max speed
	_velocity = _velocity.limit_length(speed)
	
	# Apply movement
	velocity = _velocity
	move_and_slide()


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.has_method("reload_scene"):
		body.reload_scene()
