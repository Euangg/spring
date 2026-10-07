class_name Entity
extends CharacterBody3D
enum Direction{LEFT=-1,RIGHT=1}
@export var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		pivot.scale.x=direction

@onready var pivot: Node3D = $Pivot
@onready var area_body: Area3D = $Body
@onready var timer_step_05: Timer = $TimerStep05
signal stepped_05(target:Entity)

var on_head:Entity=null
var under_foot:Entity=null
var top_plain:Area3D=null
var height:float=0

var thrower:Entity=null
@onready var timer_trowed_01: Timer = $TimerTrowed01
signal be_throwed(thrower:Entity)

@export var can_be_pick:bool=false
@export var can_step:bool=false
@export var can_be_step:bool=false
@export var can_be_hit:bool=true
signal be_hitted(entity:Entity)

const PLAIN_PIECE = preload("uid://elodal0xx3sh")
func generate_top_plain():
	var num_child=area_body.get_child_count()
	if num_child:
		var c3d:CollisionShape3D=area_body.get_child(0)
		var box:BoxShape3D=c3d.shape
		height=box.size.y
		var y_top=c3d.position.y+box.size.y/2
		var plain:Area3D=PLAIN_PIECE.instantiate()
		plain.position.y=y_top
		plain.scale=box.size
		add_child(plain)
		top_plain=plain

func follow_under_foot():
	velocity=Vector3.ZERO
	if under_foot:
		global_position=under_foot.top_plain.get_global_position()

func leave_from_under():
	under_foot.on_head=null
	under_foot=null
	timer_step_05.stop()
func step_to(target:Entity):
	under_foot=target
	target.on_head=self
	timer_step_05.start()
	#print(self,"->",target)
func vanish():
	if on_head:on_head.leave_from_under()
	if under_foot:leave_from_under()
	queue_free()



func is_step_on()->bool:return (is_on_floor() or under_foot)
func try_step(area:Area3D)->void:
	if is_step_on():return
	if can_step:
		var e:Entity=area.get_parent()
		if e.on_head:return
		if e==self:return
		if e.can_be_step:
			if velocity.y<=e.velocity.y:
				var et=e.top_plain.global_position.y
				var my=global_position.y
				if et<(my+height*0.5):
					step_to(e)

func _on_area_body_area_entered(area: Area3D) -> void:
	try_step(area)

func _on_timer_step_05_timeout() -> void:
	if under_foot:stepped_05.emit(under_foot)

func _on_timer_trowed_01_timeout() -> void:thrower=null
func _on_be_throwed(e:Entity):
	thrower=e
	timer_trowed_01.start()

func boom_thing(packed:PackedScene,velocity:Vector3)->Entity:
	var t:Entity=packed.instantiate()
	t.position=position
	t.velocity=velocity
	add_sibling(t)
	return t

func _ready() -> void:
	generate_top_plain()
	be_throwed.connect(_on_be_throwed)
	timer_step_05.timeout.connect(_on_timer_step_05_timeout)
	timer_trowed_01.timeout.connect(_on_timer_trowed_01_timeout)
	area_body.area_entered.connect(_on_area_body_area_entered)
