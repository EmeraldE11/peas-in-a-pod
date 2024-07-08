extends Area2D
signal hit
signal position_updated(new_position: Vector2)

# Define grid cell size
const GRID_SIZE = 60

# Define the 8 grid positions surrounding the player
var relative_positions = [
	Vector2(-GRID_SIZE, GRID_SIZE),  # pos1
	Vector2(0, GRID_SIZE),           # pos2
	Vector2(GRID_SIZE, GRID_SIZE),   # pos3
	Vector2(GRID_SIZE, 0),           # pos4
	Vector2(GRID_SIZE, -GRID_SIZE),  # pos5
	Vector2(0, -GRID_SIZE),          # pos6
	Vector2(-GRID_SIZE, -GRID_SIZE), # pos7
	Vector2(-GRID_SIZE, 0)           # pos8
]

# Screen bounds
var screen_size = Vector2.ZERO

# Target position in grid units
var target_position = Vector2.ZERO

# Movement speed (cells per second)
var move_speed = 10.0

# Flag to indicate if the player is moving
var is_moving = false

# Input prefix to differentiate controls
var input_prefix = ""

# Reference to the other player
var other_player: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize target position to current position snapped to the grid
	target_position = position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	position = target_position
	
	# Get screen size
	screen_size = get_viewport_rect().size
	
	# Connect to the body_entered signal only if not already connected
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		move_towards_target(delta)
	else:
		handle_input()

func handle_input():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_just_pressed(input_prefix + "up"):
		input_vector.y -= 1
	elif Input.is_action_just_pressed(input_prefix + "down"):
		input_vector.y += 1
	elif Input.is_action_just_pressed(input_prefix + "left"):
		input_vector.x -= 1
	elif Input.is_action_just_pressed(input_prefix + "right"):
		input_vector.x += 1
		
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		# Placeholder position to check bounds first
		var new_target_position = position + input_vector * GRID_SIZE
		
		# Clamp to screen boundaries
		new_target_position.x = clamp(new_target_position.x, 30, screen_size.x - GRID_SIZE / 2)
		new_target_position.y = clamp(new_target_position.y, 30, screen_size.y - GRID_SIZE / 2)
		
		# Check if the new target position would collide with the other player
		if not will_collide_with_other_player(new_target_position):
			target_position = new_target_position
			is_moving = true
			# Emit signal with new position
			emit_signal("position_updated", target_position)

func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	var move_amount = move_speed * GRID_SIZE * delta
	position += direction * move_amount

	if position.distance_to(target_position) < move_amount:
		position = target_position
		is_moving = false

func will_collide_with_other_player(new_target_position: Vector2) -> bool:
	# Check if the new target position is the same as the other player's position
	if new_target_position == other_player.position:
		return true
	
	# Check if the new target position is one of the 8 surrounding positions of the other player
	for relative_position in relative_positions:
		if new_target_position == other_player.position + relative_position:
			return false
	
	return true

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("hit", body)  # Emit hit signal with the colliding player node
		is_moving = false
		target_position = position

# Update position based on the other player's movement
func _on_other_player_position_updated(_new_position: Vector2):
	# Just receive the signal; no action needed for this specific use case
	pass
