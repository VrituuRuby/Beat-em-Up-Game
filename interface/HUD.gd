extends Control

onready var health_bar = $HealthBar
onready var mana_bar = $ManaBar
onready var exp_bar = $ExpBar

func _on_Player_max_health_changed(newValue):
	health_bar.set_max(newValue)


func _on_Player_health_changed(newValue):
	health_bar.set_value(newValue)
