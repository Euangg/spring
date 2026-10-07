extends Entity


func _physics_process(delta: float) -> void:
	velocity.y-=60*delta
	move_and_slide()
