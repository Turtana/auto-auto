extends KinematicBody2D

export (Vector2) var play_limit
export var actions = []

var speed = 500
var rotation_speed = .05
var timer

func _ready():
	timer = 0

func _process(_delta):
	if timer >= 300:
		return
	
	if actions[timer] == 0:
		move_and_slide(Vector2(0,-speed).rotated(rotation))
	if actions[timer] == 1:
		move_and_slide(Vector2(0,speed).rotated(rotation))
	if actions[timer] == 2:
		rotate(-rotation_speed)
	if actions[timer] == 3:
		rotate(rotation_speed)
	position.x = clamp(position.x, 0, play_limit.x)
	position.y = clamp(position.y, 0, play_limit.y)
	
	$Score.set_rotation(-rotation)
	
	timer += 1