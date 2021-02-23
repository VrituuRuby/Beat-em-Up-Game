extends "res://actors/player/AbstractPlayer/AbstractPlayer.gd"

var input_direction: Vector2 = Vector2.ZERO
onready var animation_player = $AnimationPlayer

func get_input_direction():
	input_direction.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	return input_direction
	
func _ready():
	change_state('idle')

onready var state_map = {
	"idle": 	$States/Idle,
	"run": 		$States/Run,
	"attack": 	$States/Attack
}
onready var current_state

func _update(delta):
	$ShowAttackIndex.set_text(str($States/Attack/MainCombo.attack_index))
	var state_name = current_state.update(self, delta)
	if state_name:
		change_state(state_name)

func change_state(new_state):
	current_state = state_map[new_state]
	$ShowState.set_text(new_state)
	
func _input(event):
	if event.is_action_pressed("attack1"):
		if current_state == state_map.attack:
			return
		change_state('attack')
	if event.is_action_pressed('quit'):
		get_tree().quit()
		return
	if event.is_action_pressed('reset'):
		get_tree().reload_current_scene()
		return
	current_state.handle_input(event)
	
func on_animation_finished():
	change_state('idle')
