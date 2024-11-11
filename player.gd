extends CharacterBody2D

signal health_depleted
var health = 100.0
const PLAYER_SPEED = 600.0
var current_weapon = null
var weapon_slots = 3 # Changeable number of slots for weapons the player can hold altogether
enum GunType {
	LASER_GUN,
	PISTOL,
	NO_GUN
}

func _ready() -> void:
	#TODO: dynamically get the current_weapon node for the first time
	current_weapon = get_node("LaserGun")
	if not current_weapon:
		current_weapon = get_node("Pistol")


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
	return current_weapon

func pickup_and_change_weapon(weapon) -> void:
	if weapon.has_method("is_weapon") and weapon.is_weapon() and weapon != current_weapon:
		var childs = get_children()
		remove_child(current_weapon)
		# Removing the weapon from its main_game parent so it can be added as a child to the player's node
		weapon.get_parent().remove_child(weapon) 
		add_child(weapon)
		childs = get_children()
		weapon.owner = self
		childs = get_children()
		#weapon_slots.call_deferred("add_child", weapon) #TODO: add weapon slots parent for multiple weapons
		#weapon.set_deferred("owner", weapon_slots)
		weapon.on_floor = false
		if current_weapon:
			current_weapon.queue_free()
		current_weapon = weapon

#func _on_hurt_box_area_entered(area: Area2D) -> void:
	#var current_gun = get_current_gun_node()
	#if area.has_method("is_weapon") and area.is_weapon() and area != current_gun:
		#area.process_mode = Node.PROCESS_MODE_INHERIT
		#remove_child(current_gun)
		#add_child(area) # Equip the weapon
