class_name People
extends Entity

const SKIN_ORANGE = preload("uid://bnqkl2m5cyjjf")
const SKIN_PURPLE = preload("uid://blgtglfftw7f3")
func set_skin(skin:Texture2D):
	%Sprite.texture=skin

enum State{NULL,IDLE,WALK,
	AIR,
	ATK_PUNCH,ATK_KICK,
	HURT,SLEEP
}
var current_state:State=State.NULL
var speed:float=50
var p_jump:float=80
var throw:float=50
var atk:float=5
var is_hurt:bool=false

func refresh_hp_bar():%HealthBar.front.value=hp/hp_max*100
var hp:float=100:
	set(v):
		hp=min(v,hp_max)
		refresh_hp_bar()
var hp_max:float=100:
	set(v):
		hp_max=v
		refresh_hp_bar()

@export var ap_tick:int=0

var enemy:Entity=null

var input:Vector2
var try_jump:bool
var try_punch:bool
var try_kick:bool

var action_up:StringName=&"null"
var action_left:StringName=&"null"
var action_down:StringName=&"null"
var action_right:StringName=&"null"
var action_jump:StringName=&"null"
var action_punch:StringName=&"null"
var action_kick:StringName=&"null"
func set_control_p1():
	action_up=&"w"
	action_left=&"a"
	action_down=&"s"
	action_right=&"d"
	action_jump=&"space"
	action_punch=&"j"
	action_kick=&"k"
func set_control_p2():
	action_left=&"left"
	action_right=&"right"
	action_up=&"up"
	action_down=&"down"
	action_jump=&"num_0"
	action_punch=&"num_1"
	action_kick=&"num_2"
func _ready() -> void:
	super._ready()
	refresh_hp_bar()

func _process(delta: float) -> void:pass


func _unhandled_input(event: InputEvent) -> void:
	input=Input.get_vector(action_left,action_right,action_up,action_down)
	try_jump=Input.is_action_just_pressed(action_jump)
	try_punch=Input.is_action_just_pressed(action_punch)
	try_kick=Input.is_action_just_pressed(action_kick)

func _physics_process(delta: float) -> void:
	var try_lift=(try_punch or try_kick)
	if on_head:
		if try_kick or try_punch:
			on_head.follow_under_foot()
			on_head.velocity.x=throw*direction
			on_head.velocity.y=velocity.y+throw
			on_head.be_throwed.emit(self)
			on_head.leave_from_under()
			try_kick=false
			try_punch=false
			SoundEngine.play_sfx(preload("uid://dxbg0nsy4grts"))
	else:
		if try_lift and state_can_lift():
			var area_pickable:Array[Area3D]=area_body.get_overlapping_areas()
			for a:Area3D in area_pickable:
				if a.get_collision_layer_value(6):
					var e:Entity=a.get_parent()
					if e==self:continue
					if e==under_foot:continue
					if e.under_foot:continue
					if e.can_be_pick:
						e.step_to(self)
						try_punch=false
						try_kick=false
						break
	
	#1/3.状态判断
	var next_state:State=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if is_stand():pass
			else:next_state=State.WALK
			if try_punch:next_state=State.ATK_PUNCH
			if try_kick:next_state=State.ATK_KICK
			if is_step_on():pass
			else:next_state=State.AIR
			if is_hurt:next_state=State.HURT
		State.AIR:
			if is_step_on():next_state=State.IDLE
			if is_hurt:next_state=State.HURT
		State.WALK:
			if is_stand():next_state=State.IDLE
			if try_punch:next_state=State.ATK_PUNCH
			if try_kick:next_state=State.ATK_KICK
			if is_step_on():pass
			else:next_state=State.AIR
			if is_hurt:next_state=State.HURT
		State.ATK_KICK,State.ATK_PUNCH:
			if %Ap.is_playing():pass
			else:next_state=State.IDLE
			if is_hurt:next_state=State.HURT
		State.HURT:
			if %Ap.is_playing():pass
			else:
				if hp<=0:next_state=State.SLEEP
				else:next_state=State.IDLE
		State.SLEEP:
			if %Ap.is_playing():pass
			else:if hp<=0:
				vanish()
				SoundEngine.play_sfx(preload("uid://bvbcarfw8qqst"))
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.IDLE:pass
			State.ATK_KICK:end_kick()
			State.ATK_PUNCH:end_punch()
			State.HURT:is_hurt=false
			State.SLEEP:end_sleep()
		match next_state:
			State.IDLE:%Ap.play("idle")
			State.AIR:%Ap.play("air")
			State.WALK:%Ap.play("walk")
			State.ATK_PUNCH:
				%Ap.play("atk_punch")
				velocity.x=0
				velocity.z=0
			State.ATK_KICK:
				%Ap.play("atk_kick")
				velocity.x=0
				velocity.z=0
			State.HURT:
				%Ap.play("hurt")
				%AudioStreamPlayer.stop()
				if randf()<0.1:SoundEngine.play_sfx(preload("uid://cqyfyxkxybxhw"))
			State.SLEEP:
				%Ap.play("sleep")
				SoundEngine.play_sfx(preload("uid://dxr3kkefd021h"))
				begin_sleep()
		#print(current_state,"->",next_state)
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			refresh_direction()
			if on_head:%Sprite.frame=12
			else:%Sprite.frame=0
			if under_foot:
				if try_jump:
					velocity.y+=p_jump
					velocity.x=speed*direction
					leave_from_under()
			else:
				velocity.x=speed*input.x
				velocity.z=speed*input.y
				if try_jump:velocity.y+=p_jump
		State.WALK:
			refresh_direction()
			if on_head:
				match ap_tick:
					0:%Sprite.frame=10
					1:%Sprite.frame=11
			else:
				match ap_tick:
					0:%Sprite.frame=8
					1:%Sprite.frame=9
			velocity.x=speed*input.x
			velocity.z=speed*input.y
			if try_jump:velocity.y+=p_jump
		State.AIR:
			refresh_direction()
			if on_head:%Sprite.frame=13
			else:%Sprite.frame=2
			velocity.x=speed*input.x
		State.ATK_PUNCH,State.ATK_KICK:pass
		State.HURT:pass
		
	#强制
	if under_foot:follow_under_foot()
	else:
		#find_step()
		velocity.y-=200*delta
	move_and_slide()

