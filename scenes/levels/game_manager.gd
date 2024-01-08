extends Node2D

class_name GameManager

var arrow_scene: PackedScene = preload("res://scenes/projectiles/arrow.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemies/goblin.tscn")

signal toggle_game_paused(is_paused: bool)
var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event: InputEvent):
	if (event.is_action_pressed("pause")):
		game_paused	= !game_paused

#func _ready():
	#$Timer.start()
#
#
#func _on_timer_timeout():
	#var enemy = enemy_scene.instantiate()
	#if enemy.get_child_count(0):
		#add_child(enemy)
