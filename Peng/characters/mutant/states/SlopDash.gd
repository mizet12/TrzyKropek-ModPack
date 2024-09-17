extends "res://characters/states/AirDash.gd"

const force_air_juke = true

func _enter():




	host.can_air_dash = false

func _frame_0():
	if host.is_grounded():
		started_in_air = true
		host.set_grounded(false)
		host.move_directly(0, - 1)
	._frame_0()

func is_usable():
	return .is_usable() and host.can_air_dash

func tick():

	pass
