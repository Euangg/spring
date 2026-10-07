extends Node3D


var time_acc:float

@export var swing:bool=false
@export var amplitude:float=0.05
@export var cycle:float=2
@export var phase:float=0

func _ready() -> void:
	if swing:phase=randf_range(-PI,PI)

func _physics_process(delta: float) -> void:
	time_acc+=delta
	if swing:
		rotation.x=amplitude*sin(2*PI/cycle*time_acc+phase)
		
