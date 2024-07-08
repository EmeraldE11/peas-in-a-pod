extends Area2D

signal collected

# Called when the node enters the scene tree for the first time.
func _ready():

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("pea"):
		# Emit the collected signal
		emit_signal("collected")
		# Optionally, you can add effects like sound or animation here
		# Queue the coin for deletion
		queue_free()
