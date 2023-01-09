extends Node2D

onready var animation_player = get_node("AnimationPlayer")

func play_hit_success_animation():
	animation_player.play("hit_success")

func play_hit_miss_animation():
	animation_player.play("hit_miss")
