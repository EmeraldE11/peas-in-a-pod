extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = ""  # Ensure the label text is empty initially

# Function to display the game over message
func show_game_over_message():
	$Label.text = "Game Over!"
