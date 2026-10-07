@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_autoload_singleton("SoundEngine","res://addons/sound_engine/sound_engine.tscn")
	ProjectSettings.set_setting("audio/buses/default_bus_layout","res://addons/sound_engine/sound_engine_bus_layout.tres")

func _disable_plugin() -> void:
	remove_autoload_singleton("SoundEngine")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
