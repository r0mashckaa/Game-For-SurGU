extends Node2D

var xp_die = 0
var vid
var nomber
@export var thorns: PackedScene
@export var mob: PackedScene
var stan = true
var move
@onready var cooldown = randi_range(2,  3)

func _ready():
	$decors/Column.visible = false
	var rand = randi_range(0, 100)
	if rand <= 20:
	#	Global.enviroment[i] = 2 #"vase"
		vid  = "statue"
		#$decors/enviroment/CollisionShape2D.disabled = true
		$decors/block/CollisionShape2D.disabled = false
	elif  rand <= 40:
	#	Global.enviroment[i] = 1 #"column"
		vid = "vase"
	elif rand <= 55:
		vid = "plant"
	elif rand <= 65:
		vid = "slime"
	elif rand <= 85:
		vid = "tomb"
	elif rand > 85:
		vid = "spikes"
	if vid != "spikes":
		$spikes.queue_free()
	if vid == "vase":
		$decors/Vase.visible = true
		#$Column.visible = false
	elif  vid == "statue":
		$decors/Statue.visible = true
		$decors/block/CollisionShape2D.disabled = false
		$decors/enviroment/CollisionShape2D.disabled = true
		#$Vase.visible = false
	elif vid == "plant":
		$decors/Plant.visible = true
	elif vid == "spikes":
		#var temp_thorns = thorns.instantiate()
		#get_tree().root.
		#add_child(temp_thorns)
		#temp_thorns.global_position = global_position#Global.marker_pos
		$decors.queue_free()
		$spikes/spike.visible = true
	elif vid == "slime":
		$decors/slime.visible = true
	elif vid == "tomb":
		$decors/tombstone.visible = true

func _process(_delta):
	if Global.reset_player == true:
		stan = true
		return
	if Global.xod_player == true:
		move = false
		return
	if move == true:
		return
	if vid == "spikes":
		_spikes()

func _physics_process(_delta):
#	if xp_die == 1 && vid == "vase":
#		queue_free()
#	if xp_die == 1 && vid == "plant":
#		$decors/Plant.play("pot")
#	if xp_die == 2 && vid == "plant":
#		queue_free()
	pass

func _change_and_die():
	if xp_die == 1 && vid == "vase":
		$AnimationPlayer.play("vase")
		$piece.modulate = "f17b3f"
		$piece.emitting = true
		await get_tree().create_timer(0.4).timeout
		queue_free()
	if xp_die == 1 && vid == "plant":
		$AnimationPlayer.play("shake")
		$cut.play()
		$leaf.modulate = "9e49ee"
		$leaf.emitting = true
		$decors/Plant.play("pot")
	if xp_die == 2 && vid == "plant":
		$AnimationPlayer.play("pot")
		$piece.modulate = "463520"
		$piece.emitting = true
		await get_tree().create_timer(0.9).timeout
		queue_free()
	if xp_die == 1 && vid == "slime":
		Global.player_xp += 1
		#await get_tree().create_timer(0.2).timeout
		#$decors/slime.visible = false
		$piece.modulate = "ca22c1"
		$piece.emitting = true
		$slime_vase.play()
		$decors/slime.visible = false
		await get_tree().create_timer(0.1).timeout
		var temp_mob = mob.instantiate()
		$"../..".add_child(temp_mob)
		temp_mob.visible = false
		temp_mob.mob = "slime"
		temp_mob.spawner = true
		temp_mob.stan = true
		temp_mob.global_position = global_position
		await get_tree().create_timer(0.2).timeout
		temp_mob.visible = true
		queue_free()
	if xp_die == 1 && vid == "tomb":
		$tomb.play()
		$piece.modulate = "847e87"
		$piece.emitting = true
		await get_tree().create_timer(0.15).timeout
		$decors/block/CollisionShape2D.disabled = false
		$decors/enviroment/CollisionShape2D.disabled = true
		#$decors/blok/CollisionShape2D.set_deferred("disabled", false)
		$decors/tombstone.play("old")

func _spikes():
	if stan == true:
		cooldown -= 1
		#await get_tree().create_timer(1).timeout
		move = true
		if cooldown == 1:
			$spikes/spike.play("ready")
		if cooldown > 0:
			return
		#$spikes2.play()
		$spikes/spike.play("on")
		$spikes/spikes/CollisionShape2D.disabled = false
		stan = false
		return
	$spikes/spike.play("off")
	$spikes/spikes/CollisionShape2D.disabled = true
	stan = true
	cooldown = 3

func _on_enviroment_area_entered(area):
	if area.name == "player":
		xp_die += 1
		_change_and_die()
	if area.name == "bomba":
		await get_tree().create_timer(0.1).timeout
		xp_die += 1
		_change_and_die()
		#print(xp_die)


func _on_blok_area_entered(area):
	if area.name == "player" && (vid == "statue" || vid == "tomb"):
		#$GPUParticles2D.modulate = "4c4651"
		#$GPUParticles2D.emitting = true
		$block.play()
		#print(1)
