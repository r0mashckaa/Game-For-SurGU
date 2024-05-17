extends Node2D

func _ready():
	$install.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_trap_area_entered(area):
	if area.name == "enemy" || area.name == "call_mob":
		$click.play()
		await get_tree().create_timer(0.5).timeout
		queue_free()
