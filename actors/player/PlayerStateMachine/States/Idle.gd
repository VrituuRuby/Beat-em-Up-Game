extends Node

func handle_input(event):
	return

func update(host, delta):
	host.vel = host.vel.linear_interpolate(Vector2.ZERO, host.fric)
	host.vel = host.move_and_slide(host.vel)
	host.animation_player.play('Idle')
	if host.get_input_direction() != Vector2.ZERO:
		return 'run'
