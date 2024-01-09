extends StaticBody2D

var health = 50
var chopped = false
var wood = preload("res://scenes/collectibles/wood_collectible.tscn")

@export var item: InventItems
var archer = null

func _physics_process(_delta):
	if !chopped:
		$tree.play("tree_idle")
func _on_area_2d_area_entered(area):
	var damage
	if area.is_in_group("axe"):
		damage = 35
		take_damage(damage)
		
func take_damage(damage):
	health = health - damage
	if health <= 0 and !chopped:
		chopped_tree()

func _on_area_2d_body_entered(body):
	if body.is_in_group("archer"):
		archer = body

func chopped_tree():
	chopped = true
	$tree.play("tree_destroyed")
	if $tree.frame == 4:
		$tree.stop()
		$tree.frame = 4
	if chopped == true:
		wood_drop()


func _on_growth_timer_timeout():
	if chopped == true:
		chopped = false
		health = 50

func wood_drop():
	await get_tree().create_timer(0).timeout
	var wood_instance = wood.instantiate()
	wood_instance.global_position = $Marker2D.global_position
	get_parent().add_child(wood_instance)
	archer.collect(item)
	await get_tree().create_timer(3).timeout
	$growth_timer.start()
	



