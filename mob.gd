extends CharacterBody2D

var health = 3

@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var score_label: Label = %Score
@onready var game: Node2D = $"."

func _ready() -> void:
	%Slime.play_walk()
	var player = get_node("Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()


func take_damage(damage):
	health -= damage
	%Slime.play_hurt()
	
	
	if health <= 0:
		player.score += 1
		queue_free()
		
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
