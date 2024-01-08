extends StaticBody2D


var rock = preload("res://scenes/collectibles/rock_collectible.tscn")
var archer = null
var mine
@export var item: InventItems

func _on_area_2d_body_entered(body):
	if body.is_in_group("archer"):
		archer = body
	if Input.is_action_pressed("mine"):
		rock_drop()

func rock_drop():
	await get_tree().create_timer(0).timeout
	var rock_instance = rock.instantiate()
	rock_instance.global_position = $Marker2D.global_position
	get_parent().add_child(rock_instance)
	archer.collect(item)
	await get_tree().create_timer(3).timeout



