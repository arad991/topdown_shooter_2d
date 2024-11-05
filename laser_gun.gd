extends Area2D


func _physics_process(delta: float) -> void:
	#var enemies_in_range = get_overlapping_bodies()
	#if enemies_in_range.size() > 0:
		#var target_enemy = enemies_in_range[0]
		#look_at(target_enemy.global_position)
		# Get the mouse position in world coordinates
	var mouse_pos = get_global_mouse_position()

	# Aim the gun at the mouse position
	look_at(mouse_pos)
	#var enemies_in_range = get_overlapping_bodies()
	#if enemies_in_range.size() > 0:
		#var closest_enemy_distance = INF
		#var closest_enemy = null
		#
		#for enemy in enemies_in_range:
			#var distance_to_enemy = enemy.global_position.distance_to(global_position)
			#if distance_to_enemy < closest_enemy_distance:
				#closest_enemy_distance = distance_to_enemy
				#closest_enemy = enemy
				#
		#if closest_enemy:
			#look_at(closest_enemy.global_position)



func shoot():
	const BULLET = preload("res://laser_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	%LaserShootingPoint.add_child(new_bullet)
	new_bullet.global_position = %LaserShootingPoint.global_position
	new_bullet.global_rotation = %LaserShootingPoint.global_rotation
	
func _on_timer_timeout() -> void:
	shoot()

func is_weapon() -> bool:
	return true
