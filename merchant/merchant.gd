extends Sprite2D

func _ready():
	var animation_player = (%AnimationPlayer as AnimationPlayer)
	animation_player.current_animation = "idle"
	animation_player.active = true
