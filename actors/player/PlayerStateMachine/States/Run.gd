extends Node

func handle_input(event):
	return

func update(host, delta):
	host.animation_player.play('Run')
	var input_vector = host.get_input_direction()
	host.vel = host.vel.linear_interpolate(input_vector * host.Max_MovSpeed, host.accel)
	host.vel = host.move_and_slide(host.vel) 
	
	if host.vel.x > 0:
		host.get_node('Sprite').scale.x = 1
	if host.vel.x < 0:
		host.get_node('Sprite').scale.x = -1
	
	if host.get_input_direction() == Vector2.ZERO:
		return 'idle'
