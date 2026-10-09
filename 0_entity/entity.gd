class_name Entity
extends CharacterBody3D

const PLAIN_PIECE = preload("uid://elodal0xx3sh")

enum Direction{LEFT=-1,RIGHT=1}
@export var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		pivot.scale.x=direction

signal be_hitted(entity:Entity)
signal be_throwed(thrower:Entity)
signal stepped_05(target:Entity)

@onready var pivot: Node3D = $Pivot
@onready var area_body: Area3D = $Body
@onready var timer_step_05: Timer = $TimerStep05


var on_head:Entity=null
var under_foot:Entity=null
var on_hand:Entity=null
var thrower:Entity=null

var top_plain:Area3D=null
var height:float=0
var timer_thrower_protect: Timer

@export var can_be_pick:bool=false
@export var can_step:bool=false
@export var can_be_step:bool=false
@export var can_be_hit:bool=true

func follow_under():
	if under_foot:
		velocity=Vector3.ZERO
		global_position=under_foot.top_plain.get_global_position()
func disbind_from_under():
	under_foot.on_head=null
	under_foot=null
	timer_step_05.stop()
func bind_to_under(target:Entity):
	under_foot=target
	target.on_head=self
	timer_step_05.start()
	follow_under()

func generate_top_plain()->Area3D:
	var num_child=area_body.get_child_count()
	if num_child:
		var c3d:CollisionShape3D=area_body.get_child(0)
		var box:BoxShape3D=c3d.shape
		height=box.size.y
		var y_top=c3d.position.y+box.size.y/2
		var plain:Area3D=PLAIN_PIECE.instantiate()
		plain.position.y=y_top
		plain.scale=box.size
		return plain
	return null
func vanish():
	if on_head:on_head.disbind_from_under()
	if under_foot:disbind_from_under()
	queue_free()
func is_step_on()->bool:return (is_on_floor() or under_foot)
func try_step(area:Area3D)->void:
	if is_step_on():return
	if can_step:
		var e:Entity=area.get_parent()
		if e==self:return
		if e._can_be_step():
			if velocity.y<=e.velocity.y:
				var et=e.top_plain.global_position.y
				var my=global_position.y
				if et<(my+height*0.4):
					bind_to_under(e)

func _on_area_body_area_entered(area: Area3D) -> void:
	try_step(area)

func _on_timer_step_05_timeout() -> void:
	if under_foot:stepped_05.emit(under_foot)

func boom_thing(packed:PackedScene,velocity:Vector3)->Entity:
	var t:Entity=packed.instantiate()
	t.position=position
	t.velocity=velocity
	add_sibling(t)
	t.be_throwed.emit(self)
	return t

func _ready() -> void:
	safe_margin=0.1
	top_plain=generate_top_plain()
	if top_plain:add_child(top_plain)
	timer_thrower_protect=Timer.new()
	timer_thrower_protect.wait_time=0.1
	timer_thrower_protect.one_shot=true
	add_child(timer_thrower_protect)
	be_hitted.connect(_on_be_hitted)
	be_throwed.connect(_on_be_throwed)
	timer_step_05.timeout.connect(_on_timer_step_05_timeout)
	area_body.area_entered.connect(_on_area_body_area_entered)

func _can_be_step()->bool:
	if on_head:return false
	if on_hand:return false
	return can_be_step
func _on_be_hitted(e:Entity):pass
func _on_be_throwed(e:Entity):
	thrower=e
	timer_thrower_protect.start()
