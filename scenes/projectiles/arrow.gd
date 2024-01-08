extends Area2D

var arrow_sprite: Sprite2D
var collision_frames: Array = [0, 1]
var speed = 400
func _ready():
	arrow_sprite = $Sprite2D
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() #dissapear when leaves screen

func _on_body_entered(_body):
	arrow_sprite.frame = 1
	speed = 0
	await get_tree().create_timer(5).timeout
	queue_free()


func _on_body_exited(_body):
	queue_free()
