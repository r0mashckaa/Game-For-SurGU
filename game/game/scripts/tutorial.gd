extends Node2D

@onready var anim_but_knight = $buttons/button_knight/button_knight
@onready var anim_but_golem = $buttons/button_golem/button_golem
@onready var anim_but_ghost = $buttons/button_ghost/button_ghost
@onready var enemies = get_tree().get_nodes_in_group("enemies")
@onready var anim_but_necromant = $buttons/button_necromant/button_necromant
@onready var anim_but_barrel = $buttons/button_barrel/button_barrel
@onready var anim_but_vampire = $buttons/button_vampire/button_vampire

func _ready():
	$Node2D/AnimationPlayer.play("open")
	Global.place = "tutorial"

func _on_button_knight_area_entered(area):
	if area.name == "press":
		#print(1)
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_knight.play("on")
		for enemie in enemies:
			if enemie.mob == "knight" && enemie.die == true:
				enemie.die = false
				enemie.xp = 1
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_knight/knight_spawn.global_position

func _on_button_knight_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_knight.play("off")

func _on_button_golem_area_entered(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_golem.play("on")
		for enemie in enemies:
			if enemie.mob == "golem" && enemie.die == true:
				enemie.die = false
				enemie.xp = 3
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_golem/golem_spawn.global_position

func _on_button_golem_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_golem.play("off")

func _on_button_ghost_area_entered(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_ghost.play("on")
		for enemie in enemies:
			if enemie.mob == "ghost" && enemie.die == true:
				enemie.die = false
				enemie.xp = 1
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_ghost/ghost_spawn.global_position

func _on_button_ghost_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_ghost.play("off")

func _on_button_necromant_area_entered(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_necromant.play("on")
		for enemie in enemies:
			if enemie.mob == "necromant" && enemie.die == true:
				enemie.die = false
				enemie.xp = 2
				enemie.cooldown = 4
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_necromant/necromant_spawn.global_position

func _on_button_necromant_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_necromant.play("off")

func _on_button_barrel_area_entered(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_barrel.play("on")
		for enemie in enemies:
			if enemie.mob == "barrel" && enemie.die == true:
				enemie.die = false
				enemie.xp = 1
				enemie.cooldown = 5
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_barrel/barrel_spawn.global_position

func _on_button_barrel_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_barrel.play("off")

func _on_button_vampire_area_entered(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1
		$AudioStreamPlayer.play()
		anim_but_vampire.play("on")
		for enemie in enemies:
			if enemie.mob == "vampire" && enemie.die == true:
				enemie.die = false
				enemie.xp = 1
				enemie.cooldown = 6
				enemie.stan = true
				Global.quantity_mob += 1
				enemie.global_position = $buttons/button_vampire/vampire_spawn.global_position

func _on_button_vampire_area_exited(area):
	if area.name == "press":
		$AudioStreamPlayer.pitch_scale = 1.1
		$AudioStreamPlayer.play()
		anim_but_vampire.play("off")
