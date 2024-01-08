extends Node


var game_cursor = load("res://UI/Pointers/01.png")

func _ready():
	Input.set_custom_mouse_cursor(game_cursor, Input.CURSOR_ARROW, Vector2(0,0))
