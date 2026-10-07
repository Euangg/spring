class_name Motor
extends Entity


func _physics_process(delta: float) -> void:
	if under_foot:follow_under_foot()
	else:velocity.y-=200*delta
	if is_zero_approx(velocity.x):pass
	else: velocity.x=move_toward(velocity.x,100*direction,delta*100)
	move_and_slide()

func _on_body_area_entered(area: Area3D) -> void:
	if velocity.length_squared()>=50:
		var e:Entity=area.get_parent()
		if e is People:
			e.hp-=15
			e.velocity.y+=100
			e.is_hurt=true


func _on_be_hitted(entity: Entity) -> void:
	direction*=-1

func on_motor_be_thorwed(thrower:Entity):
	SoundEngine.play_sfx(load("uid://b6rdsf186gk2m"))
