extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://paradise_falls.tscn")


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://victory_screen_4.tscn")
