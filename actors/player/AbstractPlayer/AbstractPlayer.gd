extends KinematicBody2D

signal health_changed(newValue)
signal max_health_changed(newValue)

signal mana_changed(newValue) 
signal max_mana_changed(newValue)

signal exp_changed(newValue)
signal max_exp_changed(newValue)

export(int) var Max_health = 20 setget set_max_health
export(int) var Max_mana = 10 setget set_max_mana
export(int) var Max_exp = 20 setget set_max_exp
var health setget set_health, get_health
var mana setget set_mana, get_mana
var exp_level setget increase_exp, get_exp
var level = 1 setget increase_level, get_level

export(int) var Max_MovSpeed = 130
export var accel = 0.5
export var fric = 0.2
var isDead = false

enum STATE{
	IDLE,
	RUN,
	ATTACK
}
var state = STATE.IDLE 

var vel = Vector2.ZERO
var InputVector = Vector2.ZERO

func _ready():
	_initialize()

func _physics_process(delta):
	_update(delta)
		
func _update(delta):
	"""
		This is a virtual method and shall be overwride by children nodes
	"""
	assert(false)
		
func _initialize():
	yield(get_tree(), "idle_frame")
	get_tree().call_group('enemies', '_set_player', self)
	
	exp_level = 0
	health = Max_health
	mana = Max_mana
	emit_signal("max_health_changed", Max_health)
	emit_signal("max_mana_changed", Max_mana)
	emit_signal("max_exp_changed", Max_exp)
	
	emit_signal("health_changed", health)
	emit_signal("mana_changed", mana)
	emit_signal("exp_changed", exp_level)

func set_max_health(new_value):
	Max_health = max(1, new_value)
	emit_signal("max_health_changed", Max_health)
	
func set_max_mana(new_value):
	Max_mana = max(1, new_value)
	emit_signal("max_mana_changed", Max_mana)

func set_max_exp(new_value):
	Max_exp = max(1, new_value)
	emit_signal("max_exp_changed", Max_exp)
	
func set_health(new_value):
	health = max(0, new_value)
	emit_signal("health_changed", health)
	if health == 0:
		kill()

func get_health():
	return health

func set_mana(new_value):
	mana = max(0, new_value)
	emit_signal("mana_changed", mana)

func get_mana():
	return mana
	
func increase_exp(value):
	exp_level += value
	if exp_level >= Max_exp:
		increase_level(1)
		var extra = exp_level - Max_exp
func get_exp():
	return exp_level
	
func increase_level(value):
	level += value

func get_level():
	return level
func kill():
	"""
		This is a virtual method and shall be overwride by children nodes
	"""
	assert(false)
func _take_damage():
	"""
		This is a virtual method and shall be overwride by children nodes
	"""
	assert(false)
