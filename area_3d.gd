extends Area3D

signal playerMenyentuhMobil

@onready var sireneSound = $"../AudioSirene"

func _on_body_entered(body) -> void:
	if body.name == "Player":
		print("Player Mendekat Ambulance")
		emit_signal("playerMenyentuhMobil")
		sireneSound.play()



func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		print("Player Menjauh dari Ambulance")
		sireneSound.stop()
