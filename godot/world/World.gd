extends Node

onready var tween : Tween = get_node("Tween")
var current_scene : Node = null
var next_scene : Node = null

onready var main_menu_scene := preload("res://menu/MainMenu.tscn")

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_finished")
	switch_scene(main_menu_scene)
	
func switch_scene(new_scene : PackedScene) -> void:
	next_scene = new_scene.instance()
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
		current_scene = next_scene
		next_scene = null
		
		tween.interpolate_property(current_scene, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.8, Tween.TRANS_CUBIC)
		tween.start()
