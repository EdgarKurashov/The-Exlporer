extends CharacterBody2D

var speed = 300
var archer_state
var bow_equiped = true
var arrow_cooldown = true
var arrow = preload("res://scenes/projectiles/arrow.tscn")
var mouse_location_from_player = null
var axe_equiped = false
var axe_cooldown = true
var collision_shape: CollisionShape2D 

@onready var InventUI = $InventUI
@export var invent:Invent


#updates characters physics
func _physics_process(_delta):
	if Input.is_action_just_pressed("remove_item") and InventUI.is_open:
		remove_first_item()
	
	mouse_location_from_player = get_global_mouse_position() - self.position
	#how far mouse is from player
	var direction = Input.get_vector("left", "right", "up", "down" )
	if direction.x == 0 and direction.y == 0:
		archer_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		archer_state = "walking"
	#archer state
	velocity = direction * speed
	move_and_slide()
	#changes weapons
	if Input.is_action_just_pressed("equip bow"):
		bow_equiped = !bow_equiped
		if bow_equiped:
			axe_equiped = false
		
	if Input.is_action_just_pressed("equip axe"):
		axe_equiped = !axe_equiped
		if axe_equiped:
			bow_equiped = false 
	#marker orientation to cursor
	var mouse_position = get_global_mouse_position()
	$Marker2D.look_at(mouse_position)

	if Input.is_action_just_pressed("primary action") and axe_equiped and axe_cooldown and archer_state == "idle":
		if Input.is_action_pressed("primary action"):
			$AxeHitbox/CollisionShape2D.disabled = false
		axe_cooldown = false
		await get_tree().create_timer(0.5).timeout
		axe_cooldown = true
	else:
		$AxeHitbox/CollisionShape2D.disabled = true
	
	if Input.is_action_just_pressed("primary action") and bow_equiped and arrow_cooldown and archer_state == "idle":
		arrow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(1).timeout
		arrow_cooldown = true
	#animation play
	play_animation(direction)
	#method for animation control
func play_animation(dir):
	if bow_equiped and !axe_equiped:
	#print(dir) to check how to make walking animation
		if archer_state == "idle":
			$ArcherImage.play("bow_idle")
			if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y < 0:
				$ArcherImage.play("shooting_up")
			if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x > 0:
				$ArcherImage.flip_h = false
				$ArcherImage.play("shooting_right")
			if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y > 0:
				$ArcherImage.play("shooting_down")
			if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x < 0:
				$ArcherImage.flip_h = true
				$ArcherImage.play("shooting_right")
			if mouse_location_from_player.x >= 25 and mouse_location_from_player.y <= -25:
				$ArcherImage.flip_h = false
				$ArcherImage.play("shooting_up_right")
			if mouse_location_from_player.x >= 25 and mouse_location_from_player.y >= 25:
				$ArcherImage.flip_h = false
				$ArcherImage.play("shooting_down_right")
			if mouse_location_from_player.x <= -25 and mouse_location_from_player.y >= 25:
				$ArcherImage.flip_h = true
				$ArcherImage.play("shooting_down_right")
			if mouse_location_from_player.x <= -25 and mouse_location_from_player.y <= -25:
				$ArcherImage.flip_h = true
				$ArcherImage.play("shooting_up_right")
		elif archer_state == "walking":
			if dir.y == -1:
				$ArcherImage.play("bow_walking")
			elif dir.y == 1:
				$ArcherImage.play("bow_walking")
			elif dir.x == -1:
				$ArcherImage.flip_h = true
				$ArcherImage.play("bow_walking")
			elif dir.x == 1:
				$ArcherImage.flip_h = false
				$ArcherImage.play("bow_walking")
			elif dir.x > 0.5 and dir.y < -0.5 or dir.x > 0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = false
				$ArcherImage.play("bow_walking")
			elif dir.x < -0.5 and dir.y < -0.5 or dir.x < -0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = true
				$ArcherImage.play("bow_walking")
	elif !bow_equiped and !axe_equiped:
		if archer_state == "idle":
			$ArcherImage.play("no_bow_idle")
		elif archer_state == "walking":
			if dir.y == -1 or dir.y == 1:
				$ArcherImage.play("no_bow_walking")
			elif dir.x == -1:
				$ArcherImage.flip_h = true
				$ArcherImage.play("no_bow_walking")
			elif dir.x == 1:
				$ArcherImage.flip_h = false
				$ArcherImage.play("no_bow_walking")
			elif dir.x > 0.5 and dir.y < -0.5 or dir.x > 0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = false
				$ArcherImage.play("no_bow_walking")
			elif dir.x < -0.5 and dir.y < -0.5 or dir.x < -0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = true
				$ArcherImage.play("no_bow_walking")
	elif axe_equiped and !bow_equiped:	
		if Input.is_action_pressed("primary action") and axe_equiped and axe_cooldown and archer_state == "idle":
			$ArcherImage.play("axe_attack")
		elif archer_state == "idle":
			$ArcherImage.play("axe_idle")
		elif archer_state == "walking":
			if dir.y == -1 or dir.y == 1:
				$ArcherImage.play("axe_walking")
			elif dir.x == -1:
				$ArcherImage.flip_h = true
				$ArcherImage.play("axe_walking")
			elif dir.x == 1:
				$ArcherImage.flip_h = false
				$ArcherImage.play("axe_walking")
			if dir.x == 1 and Input.is_action_just_pressed("primary action"):
				$ArcherImage.flip_h = false
				$ArcherImage.play("axe_attack")
			elif dir.x > 0.5 and dir.y < -0.5 or dir.x > 0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = false
				$ArcherImage.play("axe_walking")
			elif dir.x < -0.5 and dir.y < -0.5 or dir.x < -0.5 and dir.y > 0.5:
				$ArcherImage.flip_h = true
				$ArcherImage.play("axe_walking")
				
func collect(item): #player has access to inventory, so item gets passed to inventory script
	invent.insert(item)
	

func remove_first_item():
	if invent and invent.slots.size() > 0:
		var current_slot = invent.slots[0]
		#checks if slot holds an item
		if current_slot.item:
			current_slot.amount -= 1
			invent.update.emit()
			if current_slot.amount == 0:
				current_slot.item = null
				current_slot.amount = 0
				#checks if there is item in second slot  
				if invent.slots.size() > 1:
					var next_slot = invent.slots[1]
					while next_slot.item and current_slot.amount <= 0:
						current_slot.item = next_slot.item
						current_slot.amount = next_slot.amount
						next_slot.item = null
						next_slot.amount = 0
						current_slot = next_slot
						if invent.slots.size() > 2:
							next_slot = invent.slots[2]
						else:
							next_slot = null
				invent.update.emit()



