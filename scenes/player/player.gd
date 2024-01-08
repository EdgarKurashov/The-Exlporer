extends CharacterBody2D

signal player_has_attacked()
signal player_has_built()
var can_attack: bool = true
var can_build: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#movement input
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * 300
	move_and_slide()
	
	#primary action input
	if Input.is_action_pressed("primary action") and can_attack:
		can_attack = false
		$AttackTimer.start()
		player_has_attacked.emit()
	#secondary action input
	if Input.is_action_pressed("secondary input") and can_build:
		can_build = false
		$BuildingTimer.start()
		player_has_built.emit()



func _on_building_timer_timeout():
		can_build = true


func _on_attack_timer_timeout():
		can_attack = true



