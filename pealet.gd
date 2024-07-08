extends Node2D

signal collected

var player_type = ""  # The type of player that can collect this pealet

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if player_type == "player1" and body.is_in_group("player1"):
		emit_signal("collected")
		queue_free()
	elif player_type == "player2" and body.is_in_group("player2"):
		emit_signal("collected")
		queue_free()
