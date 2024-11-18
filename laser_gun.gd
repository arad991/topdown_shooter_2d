extends Node2D

@export var on_floor: bool = false
@onready var player_detector: Area2D = $PlayerDetector
signal ready_for_animation

func _ready() -> void:
	if not on_floor:
		player_detector.set_collision_mask_value(8,false) # player mask
		var mouse_pos = get_global_mouse_position()
		# Aim the gun at the mouse position
		look_at(mouse_pos)
	else:
		ready_for_animation.emit()

func _physics_process(delta: float) -> void:
	if not on_floor:
		var mouse_pos = get_global_mouse_position()
		# Aim the gun at the mouse position
		look_at(mouse_pos)

func shoot():
	const BULLET = preload("res://scenes/laser_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	%LaserShootingPoint.add_child(new_bullet)
	new_bullet.global_position = %LaserShootingPoint.global_position
	new_bullet.global_rotation = %LaserShootingPoint.global_rotation
	
	
func _on_timer_timeout() -> void:
	if not on_floor:
		shoot()


func is_weapon() -> bool:
	return true


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(8,false) # player mask
		if body.has_method("pickup_and_change_weapon"):
			body.pickup_and_change_weapon(self)
			%FloatingAnimation.stop()
			position = Vector2.ZERO


func _on_ready_for_animation() -> void:
	%FloatingAnimation.play("float")
