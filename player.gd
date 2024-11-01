extends CharacterBody2D

signal health_depleted

var health = 100.0
const PLAYER_SPEED = 600.0

func _process(delta: float) -> void:
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up",'move_down')
	velocity = direction * PLAYER_SPEED
	move_and_slide()

	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0: # if there are mobs colloding with the player
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
	if health <= 0.0:
		health_depleted.emit()
