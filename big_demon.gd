extends CharacterBody2D

var health = 5
var mob_speed = 450.0

const SCORE_ON_KILLED = 3
const NUM_OF_LITTLE_DEMONS = 2


@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var game_manager: Node2D = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * mob_speed
	move_and_slide()
	

func take_damage(damage):
	health -= damage
	%AnimationPlayer.play("hurt")
	
	if health <= 0:
		game_manager.add_score(SCORE_ON_KILLED)
		spawn_little_demons(NUM_OF_LITTLE_DEMONS)
		queue_free()
		
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		var mob_size = self.scale
		smoke.scale = mob_size  # Scale the smoke node using the mob size


func spawn_little_demons(num_of_demons_to_spawn) -> void:
	const SMALL_DEMON = preload("res://scenes/small_demon.tscn")
	for i in num_of_demons_to_spawn:
		var small_demon = SMALL_DEMON.instantiate()
		small_demon.set_invincible_value(true)
		small_demon.global_position = self.global_position + Vector2(randf_range(5, 10), randf_range(5, 10))
		
		game_manager.add_child(small_demon)
		
