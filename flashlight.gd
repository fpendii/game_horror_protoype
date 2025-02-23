extends SpotLight3D

@onready var battery = 50
var battery_drain_rate = 1 # seberapa cepat baterai berkurang
var is_on = true # status senter aktif atau tidak

@onready var drain_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drain_timer.wait_time = 1.0 # Setiap 1 detik baterai berkurang
	drain_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on:
		battery -= battery_drain_rate * delta
		battery = max(battery, 0)
		print(battery)
		
		light_energy = battery / 100
		
		if battery <= 0:
			is_on = false
			visible = false
		

func toggle_flashlight():
	is_on = !is_on
	visible = is_on

func add_battery(amount):
	battery += amount
	battery = min(battery, 100) # maksimal baterai 100
