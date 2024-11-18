extends CharacterBody2D

var health = 3
const SCORE_ON_KILLED = 1
const MOB_SPEED = 550.0

@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var game_manager: Node2D = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * MOB_SPEED
	move_and_slide()
	

func take_damage(damage):
	health -= damage
	%AnimationPlayer.play("hurt")
	
	if health <= 0:
		game_manager.add_score(SCORE_ON_KILLED)
		queue_free()
		
		
		#TODO: change the smoke size to match to the mob's size
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		# Scale the smoke based on mob size
		var mob_size = Vector2(1,1) / %SmallDemonSprite.scale 
		smoke.scale = mob_size  # Scale the smoke node using the mob size
