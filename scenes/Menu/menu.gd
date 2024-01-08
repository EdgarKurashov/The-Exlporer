extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var start_game = preload("res://scenes/levels/level.tscn") as PackedScene

func _ready():
	start_button.pressed.connect(on_start_pressed)
	exit_button.pressed.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_game)

func on_exit_pressed() -> void:
	get_tree().quit()
