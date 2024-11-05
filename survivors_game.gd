extends Node2D

var player
var score = 0
const max_distance_tree_from_player_to_remove = 900
var trees_count = 0

func _ready() -> void:
	# Unpause the scene after it's been paused on player's death
	if get_tree().paused == true:
		get_tree().paused = false
	player = get_node("Player")
	%Score.text = "Score: " + str(score)
	
	
func _process(delta: float) -> void:
	var esc_pressed = Input.is_action_just_pressed("pause")
	if esc_pressed:
		get_tree().paused = true
		%PausePanel.show()
		
	if randf_range(0, 10) < 5:
		spawn_tree()
		spawn_weapon()
	if randf_range(0, 100) < 5:
		spawn_weapon()
	# Check and remove distant trees
	for child in get_children():
		if (child.has_method("is_tree") and child.is_tree() or (child.has_method("is_weapon") and child.is_weapon())): # Making sure the child node is a pine_tree node
			var distance = child.global_position.distance_to(player.global_position)
			if distance > max_distance_tree_from_player_to_remove:
				child.queue_free()
	%Score.text = "Score: " + str(score)
	
func spawn_tree():
	var pine_tree = preload("res://pine_tree.tscn")
	var player_pos = player.global_position
	var viewport_size = get_viewport().size

	var attempts = 0
	var max_attempts = 3  # Adjust as needed

	while attempts < max_attempts:
		var spawn_x = player_pos.x + randf_range(-viewport_size.x * 1.5, viewport_size.x * 1.5)
		var spawn_y = player_pos.y + randf_range(-viewport_size.y * 1.5, viewport_size.y * 1.5)
		# Ensure the spawn position is outside the player's immediate vicinity
		var distance_to_player = player_pos.distance_to(Vector2(spawn_x, spawn_y))
		if (spawn_x > player_pos.x - viewport_size.x ) and (spawn_x < player_pos.x + viewport_size.x ) and \
		(spawn_y > player_pos.y - viewport_size.y ) and (spawn_y < player_pos.y + viewport_size.y ):
			continue
		var new_tree = pine_tree.instantiate()
		new_tree.global_position = Vector2(spawn_x, spawn_y)
		# Check for collisions with existing objects
		var collision = new_tree.move_and_collide(Vector2.ZERO)
		if collision == null:
			add_child(new_tree)
			trees_count+=1
			break
		else:
			new_tree.queue_free()
			attempts += 1
	if attempts == max_attempts:
		print("Failed to find a suitable spawn position")

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_weapon():
	var weapons_array = [preload("res://gun.tscn"), preload("res://laser_gun.tscn")]
	var selected_weapon_index = randi() % (weapons_array.size())
	# TODO: Add slot adaptility, for future multipule weapon holdings
	# For now, we assume the player always can equip the picked up weapon (slot wise)
	var player_pos = player.global_position
	var viewport_size = get_viewport().size
	var attempts = 0
	var max_attempts = 3  # Adjust as needed

	while attempts < max_attempts:
		var spawn_x = player_pos.x + randf_range(-viewport_size.x * 1.5, viewport_size.x * 1.5)
		var spawn_y = player_pos.y + randf_range(-viewport_size.y * 1.5, viewport_size.y * 1.5)
		# Ensure the spawn position is outside the player's immediate vicinity
		var distance_to_player = player_pos.distance_to(Vector2(spawn_x, spawn_y))
		if (spawn_x > player_pos.x - viewport_size.x ) and (spawn_x < player_pos.x + viewport_size.x ) and \
		(spawn_y > player_pos.y - viewport_size.y ) and (spawn_y < player_pos.y + viewport_size.y ):
			continue
		var new_weapon = weapons_array[selected_weapon_index].instantiate()
		new_weapon.global_position = Vector2(spawn_x, spawn_y)
		
		# Check for collisions with existing objects
		var overlapping_bodies = new_weapon.get_overlapping_bodies()

		# Check if any overlapping body is of type Area2D
		var collision_detected = false
		for body in overlapping_bodies:
			if body != null:
				collision_detected = true
				break  # Exit the loop after finding an Area2D collision
		if not collision_detected:
			#new_weapon.process_mode = PROCESS_MODE_DISABLED
			add_child(new_weapon)
			break
		else:
			new_weapon.queue_free()
			attempts += 1
	if attempts == max_attempts:
		print("Failed to find a suitable spawn position")


func _on_mob_spawner_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func add_score(score_to_add) -> void:
	score += score_to_add


func _on_resume_button_pressed() -> void:
	%PausePanel.hide()
	get_tree().paused = false
