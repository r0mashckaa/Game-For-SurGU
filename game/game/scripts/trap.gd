extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_trap_area_entered(area):
	if area.name == "enemy" || area.name == "call_mob":
		await get_tree().create_timer(0.1).timeout
		queue_free()
