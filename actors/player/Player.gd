extends "res://actors/player/AbstractPlayer/AbstractPlayer.gd"

onready var state_machine = $AnimationTree["parameters/playback"]

func _ready():
	$AnimationTree.active = true

func _update(delta):
	$ShowAttackIndex.text = str(attack_index)
	_get_input()
	match state:
		STATE.IDLE:
			_idle_state()
			$ShowState.set_text('IDLE')
		STATE.RUN:
			_run_state()
			$ShowState.set_text('RUN')
		STATE.ATTACK:
			_attack_state()
			$ShowState.set_text('ATTACK')
	
	if state != STATE.ATTACK:
		if InputVector != Vector2.ZERO:
			vel = vel.linear_interpolate(InputVector * Max_MovSpeed, accel)
			state = STATE.RUN
		else:
			state = STATE.IDLE
	
	if vel.x > 0:
		$Sprite.scale.x = 1
	if vel.x < 0:
		$Sprite.scale.x = -1
	
	vel = move_and_slide(vel)
	
func _get_input():
# GET MOVEMENT INPUT ==================================
	InputVector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		InputVector.y -= 1
	if Input.is_action_pressed('ui_down'):
		InputVector.y += 1
	if Input.is_action_pressed("ui_left"):
		InputVector.x -= 1
	if Input.is_action_pressed('ui_right'):
		InputVector.x += 1
	InputVector = InputVector.normalized()
# GET KEYS INPUT ======================================
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("attack1"):
		if attack_index == 0 or can_attack:
			can_attack = false
			vel.x += 100 * $Sprite.scale.x
			$ComboTimer.stop()
			if hit_landed:
				hit_landed = false
				attack_index += 1
			else:
				attack_index = 1
		state = STATE.ATTACK
		
func _idle_state():
	vel = vel.linear_interpolate(Vector2.ZERO, fric)
	state_machine.travel('Idle')

func _run_state():
	state_machine.travel('Run')
	
func animation_finished():
	state = STATE.IDLE
	
var attack_index = 0
var can_attack = false
var hit_landed = false

func _attack_state():
	vel = vel.linear_interpolate(Vector2.ZERO, fric)
	match attack_index:
		1:
			state_machine.travel('Hit1')
		2:
			state_machine.travel('Hit2')
		3:
			state_machine.travel('Hit4')
			
func _can_attack():
	$ComboTimer.start()
	can_attack = true

func _reset_combo():
	animation_finished()
	attack_index = 0
	can_attack = false
	hit_landed = false
	
func _on_ComboTimer_timeout():
	attack_index = 0
	can_attack = false
	hit_landed = false
	
func _hit_stop():
	$AnimationPlayer.playback_speed = 0

func _on_Hitbox_hit():
	$ComboTimer.stop()
	_hit_stop()
	hit_landed = true
