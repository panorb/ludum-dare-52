extends Node2D

const GROUND_SPEED := 600
var current_speed : int

# onready var ground_anchor = get_node("GroundAnchor")
onready var plant_container = get_node("%Plants")
onready var conductor = get_node("Conductor")
onready var moving_anchor = get_node("%MovingAnchor")
onready var ground_container = get_node("%GroundContainer")
onready var background_parallax: ParallaxBackground = $"%BackgroundParallax"
onready var farmer_animation_player = get_node("%FarmerAnimationPlayer")

onready var radish_scene : PackedScene = preload("res://game/stage/Radish.tscn")
onready var tween : Tween = get_node("Tween")

signal game_overed

var total_hit_beats = 0

func _ready():
	current_speed = GROUND_SPEED
	
	for beat in conductor.song_pattern:
		if beat == "1":
			total_hit_beats += 1
	
	conductor.connect("hit_result", self, "_on_hit_result")
	conductor.connect("tutorial_pattern_passed", self, "_on_tutorial_pattern_passed")
	conductor.connect("main_song_passed", self, "_on_main_song_passed")
	spawn_radishes()

func spawn_radishes() -> void:
	var radish_start_pos : Position2D = plant_container.get_node("StartPosition")
	
	for i in range(len(conductor.hit_pattern)):
		var radish_instance = null
		
		if plant_container.has_node("Beat " + str(i)):
			radish_instance = plant_container.get_node("Beat " + str(i))
			radish_instance.play_despawn_animation()
			yield(get_tree().create_timer(0.2), "timeout")
			if conductor.hit_pattern[i] == "0":
				radish_instance.queue_free()
		
		if conductor.hit_pattern[i] == "1":
			if radish_instance == null:
				radish_instance = radish_scene.instance()
			
			radish_instance.position.y = radish_start_pos.position.y + rand_range(-5.0, 15.0)
			
			if radish_instance.get_parent() == null:
				radish_instance.name = "Beat " + str(i)
				plant_container.add_child(radish_instance)
			
			radish_instance.play_spawn_animation()
			yield(get_tree(), "idle_frame")
			
			if conductor.tutorial_mode:
				radish_instance.position.x = radish_start_pos.position.x - ((i + (tutorial_loops_passed * len(conductor.tutorial_pattern)))  * conductor.seconds_per_beat * GROUND_SPEED)
			else:
				radish_instance.position.x = radish_start_pos.position.x - ((i + (tutorial_loops_passed * len(conductor.tutorial_pattern)) - 1)  * conductor.seconds_per_beat * GROUND_SPEED)
			
			yield(get_tree().create_timer(0.05), "timeout")

var tutorial_loops_passed = 0

func _on_tutorial_pattern_passed():
	tutorial_loops_passed += 1
	if tutorial_hit_sucesses >= 3:
		tween.interpolate_property(get_node("%TutorialUI"), "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.8, Tween.TRANS_CIRC)
		tween.start()
		conductor.start_main_song()
		spawn_radishes()
		return
	
	var radish_start_pos : Position2D = plant_container.get_node("StartPosition")
	tutorial_hit_sucesses = 0
	
	tutorial_progress_label.text = str(tutorial_hit_sucesses) + "/3"
	
	spawn_radishes()
#	for i in range(len(conductor.hit_pattern)):
#		if conductor.hit_pattern[i] == "1":
#			var plant = plant_container.get_node("Beat " + str(i))
#
#			if not plant.already_invisible:
#				plant.play_despawn_animation()
#				yield(get_tree().create_timer(0.2), "timeout")
#
#			plant.position.x = radish_start_pos.position.x - ((i + (tutorial_loops_passed * len(conductor.tutorial_pattern)))  * (conductor.seconds_per_beat) * GROUND_SPEED)
#			plant.play_spawn_animation()

func _on_main_song_passed():
	emit_signal("game_overed")

var song_hit_successes = 0
var tutorial_hit_sucesses = 0
onready var tutorial_progress_label = get_node("%TutorialProgressLabel")

func _on_hit_result(hit_result):
	if hit_result == conductor.BEAT_HIT_ZONE.HIT:
		if plant_container.has_node("Beat " + str(conductor.closest_beat_position)):
			var beat_plant = plant_container.get_node("Beat " + str(conductor.closest_beat_position))
			beat_plant.play_hit_success_animation()
			
			
			if conductor.tutorial_mode:
				tutorial_hit_sucesses += 1
				tutorial_progress_label.text = str(tutorial_hit_sucesses) + "/3"
			else:
				song_hit_successes += 1
			
			farmer_animation_player.play("pull")
			
			# Hit Pause
#			current_speed = 0
#			yield(get_tree().create_timer(0.15), "timeout")
#			current_speed = GROUND_SPEED
			
	if hit_result == conductor.BEAT_HIT_ZONE.TOO_EARLY or hit_result == conductor.BEAT_HIT_ZONE.TOO_LATE:
		if plant_container.has_node("Beat " + str(conductor.closest_beat_position)):
			var beat_plant = plant_container.get_node("Beat " + str(conductor.closest_beat_position))
			beat_plant.play_hit_miss_animation()

func _process(delta):
	#if ground_anchor.position.x > 3840:
	#	ground_anchor.position.x = 0
	moving_anchor.position.x += current_speed * delta
	ground_container.scroll_offset.x += current_speed * delta
	background_parallax.scroll_offset.x += current_speed * delta / 3
	# print(ground_container.position.x)


