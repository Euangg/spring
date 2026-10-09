extends Entity

var shake:float
var hp:float=100
func _physics_process(delta: float) -> void:
	velocity.y-=60*delta
	move_and_slide()
	
	if is_zero_approx(shake):pass
	else:
		pivot.position=Vector3(
			randf_range(-shake,shake),
			randf_range(-shake,shake),
			randf_range(-shake,shake),
		)
		shake=move_toward(shake,0,30*delta)
	
func _on_be_hitted(e:Entity):
	super._on_be_hitted(e)
	shake+=4
	hp-=20
	if hp<=0:
		var w1:Word=boom_thing(load(Global.ENTITY_WORD),Vector3(-50,100,0))
		var w2:Word=boom_thing(load(Global.ENTITY_WORD),Vector3(50,100,0))
		if randf()<0.5:
			w1.set_word("土")
			w2.set_word("莫")
		else:
			w1.set_word("莫")
			w2.set_word("土")
		vanish()
