extends CharacterBody2D

@export var tileMap: TileMap;

const MINING_LAYER = 2;

@export var SPEED = 180.0
@export var AIR_SPEED = 150.0
@export var MAX_FUEL = 200.0
var FUEL = 0.0
var FLY_VELOCITY = -150.0

@export var FuelLabel: Label;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var tileHealth = []

func _ready():
	var dimensions = tileMap.get_used_rect().size
	for y in dimensions.y:
		tileHealth.append([])
		for x in dimensions.x:
			var tileMapData = tileMap.get_cell_tile_data(MINING_LAYER, Vector2i(x, y))
			if tileMapData:
				tileHealth[y].append(tileMapData.get_custom_data_by_layer_id(0))

func refuel(amount):
	if FUEL < MAX_FUEL:
		FUEL += amount;

var MINING_SPEED = 80;
func mine_cell(action, offsetPos, delta):
	var tileMapPos = tileMap.local_to_map(global_position) + offsetPos
	
	tileHealth[tileMapPos.y][tileMapPos.x] -= MINING_SPEED * delta
	print(tileHealth[tileMapPos.y][tileMapPos.x])
	if tileHealth[tileMapPos.y][tileMapPos.x] <= 0:
		tileMap.erase_cell(MINING_LAYER, tileMapPos)

const FUEL_LABEL_TEXT = " Fuel - %d"
func _physics_process(delta):
	FuelLabel.text = FUEL_LABEL_TEXT % FUEL;
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("fly_up") and FUEL > 0.0:
		velocity.y += (FLY_VELOCITY * delta) * (gravity * delta)
		if velocity.y < FLY_VELOCITY:
			velocity.y = FLY_VELOCITY
		FUEL -= 1
	
	if is_on_floor():
		if Input.is_action_pressed("move_down"):
			mine_cell("move_down", Vector2i(0, 1), delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")

	if is_on_wall() and is_on_floor():
		if Input.is_action_pressed("move_left"):
			mine_cell("move_left", Vector2i(-1, 0), delta)
		if Input.is_action_pressed("move_right"):
			mine_cell("move_right", Vector2i(1, 0), delta)

	if direction and is_on_floor():
		velocity.x = direction * SPEED
	elif direction:
		velocity.x = direction * AIR_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
