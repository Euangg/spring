extends Control

const BOX = preload("uid://rmgky52d5my7")
const WORD = preload("uid://due6j0es4d4s3")


var player_controller=2

func _ready() -> void:
	%SubViewport.size.y=1080
	SoundEngine.play_sfx(preload("uid://bh3ciy8f4e0e"))
	%SubViewport2.world_3d=%SubViewport.world_3d
	%SubViewport2.world_2d=%SubViewport.world_2d
	%People.set_control_p1()
	%People.enemy=%People2
	%People2.set_control_p2()
	%People2.set_skin(People.SKIN.ORANGE)
	%People2.enemy=%People
	
	var control_player:People=%People if player_controller==1 else %People2
	add_joypad_button(control_player.action_left,JOY_BUTTON_DPAD_LEFT)
	add_joypad_axis(control_player.action_left,JOY_AXIS_LEFT_X,-0.1)
	add_joypad_button(control_player.action_up,JOY_BUTTON_DPAD_UP)
	add_joypad_axis(control_player.action_up,JOY_AXIS_LEFT_Y,-0.1)
	add_joypad_button(control_player.action_right,JOY_BUTTON_DPAD_RIGHT)
	add_joypad_axis(control_player.action_right,JOY_AXIS_LEFT_X,0.1)
	add_joypad_button(control_player.action_down,JOY_BUTTON_DPAD_DOWN)
	add_joypad_axis(control_player.action_down,JOY_AXIS_LEFT_Y,0.1)
	add_joypad_button(control_player.action_punch,JOY_BUTTON_A)
	add_joypad_button(control_player.action_kick,JOY_BUTTON_B)
	add_joypad_button(control_player.action_jump,JOY_BUTTON_X)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):get_tree().reload_current_scene()
	if event.is_action_pressed("esc"):SceneEngine.switch(load(Global.UI_THEME))
	if event.is_action_pressed("f1"):
		if %SubViewport.size.y==1080:%SubViewport.size.y=540
		else:%SubViewport.size.y=1080

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		var b:Word=WORD.instantiate()
		b.position.x=0
		b.position.z=0
		b.position.y=80
		b.word=Word.arr_word.pick_random()
		%World.add_child(b)


func add_joypad_button(action_name:StringName,joy_button:JoyButton):
	var event=InputEventJoypadButton.new()
	event.button_index=joy_button
	event.pressed=true
	InputMap.action_add_event(action_name,event)
func add_joypad_axis(action_name:StringName,joy_axis:JoyAxis,amount:float):
	var event=InputEventJoypadMotion.new()
	event.axis=joy_axis
	event.axis_value=amount
	InputMap.action_add_event(action_name,event)


func tip_end():
	%Label.show()
