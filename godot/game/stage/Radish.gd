extends Node2D

onready var animation_player = get_node("AnimationPlayer")

var already_invisible = false

func play_hit_success_animation():
	animation_player.play("hit_success")
	already_invisible = true

func play_hit_miss_animation():
	animation_player.play("hit_miss")
	already_invisible = true

func play_despawn_animation():
	if not already_invisible:
		animation_player.play("despawn")

func play_spawn_animation():
	animation_player.play("spawn")
	already_invisible = false
