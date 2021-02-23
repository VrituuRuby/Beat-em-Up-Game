extends KinematicBody2D
enum STATE{
	IDLE,
	HURT,
	STUN,
	KNOCKEDBACK
}

onready var animation_player = $AnimationPlayer
onready var label = $Label
onready var sprite = $Sprite
onready var stun_timer = $StunTimer

var vel = Vector2.ZERO
var player = null
var state = STATE.IDLE
var player_dir = Vector2.ZERO
var stun_count = 0

func _ready():
	add_to_group('enemies')

func _process(delta):	
	match state:
		STATE.HURT:
			label.set_text('HURT')
			_hurt_state()
		STATE.IDLE:
			label.set_text('IDLE')
			_idle_state()
		STATE.STUN:
			label.set_text('STUNNED')
			_stun_state()
		STATE.KNOCKEDBACK:
			_knockedback_state()
			label.set_text('KNOCKED')

	if player != null:
		player_dir = global_position - player.global_position
	player_dir = player_dir.normalized()
		
	if player_dir.x < 0:
		sprite.scale.x = -1
	if player_dir.x > 0:
		sprite.scale.x = 1
	
	vel = move_and_slide(vel)

func _idle_state():
	animation_player.play("Idle")
	vel = vel.linear_interpolate(Vector2.ZERO, 0.2)

func _stun_state():
	vel = vel.linear_interpolate(Vector2.ZERO, 0.2)
	animation_player.play("Stun")

func _knockedback_state():
	animation_player.play("Knockback")
	vel.x = 250 * sprite.scale.x
	vel = vel.linear_interpolate(Vector2.ZERO, 0.4)

func _hurt_state():
	animation_player.play("Hurt")

func _take_damage():
	state = STATE.HURT
	vel.x = 20 * sprite.scale.x
	stun_count += 1
	stun_timer.start()
	if stun_count == 2:
		state = STATE.STUN
		stun_count = 0

func _set_player(playerNode):
 player = playerNode

func _on_Hurtbox_area_entered(area):
	if state != STATE.STUN:
		if player.global_position.y >= global_position.y - 10 and player.global_position.y <= global_position.y + 10:
			_take_damage()
			area.emit_signal('hit')
	else:
		state = STATE.KNOCKEDBACK

func _on_animation_finished():
	state = STATE.IDLE

func _on_StunTimer_timeout():
	stun_count = 0
