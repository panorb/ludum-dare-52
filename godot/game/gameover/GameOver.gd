extends Control


var time_since_start : float = 0.0
var pressed : bool = false

signal restart_me

func _process(delta):
	time_since_start += delta

func set_game_over_text(text : String):
	get_node("%GameOverText").text = text

func set_hit_percentage(percentage : int):
	get_node("%PercentageLabel").text = str(percentage) + "% hit"

func _input(event):
	if event.is_action_pressed("beat_hit") and time_since_start >= 1.5 and not pressed:
		pressed = true
		emit_signal("restart_me")
