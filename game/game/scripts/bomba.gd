extends Node2D

var end = false
var boom = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#$GPUParticles2D.emitting = true
	Global.bomba = true	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $bomba/CollisionShape2D.disabled == false && boom == false:
		boom = true
		$AudioStreamPlayer.play()
		$GPUParticles2D.emitting = true
		#$tnt/CollisionShape2D.disabled = false
		#await get_tree().create_timer(0.05).timeout
		_boom()
	if $GPUParticles2D.emitting == false && $AudioStreamPlayer.playing == false && end == true:
		await get_tree().create_timer(0.1).timeout
		Global.bomba = false
		queue_free()

func _boom():
	await get_tree().create_timer(0.05).timeout
	$Bomba.visible = false
	$bomba/CollisionShape2D.disabled = true
	end = true


func _on_tnt_area_entered(area):
	if area.name == "press":
		if Global.shild == true:
			return
		elif Global.player_xp == 1:
			return
		Global.player_xp -= 1
