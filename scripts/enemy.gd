extends CharacterBody2D

# Speed and gravity settings
var default_speed: float = 50  # Default speed when the player is stationary
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_strength: float = -300
var follow_distance: float = 50  # Distance behind the player
var player: CharacterBody2D = null  # Ensure this is of type CharacterBody2D to access velocity directly

# Timer for random movements
var movement_timer: Timer = null

# Flags for jumping
var has_jumped: bool = false

func _ready():
	# Find the player node in the scene
	player = get_parent().get_node("Player") as CharacterBody2D
	
	# Create a timer for random movements
	movement_timer = Timer.new()
	movement_timer.wait_time = 5.0  # Change direction every 2 seconds
	movement_timer.one_shot = false
	
	# Add the timer as a child node
	add_child(movement_timer)
	
	# Correctly connect the timer's timeout signal
	movement_timer.connect("timeout", Callable(self, "_on_movement_timer_timeout"))
	
	# Start the timer
	movement_timer.start()

func _physics_process(delta):
	if player:
		# Calculate the direction to the player
		var direction = (player.position - position).normalized()

		# Get the distance to the player
		var distance_to_player = position.distance_to(player.position)

		# Get the player's current horizontal velocity
		var player_velocity_x = player.velocity.x

		# Adjust enemy speed based on player movement
		var current_speed = player_velocity_x if abs(player_velocity_x) > 0 else default_speed

		# If the enemy is farther than the follow distance, follow the player
		if distance_to_player > follow_distance:
			# Apply horizontal movement
			velocity.x = direction.x * current_speed

			# Check for horizontal collisions
			if is_on_wall() and !has_jumped:
				# If colliding with a wall and has not jumped, jump
				velocity.y = jump_strength
				has_jumped = true

			# Check if there is no ground below
			elif !is_on_floor() and !has_jumped:
				# If there's no floor below and has not jumped, jump
				velocity.y = jump_strength
				has_jumped = true

		else:
			# If close enough, move randomly
			velocity.x += randf_range(-0.5, 0.5) * current_speed

		# Apply gravity
		velocity.y += gravity * delta

		# Move the enemy using velocity
		move_and_slide()

		# Reset the jump flag if the enemy is on the floor
		if is_on_floor():
			has_jumped = false
		
func _on_movement_timer_timeout():
	# Change the movement direction randomly when the timer runs out
	velocity.x = randf_range(-1.0, 1.0) * default_speed
