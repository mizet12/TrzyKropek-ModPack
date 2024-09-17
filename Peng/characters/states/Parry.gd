extends CharacterState

class_name ParryState

const LANDING_LAG = 8
const AFTER_PARRY_ACTIVE_TICKS = 0

enum ParryHeight{
	High, 
	Low, 
	Both, 
}

export  var particle_location = Vector2(14, - 31)
export  var can_parry = true

export (ParryHeight) var parry_type = ParryHeight.High

var initial_parry_type
var parry_tick = 0
var parried = false
var started_in_combo = false

func _ready():
	initial_parry_type = parry_type

var parry_active = false
var perfect = true


func _frame_0():
	host.end_throw_invulnerability()
	started_in_combo = host.combo_count > 0
	endless = false
	perfect = true
	parry_type = initial_parry_type
	parry_active = true
	parry_tick = 0
	parried = false
	interruptible_on_opponent_turn = false
	anim_length = 20
	iasa_at = - 1

func is_usable():
	return .is_usable() and host.current_state().state_name != "WhiffInstantCancel"

func _frame_10():
	if can_parry:
		if not parried and perfect:
			parry_active = false

func parry(perfect = true):
	perfect = perfect and can_parry
	if perfect:
		enable_interrupt()
	else :
		parry_type = ParryHeight.Both
		host.start_throw_invulnerability()


	host.parried = true
	parried = true
	self.perfect = perfect
	
func can_parry_hitbox(hitbox):
	if not perfect:
		return true
	if hitbox == null:
		return false
	if not active:
		return false
	if not parry_active:
		return false

		
	match hitbox.hit_height:
		Hitbox.HitHeight.High:
			return parry_type == ParryHeight.High or parry_type == ParryHeight.Both
		Hitbox.HitHeight.Mid:
			return parry_type == ParryHeight.High or parry_type == ParryHeight.Both
		Hitbox.HitHeight.Low:
			return parry_type == ParryHeight.Low or parry_type == ParryHeight.Both
	return false

func _tick():
	host.apply_fric()
	if air_type == AirType.Aerial:
		host.apply_grav()
	if host.combo_count > 0:
		if current_tick > 30 and parried:
			enable_interrupt()
			return fallback_state


	host.apply_forces()

	if current_tick >= 10 and perfect and can_parry:
		parry_active = false

func _exit():
	host.blocked_last_hit = false
