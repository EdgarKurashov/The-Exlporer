extends StaticBody2D


func _ready():
	drop()
	
func drop():
	await get_tree().create_timer(1).timeout
	queue_free()
