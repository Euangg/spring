extends TextureProgressBar

@onready var front: TextureProgressBar = $Front
func _process(delta: float) -> void:
	value=move_toward(value,front.value,80*delta)
