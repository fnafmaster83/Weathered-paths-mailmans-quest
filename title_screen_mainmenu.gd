extends Node2D


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	



func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://world_2.tscn")




func _on_texture_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://world_3.tscn")
