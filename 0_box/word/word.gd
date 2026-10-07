class_name Word
extends Box

static var arr_word=["麻","莫","手","土","力"]


@export_enum("麻","莫","手","土","力") var word="麻":set=set_word
func set_word(value:String):
	word=value
	if not is_node_ready():await ready
	%Sprite.frame=arr_word.find(word)

var speed=100

func _ready() -> void:
	super._ready()
	%Sprite.frame=arr_word.find(word)
const SFX_COMPOSE = preload("uid://65w85es5laiv")


const PEOPLE = preload("uid://dn3sb41verlyj")
const PEOPLE_AI = preload("uid://bpx4k2enrwks4")
const STONE = preload("uid://ip8f3ryeiccl")
const MOTOR = preload("uid://d1ulsuaqobgbw")
const SMALL_STONE = preload("uid://chcdl1btul72q")
func compound_to(packed:PackedScene):
	var comp:Entity=packed.instantiate()
	comp.position=under_foot.position
	add_sibling(comp)
	under_foot.vanish()
	vanish()
	SoundEngine.play_sfx(SFX_COMPOSE)
	
	match packed:
		MOTOR:
			comp.velocity.x=speed if randf()>0.5 else -speed
			if last_mover:
				var v_p=Vector2(last_mover.position.x,last_mover.position.z)
				comp.velocity.x=last_mover.direction*speed
				if last_mover.enemy:
					var v_e=Vector2(last_mover.enemy.position.x,last_mover.enemy.position.z)
					var dir=(v_e-v_p).normalized()
					comp.velocity.x=dir.x*speed
					comp.velocity.z=dir.y*speed
			direction=sign(velocity.x)

func compound_hand_power():
	under_foot.vanish()
	vanish()
	SoundEngine.play_sfx(SFX_COMPOSE)
	if last_mover:
		last_mover.atk*=1.5
func compound_hand_drit():
	under_foot.vanish()
	vanish()
	SoundEngine.play_sfx(SFX_COMPOSE)
	if last_mover:
		last_mover.hp+=15

func _on_stepped_05(target: Entity) -> void:
	if target is Word:
		match word:
			"麻":
				match target.word:
					"麻":vanish()
					"莫":pass
					"手":compound_to(MOTOR)
					"土":pass
					"力":pass
			"莫":
				match target.word:
					"麻":pass
					"莫":vanish()
					"手":compound_to(PEOPLE_AI)
					"土":compound_to(STONE)
					"力":compound_to(PEOPLE_AI)
			"手":
				match target.word:
					"麻":compound_to(MOTOR)
					"莫":compound_to(PEOPLE_AI)
					"手":vanish()
					"土":compound_hand_drit()
					"力":compound_hand_power()
			"土":
				match target.word:
					"麻":pass
					"莫":compound_to(STONE)
					"手":compound_hand_drit()
					"土":vanish()
					"力":compound_to(SMALL_STONE)
			"力":
				match target.word:
					"麻":pass
					"莫":compound_to(PEOPLE_AI)
					"手":compound_hand_power()
					"土":compound_to(SMALL_STONE)
					"力":vanish()
