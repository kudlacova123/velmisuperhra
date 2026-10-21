extends CharacterBody2D

var is_rolling = false
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump a") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#vraci cislo -1, 0, 1
	var direction := Input.get_axis("left a", "right a")
	
	#flipni animaci
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#prepinani animaci
	if not is_on_floor():
		# Když je postava ve vzduchu (např. skáká nebo padá)
		animated_sprite.play("jump_a") # případně "fall_a", pokud ji máš
	else:
		# Když je postava na zemi
		if direction == 0:
			# Stojí na místě
			if Input.is_action_pressed("sprint a"):
				animated_sprite.play("sprint_a")
			else:
				animated_sprite.play("idle_a") # Zde byla chyba, předtím tu byl běh
		else:
			# Pohybuje se do strany
			animated_sprite.play("run_a") # Zde byl předtím skok
		
	#if Input.is_action_pressed("down") and is_on_floor():
		#animated_sprite.play("crouch")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
