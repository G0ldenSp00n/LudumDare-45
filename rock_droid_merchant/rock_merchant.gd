extends Sprite2D

@export var REFUEL_RATE = 20;

signal refuel(amount);

func _ready():
	var animation_player = (%AnimationPlayer as AnimationPlayer);
	animation_player.current_animation = "idle";
	animation_player.active = true;

func _process(delta):
	var players = (%RefuelArea as Area2D).get_overlapping_bodies();
	if players.size() > 0:
		for player in players:
			refuel.emit(REFUEL_RATE * delta);
