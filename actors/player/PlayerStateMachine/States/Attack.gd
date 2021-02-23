extends Node

var combos = []

func _ready():
	for child in self.get_children():
		combos.push_front(child)
	print(combos)

func handle_input(event):
	for combo in combos:
		if !combo.is_enabled:
			return
		combo.handle_input(event)

func update(host, delta):
	get_owner().vel = get_owner().vel.linear_interpolate(Vector2.ZERO, get_owner().fric)
	get_owner().move_and_slide(get_owner().vel)
	for combo in combos:
		if !combo.is_enabled:
			return
		combo.update(host, delta)
