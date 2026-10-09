class_name Word
extends Box

static var arr_word=["麻","莫","手","土","力"]


@export_enum("麻","莫","手","土","力") var word="麻":set=set_word
func set_word(value:String):
	word=value
	if not is_node_ready():await ready
	%Sprite.frame=arr_word.find(word)

var motor_speed=150

func _ready() -> void:
	super._ready()
	%Sprite.frame=arr_word.find(word)

const SFX_COMPOSE = preload("uid://65w85es5laiv")

const PEOPLE = preload("uid://dn3sb41verlyj")
const PEOPLE_AI = preload("uid://bpx4k2enrwks4")
const STONE = preload("uid://ip8f3ryeiccl")
const MOTOR = preload("uid://d1ulsuaqobgbw")
const SMALL_STONE = preload("uid://chcdl1btul72q")
const PEOPLE_AI_ATK = preload("uid://6uf7gnkygun5")
func compound_to(packed:PackedScene):
	var comp:Entity=packed.instantiate()
	comp.position=under_foot.position
	add_sibling(comp)
	under_foot.vanish()
	vanish()
	SoundEngine.play_sfx(SFX_COMPOSE)
	
	match packed:
		MOTOR:
			var motor:Motor=comp
			motor.velocity.x=motor_speed if randf()>0.5 else -motor_speed
			if last_mover:
				var vp_motor=Vector2(motor.position.x,motor.position.z)
				motor.velocity.x=last_mover.direction*motor_speed
				if last_mover.enemy:
					var enemy:People=last_mover.enemy
					print("motor target:",enemy)
					var vp_enemy=Vector2(enemy.position.x,enemy.position.z)
					var dir=(vp_enemy-vp_motor).normalized()
					motor.velocity.x=dir.x*motor_speed
					motor.velocity.z=dir.y*motor_speed
			motor.direction=sign(motor.velocity.x)
		PEOPLE_AI:
			if last_mover:
				var ppp:People=comp
				ppp.current_skin=last_mover.current_skin
		PEOPLE_AI_ATK:
			if last_mover:
				comp.enemy=last_mover.enemy
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
					"力":compound_to(PEOPLE_AI_ATK)
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
					"莫":compound_to(PEOPLE_AI_ATK)
					"手":compound_hand_power()
					"土":compound_to(SMALL_STONE)
					"力":vanish()
