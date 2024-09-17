extends BaseProjectile

func disable():
	.disable()
	creator.shockwave_projectile = null

func on_got_blocked():
	disable()
	
func hit_by(hitbox):
	.hit_by(hitbox)
	var obj = obj_from_name(hitbox.host)
	if obj == get_opponent() and current_state().state_name == "Default" and not hitbox.throw:
		change_state("FizzleOut")
	
