extends CharacterBody2D

var speed = 70
var health = 100
var archer_in_area = false
var archer = null
var dead = false
var gold = preload("res://scenes/collectibles/gold_collectible.tscn")

@export var item = InventItems

func _physics_process(_delta):
	if !dead:
		$detection/CollisionShape2D.disabled = false
		if archer_in_area:
			var direction = (archer.position - position).normalized()
			position += (archer.position - position) / speed 
			if direction.x > 0:
				$Sprite2D.flip_h = false
				$Sprite2D.play("walking")
			elif direction.x < 0:
				$Sprite2D.flip_h = true
				$Sprite2D.play("walking")
		else:
			$Sprite2D.play("idle")
	if dead:
		await get_tree().create_timer(0.1).timeout
		$detection/CollisionShape2D.disabled = true
		$"."/CollisionShape2D.disabled = true

func _on_detection_body_entered(body):
	if body.is_in_group("archer"):
		archer_in_area = true

func _on_gold_collect_area_body_entered(body):
	archer = body

func _on_detection_body_exited(body):
	if body.is_in_group("archer"):
		archer_in_area = false


func _on_hitbox_area_entered(area):
	var damage
	if area.is_in_group("arrow"):
		damage = 50
		take_damage(damage)
	elif area.is_in_group("axe"):
		damage = 35
		take_damage(damage)

func take_damage(damage):
	health = health - damage
	if health <= 0 and !dead:
		death()
	
func death():
	dead = true
	$Sprite2D.play("death")
	gold_drop()
	await get_tree().create_timer(10).timeout
	$Sprite2D.play("skull_dissapear")
	await get_tree().create_timer(3).timeout
	queue_free()
	
func gold_drop():
	await get_tree().create_timer(0).timeout
	var gold_instance = gold.instantiate()
	gold_instance.global_position = $Marker2D.global_position
	get_parent().add_child(gold_instance)
	archer.collect(item)
	await get_tree().create_timer(3).timeout






