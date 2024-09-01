extends Area2D


@onready var timer = $Timer

func _on_body_entered(body):
	if body.has_method("apply_impulse"): 
		body.apply_impulse(Vector2(), Vector2(0, -170))  
	elif body.has_method("move_and_slide"): 
		body.velocity.y = -170  
	Engine.time_scale = 0.7
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
