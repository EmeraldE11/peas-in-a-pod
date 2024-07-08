extends Area2D

signal request_quit_game

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the body_entered signal only if not already connected
	#if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		print("hello")


func _on_area_entered(area):
	if area.is_in_group("pea"):  # Check if the body is in the "pea" group
		print("Game Over! Steak collided with Pea.")
		emit_signal("request_quit_game")
