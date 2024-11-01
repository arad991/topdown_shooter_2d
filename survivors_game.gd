extends Node2D

var player
const max_distance_tree_from_player_to_remove = 900
var trees_count = 0
func _ready() -> void:
	# Unpause the scene after it's been paused on player's death
	if get_tree().paused == true:
		get_tree().paused = false
	player = get_node("Player")
	
	
func _process(delta: float) -> void:
	if randf_range(0, 10) < 5:
		spawn_tree()
	# Check and remove distant trees
	for child in get_children():
		if child.has_method("is_tree") and child.is_tree(): # Making sure the child node is a pine_tree node
			var distance = child.global_position.distance_to(player.global_position)
			if distance > max_distance_tree_from_player_to_remove:
				child.queue_free()
				trees_count -= 1
	#print("This game has " + str(trees_count) +" trees")
	
	
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


func _on_mob_spawner_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
