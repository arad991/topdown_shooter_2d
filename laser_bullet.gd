extends Area2D

var travelled_distance = 0
const BULLET_DAMAGE = 10.0

func _physics_process(delta: float) -> void:
	const SPEED = 3000
	const RANGE = 2400
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(BULLET_DAMAGE)
