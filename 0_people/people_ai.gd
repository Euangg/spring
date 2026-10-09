class_name PeopleAI
extends People

var target_pos:Vector2

func _ready() -> void:
	super._ready()
	set_a_target(20)

func _physics_process(delta: float) -> void:
	input=Vector2.ZERO
	try_jump=false
	var pos=Vector2(position.x,position.z)
	if pos.distance_squared_to(target_pos)<=4:pass
	else:
		input=(target_pos-pos).normalized()
		if pos.distance_squared_to(target_pos)<=25:input*=0.4
	if under_foot:try_jump=true
	if on_head:try_kick=true
	
	super._physics_process(delta)

func set_a_target(range:float):
	if is_on_floor():
		%RayCast3D.position.x=randf_range(-range,range)
		%RayCast3D.position.z=randf_range(-range,range)
		%RayCast3D.force_raycast_update()
		if %RayCast3D.is_colliding():
			var p:Vector3=%RayCast3D.get_collision_point()
			target_pos=Vector2(p.x,p.z)
		else:pass


func _on_timer_run_timeout() -> void:set_a_target(50)
