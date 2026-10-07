class_name Box
extends Entity

var friction:float=100
var last_mover:People=null

func _ready() -> void:
	super._ready()
func _physics_process(delta: float) -> void:
	if under_foot:follow_under_foot()
	else:
		if is_on_floor():
			velocity.x=move_toward(velocity.x,0,friction*delta)
		else:
			velocity.y-=200*delta
			#find_step()
	move_and_slide()
	
	if velocity.length()>5:
		var arr_areas:Array[Area3D]=area_body.get_overlapping_areas()
		for a in arr_areas:
			var e=a.get_parent()
			if e is People:
				if e.is_hurt:continue
				if e==thrower:
					print("trower!")
					continue
				e.is_hurt=true
				e.hp-=10

func on_box_be_throwed(thrower:Entity):
	last_mover=thrower
