class_name Motor
extends Entity

var hp=100

func _physics_process(delta: float) -> void:
	if under_foot:follow_under()
	else:velocity.y-=200*delta
	if is_zero_approx(velocity.x):pass
	else: velocity.x=move_toward(velocity.x,150*direction,delta*100)
	move_and_slide()

func _on_body_area_entered(area: Area3D) -> void:
	if velocity.length_squared()>=50:
		var e:Entity=area.get_parent()
		if e is People:
			e.hp-=15
			e.velocity.y+=100
			e.is_hurt=true

func _on_be_hitted(entity: Entity) -> void:
	super._on_be_hitted(entity)
	direction*=-1
	hp-=15
	if hp<=0:
		var w1:Word=boom_thing(load(Global.ENTITY_WORD),Vector3(-50,100,0))
		var w2:Word=boom_thing(load(Global.ENTITY_WORD),Vector3(50,100,0))
		if randf()<0.5:
			w1.set_word("手")
			w2.set_word("麻")
		else:
			w1.set_word("麻")
			w2.set_word("手")
		vanish()

func _on_be_throwed(e:Entity):
	super._on_be_throwed(e)
	SoundEngine.play_sfx(load("uid://b6rdsf186gk2m"))
