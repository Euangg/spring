extends Control


func _ready() -> void:
	%People.set_control_p1()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):SceneEngine.switch(load(Global.UI_THEME))


func _on_area_3d_area_entered(area: Area3D) -> void:
	SceneEngine.switch(load(Global.UI_PALY))
