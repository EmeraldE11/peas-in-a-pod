extends Node

var hud
var pealet_scene = preload("res://pealet.tscn")

func _ready():
	# Load the player scene
	var player_scene = preload("res://pea.tscn")
	var steak_scene = preload("res://steak.tscn")
	var hud_scene = preload("res://hud.tscn")  # Load the HUD scene
	
	# Instantiate player 1
	var player1 = player_scene.instantiate()
	player1.position = Vector2(90, 120)  # Set initial position for player 1
	player1.input_prefix = "player1_"
	player1.add_to_group("player1")
	add_child(player1)
	
	# Instantiate player 2
	var player2 = player_scene.instantiate()
	player2.position = Vector2(150, 120)  # Set initial position for player 2
	player2.input_prefix = "player2_"
	player2.add_to_group("player2")
	add_child(player2)
	
	# Instantiate steak
	var steak = steak_scene.instantiate()
	steak.position = Vector2(400, 400)  # Set initial position for steak
	add_child(steak)
	
	# Instantiate and add the HUD to the scene
	hud = hud_scene.instantiate()
	add_child(hud)
	
	# Connect hit signals for both players to the steak
	player1.connect("hit", Callable(steak, "_on_area_entered"))
	player2.connect("hit", Callable(steak, "_on_area_entered"))
	
	# Connect steak's request_quit_game signal to the main script's handler
	steak.connect("request_quit_game", Callable(self, "_on_request_quit_game"))

	# Set references to each other
	player1.other_player = player2
	player2.other_player = player1
	
	# Connect hit signals
	player1.connect("hit", Callable(self, "_on_player_hit"))
	player2.connect("hit", Callable(self, "_on_player_hit"))
	
	# Connect position update signals
	player1.connect("position_updated", Callable(player2, "_on_other_player_position_updated"))
	player2.connect("position_updated", Callable(player1, "_on_other_player_position_updated"))

	# Spawn initial pealets
	spawn_pealet("red")
	spawn_pealet("blue")

func _on_player_hit(player):
	# Handle player collision here
	print("Player collided:", player.name)
	# Implement collision resolution logic here

func _on_request_quit_game():
	print("Game Over!")
	hud.show_game_over_message()  # Show the game over message
	# Optionally, stop game logic or player input here
	get_tree().quit()  # Quit the game

func spawn_pealet(color):
	var pealet = pealet_scene.instantiate()
	
	# Random position within the screen bounds
	var random_x = int(Vector2.ZERO.x)
	var random_y = int(Vector2.ZERO.y)
	pealet.position = Vector2(random_x, random_y).snapped(Vector2(60, 60))

	# Assign player type
	if color == "red":
		pealet.player_type = "player1"
	elif color == "blue":
		pealet.player_type = "player2"

	# Connect the collected signal
	pealet.connect("collected", Callable(self, "_on_pealet_collected"))

	add_child(pealet)

func _on_pealet_collected():
	print("Pealet collected!")
	# Handle what happens when a pealet is collected (ex: update score)
