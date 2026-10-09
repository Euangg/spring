extends PeopleAI


func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	try_punch=false

func punch_check(area:Area3D):
	print("find_target")
	try_punch=true

func _on_timer_run_timeout() -> void:
	if enemy:target_pos=Vector2(enemy.position.x,enemy.position.y)
	else:set_a_target(50)
