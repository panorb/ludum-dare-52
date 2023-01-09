extends Node

onready var tween : Tween = get_node("Tween")
var current_scene : Node = null
var next_scene : Node = null

onready var main_menu_scene := preload("res://menu/MainMenu.tscn")
onready var stage_scene := preload("res://game/stage/Stage.tscn")
onready var game_over_scene := preload("res://game/gameover/GameOver.tscn")
onready var beat_indicator_scene := preload("res://debug/BeatVisualizer.tscn")

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_finished")
	switch_scene(stage_scene)

func _on_MainMenu_start_button_pressed():
	switch_scene(stage_scene)

func _on_Stage_game_overed(hit_successes, total_hit_beats):
	switch_scene(game_over_scene)
	
	var percentage = round((float(hit_successes) / float(total_hit_beats)) * 100.0)
	next_scene.set_hit_percentage(percentage)
	
	if percentage >= 97:
		next_scene.set_game_over_text("Perfect! Now off for a drink.")
	elif percentage >= 45:
		next_scene.set_game_over_text("All in a good day's work!")
	else:
		next_scene.set_game_over_text("A nice walk, but a little unproductive.")

func _on_GameOver_restart_me():
	switch_scene(stage_scene)

func switch_scene(new_scene : PackedScene) -> void:
	next_scene = new_scene.instance()
	if next_scene.has_signal("start_button_pressed"):
		next_scene.connect("start_button_pressed", self, "_on_MainMenu_start_button_pressed")
	if next_scene.has_signal("game_overed"):
		next_scene.connect("game_overed", self, "_on_Stage_game_overed")
	if next_scene.has_signal("restart_me"):
		next_scene.connect("restart_me", self, "_on_GameOver_restart_me")
	
	next_scene["modulate"] = Color(1, 1, 1, 0)
	self.add_child(next_scene)
	
	tween.remove_all()
	
	if current_scene:
		tween.interpolate_property(current_scene, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.8, Tween.TRANS_CUBIC)
		tween.start()
	else:
		_on_tween_finished()

func _on_tween_finished():
	if next_scene != null:
		tween.remove_all()
		if current_scene:
			current_scene.queue_free()
		yield(get_tree(), "idle_frame")
		current_scene = next_scene
		next_scene = null
		
		tween.interpolate_property(current_scene, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.8, Tween.TRANS_CUBIC)
		tween.start()
