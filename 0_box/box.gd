class_name Box
extends Entity

@export var can_hit:bool=false

var friction:float=100
var last_mover:People=null


func _ready() -> void:
	super._ready()
func _physics_process(delta: float) -> void:
	if under_foot:follow_under()
	else:
		if is_on_floor():
			velocity.x=move_toward(velocity.x,0,friction*delta)
			if velocity.length_squared()<=25:can_hit=false
		else:
			velocity.y-=200*delta
	move_and_slide()
	
	if can_hit and velocity.length_squared()>25:
		var arr_areas:Array[Area3D]=area_body.get_overlapping_areas()
		for a in arr_areas:
			var e=a.get_parent()
			if e is People:
				if e.is_hurt:continue
				if timer_thrower_protect.is_stopped():pass
				else:
					if e==thrower:continue
				e.is_hurt=true
				e.hp-=10

func _on_be_throwed(e:Entity):
	super._on_be_throwed(e)
	if e is People:last_mover=e