func refresh_direction():
	if is_zero_approx(input.x):pass
	else:direction=sign(input.x)

func state_can_lift()->bool:return current_state==State.IDLE or current_state==State.WALK
func is_stand()->bool:return is_zero_approx(velocity.x) and is_zero_approx(velocity.z)


func begin_kick():%HitboxKick.monitoring=true
func end_kick():%HitboxKick.monitoring=false
func begin_punch():%HitboxPunch.monitoring=true
func end_punch():%HitboxPunch.monitoring=false
func begin_sleep():
	if under_foot:leave_from_under()
	if on_head:on_head.leave_from_under()
	can_be_pick=true
	can_be_step=false
	can_step=false
func end_sleep():
	can_be_pick=false
	can_be_step=true
	can_step=true
const ARR_HIT= [preload("uid://dymdk4ecwavy1"),
	preload("uid://bfwbmcsdqj5hg")]

func _on_hitbox_area_entered(area: Area3D) -> void:
	if is_hurt:return
	var e:Entity=area.get_parent()
	if e==self:return
	if e.can_be_hit:
		e.be_hitted.emit(self)
		SoundEngine.play_sfx(ARR_HIT.pick_random())
		print(self,"-hit>",e)
		if e is People:
			e.hp-=atk
			e.is_hurt=true

const SFX_FOOT = preload("uid://c0756nlkf02pe")
func play_sfx_step():
	SoundEngine.play_sfx(SFX_FOOT,8)

const ARR_SFX =[preload("uid://coek4u8rulry8")
, preload("uid://dwg3lo0mcuonc")
,preload("uid://n13xt6s2k5e5")
,preload("uid://58h7kmf4a7gs")
, preload("uid://cfuyfivb5732x")
, preload("uid://ddxbgno0by643")
, preload("uid://byd43jevg200e")
, preload("uid://x6eukj2w1kkk")
,preload("uid://cpea4oic67rg4")
, preload("uid://cvvd6hb387onc")
, preload("uid://qt6vrwulj3op")
,preload("uid://doegr1lstur7g")
, preload("uid://bh3ciy8f4e0e")
, preload("uid://8aws12cw25b8")]


func _on_timer_speak_timeout() -> void:
	%TimerSpeak.start(randf_range(6,15))
	%AudioStreamPlayer.stop()
	%AudioStreamPlayer.stream=ARR_SFX.pick_random()
	%AudioStreamPlayer.play()

func _on_people_be_hitted(entity: Entity) -> void:
	if randf()<0.1:
		var v:Vector3=Vector3.ZERO
		v.x=-50*direction
		v.y=100
		var w:Word=boom_thing(load("uid://due6j0es4d4s3"),v)
		w.set_word(Word.arr_word.pick_random())
