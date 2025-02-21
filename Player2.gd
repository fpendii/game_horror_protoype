extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Audio stream player untuk langkah kaki
@onready var walking_sound_player = $WalkingSoundPlayer

# variabel untuk kontrol langkah kaki
var step_timer = 0.0
var step_interval = 0.6  # Interval untuk langkah kaki dalam detik (default untuk jalan)

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	walking_sound_player.volume_db = -25  # Atur volume sesuai kebutuhan

func _unhandled_input(event) -> void:
	if event is InputEventMouse:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-48), deg_to_rad(68))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
		step_interval = 0.2  # Interval lebih cepat saat sprint
	else:
		speed = WALK_SPEED
		step_interval = 0.7  # Interval lebih lambat saat berjalan

	# Handle jump
	if Input.is_action_just_pressed("jumpt") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_pov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_pov, delta * 8.0)
	
	# Memutar suara langkah kaki sesuai kecepatan
	if is_on_floor() and velocity.length() > 0.1:  # Kecepatan lebih besar dari 0.1 untuk mulai memutar suara
		step_timer += delta
		if step_timer >= step_interval:
			play_footstep_sound()
			step_timer = 0.0
	else:
		# Jika berhenti, hentikan suara langkah kaki
		stop_footstep_sound()

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

# Fungsi untuk memainkan suara langkah kaki
func play_footstep_sound() -> void:
	if not walking_sound_player.playing:
		walking_sound_player.play()

# Fungsi untuk menghentikan suara langkah kaki
func stop_footstep_sound() -> void:
	if walking_sound_player.playing:
		walking_sound_player.stop()
