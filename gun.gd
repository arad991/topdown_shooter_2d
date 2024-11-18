extends Node2D

var is_jammed = false
@export var on_floor: bool = false
@onready var player_detector: Area2D = $PlayerDetector
@onready var spawn_detector: Area2D = $WeaponPivot/Pistol/SpawnDetector
signal ready_for_animation

func _ready() -> void:
	if not on_floor:
		player_detector.set_collision_mask_value(8,false) # player mask
	else:
		ready_for_animation.emit()
		

func _physics_process(delta: float) -> void:
	if not on_floor:
		_pistol_shoot_logic() # makes the pistol aim to the nearest enemy
		

func _pistol_shoot_logic() -> void:
	var enemies_in_range = spawn_detector.get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var closest_enemy_distance = INF
		var closest_enemy = null
		
		for enemy in enemies_in_range:
			if enemy.has_method("is_tree"):
				continue
			var distance_to_enemy = enemy.global_position.distance_to(global_position)
			if distance_to_enemy < closest_enemy_distance:
				closest_enemy_distance = distance_to_enemy
				closest_enemy = enemy
				
		if closest_enemy:
			look_at(closest_enemy.global_position)

func shoot() -> void:
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	%ShootingPoint.add_child(new_bullet)
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	

func disable_bullets() -> void:
	pass

func is_weapon() -> bool:
	return true


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(8,false) # player mask
		if body.has_method("pickup_and_change_weapon"):
			body.pickup_and_change_weapon(self)
			%FloatingAnimation.stop()
			position = Vector2.ZERO


func _on_shoot_timer_timeout() -> void:
	if not on_floor: #TODO : Add jammed/overheat pistol system
		shoot()


func _on_ready_for_animation() -> void:
	%FloatingAnimation.play("float")
