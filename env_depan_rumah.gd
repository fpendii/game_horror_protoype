extends Node3D


@onready var pauseMenu = $PauseMenu
var paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pausedMenu()

func pausedMenu():
	if paused:
		pauseMenu.hide()
		Engine.time_scale = 1
	else:
		pauseMenu.show()
		Engine.time_scale = 0
	
	paused = !paused
