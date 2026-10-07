extends PeopleAI


func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	try_punch=false

func punch_check(area:Area3D):
	print("find_target")
	try_punch=true
