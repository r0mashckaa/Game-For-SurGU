extends Node2D

@onready var tile_map = $TileMap

func _ready():
	Global.tile_map = tile_map
	Xod.tile_map = tile_map
