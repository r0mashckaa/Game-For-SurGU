extends Node2D

var veloc = global_position
var lable: bool = true
var lable_move: bool = true
@onready var tile_map = $"../TileMap"
@onready var player# = $"../game/player"

func _ready():
	if Global.place == "game":
		player = $"../game/player"
	elif Global.place == "tutorial":
		player = $"../tutorial/player"

func _label():
	if lable_move == false:
		return
	if lable == true:
		lable_move = false
		$Label.position.y += 1
		lable = false
		await get_tree().create_timer(1).timeout
		lable_move = true
		return
	if lable == false:
		lable_move = false
		$Label.position.y -= 1
		lable = true
		await get_tree().create_timer(1).timeout
		lable_move = true
		return

func _physics_process(_delta):
	if Global.label == false:
		$Label.visible = false
	else:
		$Label.visible = true
	if Global.reset == true || Global.player_die == true:
		return
	_label()
	#var label_tile_data: TileData = tile_map.get_cell_tile_data(0, veloc)
	var mouse_x = get_global_mouse_position().x - player.global_position.x
	var mouse_y = get_global_mouse_position().y - player.global_position.y
	if tile_map.local_to_map(get_global_mouse_position()) == tile_map.local_to_map(player.global_position):
		global_position = player.global_position
		veloc = Vector2.ZERO
	elif abs(mouse_x) > abs(mouse_y):
		#print(1)
		if mouse_x > 0:
			global_position = Vector2(player.global_position.x + 16, player.global_position.y)
			veloc = Vector2.RIGHT
		elif mouse_x < 0:
			global_position = Vector2(player.global_position.x - 16, player.global_position.y)
			veloc = Vector2.LEFT
	elif abs(mouse_x) < abs(mouse_y):
		#print(0)
		if mouse_y > 0:
			global_position = Vector2(player.global_position.x, player.global_position.y + 16)
			veloc = Vector2.DOWN
		elif mouse_y < 0:
			global_position = Vector2(player.global_position.x, player.global_position.y - 16)
			veloc = Vector2.UP
		#label_tile_data.get_custom_data("walk") == true
