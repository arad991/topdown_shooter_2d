extends CharacterBody2D

signal health_depleted
var health = 100.0
const PLAYER_SPEED = 600.0
var weapon_slots = 3 # Changeable number of slots for weapons the player can hold altogether
enum GunType {
	LASER_GUN,
	PISTOL,
	NO_GUN
}
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

func get_current_gun_node() -> Area2D:
	if get_node("LaserGun") != null:
		return get_node("LaserGun")
	elif get_node("Gun") != null:
		return get_node("Gun")
	else: #No gun is equipped (impossible for now)
		return null

func pickup_and_change_weapon(weapon) -> void:
	remove_child(get_current_gun_node())
	add_child(weapon)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	var current_gun = get_current_gun_node()
	if area.has_method("is_weapon") and area.is_weapon() and area != current_gun:
		area.process_mode = Node.PROCESS_MODE_INHERIT
		remove_child(current_gun)
		add_child(area) # Equip the weapon
