extends Area2D

signal picked_up_coin(value)

@export var rate = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('idle')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.name == 'Player':
		hide()
		picked_up_coin.emit(rate)
