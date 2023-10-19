extends Node

@export var mob_scene: PackedScene
@export var coin_scene: PackedScene

var timeScore = 0
var coinScore = 0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_hit():
	$ScoreTimer.stop()
	$CoinTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func picked_up_coin(value):
	coinScore += value
	$HUD.update_coin_score(coinScore)

func new_game():
	timeScore = 0
	$HUD.update_time_score(timeScore)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	$CoinTimer.start()

func _on_score_timer_timeout():
	timeScore += 1
	$HUD.update_time_score(timeScore)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("Path2D/PathFollow2D")
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_hud_start_game():
	new_game()

func _on_coin_timer_timeout():
	var rndX = randf_range(0, screen_size.x)
	var rndY = randf_range(0, screen_size.y)
	var coin = coin_scene.instantiate()
	coin.position = Vector2(rndX, rndY)
	coin.picked_up_coin.connect(picked_up_coin)
	add_child(coin)
