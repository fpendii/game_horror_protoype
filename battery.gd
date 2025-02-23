extends Area3D

var battery_value = 30

@onready var flashLight = $Player/Head/Camera3D/FlashLight

func _on_body_entered(body) -> void:
	if body.name == "Player":
		print('Babi')
		body.flashLight.add_battery(battery_value)
		queue_free() # hapus baterai setelah di ambil
