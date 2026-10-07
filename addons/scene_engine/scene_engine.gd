extends Node

func switch(packed_scene:PackedScene):
	get_tree().call_deferred("change_scene_to_packed",packed_scene)
