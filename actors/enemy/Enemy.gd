extends KinematicBody2D
enum STATE{
	IDLE,
	HURT,
	ATTACK
}

onready var animation_player = $AnimationPlayer
onready var label = $Label
onready var sprite = $Sprite


var vel = Vector2.ZERO
var player = null
var state = STATE.IDLE
var player_dir = Vector2.ZERO

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

func _hurt_state():
	animation_player.play("Hurt")

func _take_damage():
	state = STATE.HURT
	vel.x += 20 * sprite.scale.x

func _set_player(playerNode):
 player = playerNode

func _on_Hurtbox_area_entered(area):
	if player.global_position.y >= global_position.y - 10 and player.global_position.y <= global_position.y + 10:
		_take_damage()
		area.emit_signal('hit')

func _on_animation_finished():
	state = STATE.IDLE

