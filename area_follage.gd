extends Area3D

signal GrassTouch

#@onready var grassSound = 



func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		print("Player menginjak Rumput")
		emit_signal("GrassTouch")
