extends Area2D

var travelled_distance = 0
const BULLET_DAMAGE = 1.0
var num_bodies_hit = 0

func _physics_process(delta: float) -> void:
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	num_bodies_hit+=1 #to prevent a bullet to hit multiple enemies at once
	queue_free()
	if num_bodies_hit <= 1 and body.has_method("take_damage"):
		body.take_damage(BULLET_DAMAGE)
