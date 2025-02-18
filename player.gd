extends CharacterBody3D

@export var speed = 3.0
@export var mouse_sensitivity = 0.1

var gravity = -9.8
var Velocity = Vector3.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized()
	Velocity.x = direction.x * speed
	Velocity.z = direction.z * speed
	Velocity.y += gravity * delta

	move_and_slide()
