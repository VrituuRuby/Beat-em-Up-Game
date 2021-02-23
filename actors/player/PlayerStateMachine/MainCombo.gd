extends Node

export (bool) var is_enabled = true
export (float) var combo_timeout = 0.5
var attack_index = 1
var can_attack = false
var hit_landed = false

func _ready():
	$ComboTimeout.wait_time = combo_timeout

func handle_input(event):
	if can_attack and event.is_action_pressed('attack1'):
		$ComboTimeout.stop()
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
			host.get_node('AnimationTree').get('parameters/playback').travel('Hit1')
		2:
			host.get_node('AnimationTree').get('parameters/playback').travel('Hit2')
		3:
			host.get_node('AnimationTree').get('parameters/playback').travel('Hit4')
			
func can_attack():
	can_attack = true
	$ComboTimeout.start()
	
func reset_combo():
	can_attack = false
	attack_index = 1
	
func _on_ComboTimeout_timeout():
	reset_combo()
	
func _on_Hitbox_hit():
	hit_landed = true
