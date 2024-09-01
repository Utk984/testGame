extends Node2D

const speed = 60
var dir = 1

@onready var ray_cast_right_down = $RayCastRightDown
@onready var ray_cast_left_down = $RayCastLeftDown
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta):
	if not ray_cast_right_down.is_colliding() or ray_cast_right.is_colliding():
		dir = -1
		animated_sprite.flip_h = true
	if not ray_cast_left_down.is_colliding() or ray_cast_left.is_colliding():
		dir = 1
		animated_sprite.flip_h = false
	position.x += dir * speed * delta
