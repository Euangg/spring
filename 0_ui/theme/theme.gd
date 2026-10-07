extends Control

var t:float=0
func _ready() -> void:
	SoundEngine.play_bgm(load("uid://c8sidnk8rdyl0"))
	%People.set_control_p1()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):get_tree().quit()

func _physics_process(delta: float) -> void:
	t+=delta
	%Sprite3D.offset.y=15*sin(2*PI*t)

func _on_area_play_area_entered(area: Area3D) -> void:
	SceneEngine.switch(load(Global.UI_PALY))

func _on_area_toturial_area_entered(area: Area3D) -> void:
	SceneEngine.switch(load(Global.UI_TOTURIAL))
	
