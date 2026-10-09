extends Box



func _on_be_throwed(e:Entity):
	super._on_be_throwed(e)
	velocity.x*=3
	velocity.y*=0.5
	
