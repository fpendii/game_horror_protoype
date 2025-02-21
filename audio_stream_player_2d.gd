extends AudioStreamPlayer2D

var volume_level = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# atur volume
	self.volume_db = linear_to_db(volume_level)
	
	# memastikan backsound diputar
	if not playing:
		play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
