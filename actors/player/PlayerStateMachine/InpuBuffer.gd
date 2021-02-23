extends Node

var input_buffer: Array

func add_event(event: InputEvent):
	if input_buffer.size() + 1 >= 6:
		input_buffer.pop_front()
	input_buffer.push_back(event)
	$InputCooldown.start()
	print(input_buffer)

func _input(event: InputEvent):
	if event.is_action_pressed('ui_up') || event.is_action_pressed('ui_down') || event.is_action_pressed('ui_left') || event.is_action_pressed('ui_right') || event.is_action_pressed('attack1'):
		add_event(event)

func reset_buffer():
	input_buffer.resize(0)
	print(input_buffer)
