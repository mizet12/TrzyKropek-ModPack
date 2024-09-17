extends CharacterState

class_name CharacterHurtState

const SMOKE_SPEED = "6.5"
const SMOKE_FREQUENCY = 1
const COUNTER_HIT_ADDITIONAL_HITSTUN_FRAMES = 0
const HITSTUN_DECAY_PER_HIT = 1
const DI_BRACE_RATIO = "-0.25"
const IS_HURT_STATE = true

var brace = false
var guard_broken = false

enum BOUNCE{
	LEFT_WALL, 
	RIGHT_WALL, 
	NO_BOUNCE
}

var counter = false

var hitbox

func _enter_tree():
	is_hurt_state = true

func init():
	.init()


func _enter_shared():
	host.blocked_hitbox_plus_frames = 0
	brace = false
	host.feinting = false
	host.release_opponent()
	hitbox = data["hitbox"]
	host.z_index = - 1
	if hitbox.disable_collision:
		host.colliding_with_opponent = false


	if host.penalty_ticks <= 0:
		host.refresh_air_movements()
	host.state_interruptable = true
	host.busy_interrupt = true
	host.clear_buffer()
	._enter_shared()

	host.brace_effect_applied_yet = true

func _tick_shared():
	._tick_shared()

	if current_tick < 5:
		host.release_opponent()
	if current_tick % SMOKE_FREQUENCY == 0:
		var vel = host.get_vel()
		if fixed.gt(fixed.vec_len(vel.x, vel.y), SMOKE_SPEED):
			spawn_particle_relative(preload("res://fx/KnockbackSmoke.tscn"), host.hurtbox_pos_relative_float())

func hitstun_modifier(hitbox):
	return (COUNTER_HIT_ADDITIONAL_HITSTUN_FRAMES if hitbox.counter_hit else 0)


func global_hitstun_modifier(ticks):
	return fixed.round(fixed.mul(str(ticks), host.global_hitstun_modifier))

func brace_shave_hitstun(hitstun):
	return fixed.round(fixed.mul(str(hitstun), host.SUCCESSFUL_BRACE_HITSTUN_MODIFIER))

func di_shave_hitstun(hitstun, hitbox_dir_x, hitbox_dir_y):








	return hitstun

func get_vacuum_dir(hitbox):
	var pos_x = "0"
	var pos_y = "0"
	var hitbox_host = host.obj_from_name(hitbox.host)
	if hitbox_host:
		var my_pos = host.get_pos()
		var diff = {x = hitbox.pos_x - my_pos.x, y = hitbox.pos_x - my_pos.y}
		var dir = fixed.normalized_vec(str(diff.x), str(diff.y))
		pos_x = dir.x
		pos_y = dir.y
	return {x = pos_x, y = pos_y}

func get_x_dir(hitbox):
	return host.get_hitbox_x_dir(hitbox)




func _exit_shared():
	host.z_index = 0
	brace = false
	host.hit_out_of_brace = false
	guard_broken = false
	host.start_sadness_immunity()
	._exit_shared()

func can_interrupt():
	return false
