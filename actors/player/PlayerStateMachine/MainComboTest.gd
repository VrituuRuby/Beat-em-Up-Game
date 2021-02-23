extends Node

export (bool) var is_enabled = true
var attack_index = 1
var can_attack = false
var hit_landed = false
onready var combo_timeout = $ComboTimeout
onready var input_getter = get_owner().get_node("InpuBuffer")

func handle_input(event):
	if event.is_action_pressed('attack1'):
		if can_attack and input_getter.input_buffer.back().is_action('attack1'):
			get_owner().vel.x = 60 * get_owner().get_node('Sprite').scale.x 
			combo_timeout.start()
			can_attack = false
			if hit_landed:
				hit_landed = false
				attack_index += 1
			else:
				attack_index = 1
	
func update(host, delta):
	match attack_index:
		0:
			host.change_state('idle')
		1:
			host.animation_player.play('Hit1')
		2:
			host.animation_player.play('Hit2')
		3:
			host.animation_player.play('Hit3')

func can_attack():
	can_attack = true
	combo_timeout.start()

func reset_combo():
	can_attack = false
	attack_index = 1
	input_getter.reset_buffer()
	input_getter.get_node("InputCooldown").stop()
	
func _on_Hitbox_hit():
	hit_landed = true
	hit_stop()
	
func hit_stop():
	get_owner().animation_player.playback_speed = 0.1
	combo_timeout.set_paused(true)
	yield(get_tree().create_timer(0.08), "timeout")
	get_owner().animation_player.playback_speed = 1
	combo_timeout.set_paused(false)

func _on_ComboTimeout_timeout():
	can_attack = false
	attack_index = 1
