extends Node2D

const GROUND_SPEED := 200

# onready var ground_anchor = get_node("GroundAnchor")
onready var plant_container = get_node("%Plants")
onready var conductor = get_node("Conductor")
onready var moving_anchor = get_node("%MovingAnchor")
onready var ground_container = get_node("%GroundContainer")
onready var background_parallax: ParallaxBackground = $"%BackgroundParallax"

onready var radish_scene : PackedScene = preload("res://game/stage/Radish.tscn")

func _ready():
	conductor.connect("hit_result", self, "_on_hit_result")
	conductor.connect("tutorial_pattern_passed", self, "_on_tutorial_pattern_passed")
	spawn_radishes()

func spawn_radishes():
	var radish_start_pos : Position2D = plant_container.get_node("StartPosition")
	
	for i in range(len(conductor.hit_pattern)):
		if conductor.hit_pattern[i] == "1":
			var radish_instance := radish_scene.instance()
			radish_instance.name = "Beat " + str(i)
			radish_instance.position.y = radish_start_pos.position.y + rand_range(-5.0, 15.0)
			radish_instance.position.x = radish_start_pos.position.x - (i  * (conductor.seconds_per_beat) * GROUND_SPEED)
			plant_container.add_child(radish_instance)

var tutorial_loops_passed = 0

func _on_tutorial_pattern_passed():
	var radish_start_pos : Position2D = plant_container.get_node("StartPosition")
	tutorial_hit_sucesses = 0
	tutorial_loops_passed += 1
	
	tutorial_progress_label.text = str(tutorial_hit_sucesses) + "/3"
	
	for i in range(len(conductor.hit_pattern)):
		if conductor.hit_pattern[i] == "1":
			var plant = plant_container.get_node("Beat " + str(i))
			
			if not plant.already_invisible:
				plant.play_despawn_animation()
				yield(get_tree().create_timer(0.2), "timeout")
			
			plant.position.x = radish_start_pos.position.x - ((i + (tutorial_loops_passed * len(conductor.tutorial_pattern)))  * (conductor.seconds_per_beat) * GROUND_SPEED)
			plant.play_spawn_animation()

var tutorial_hit_sucesses = 0
onready var tutorial_progress_label = get_node("%TutorialProgressLabel")

func _on_hit_result(hit_result):
	if hit_result == conductor.BEAT_HIT_ZONE.HIT:
		if plant_container.has_node("Beat " + str(conductor.closest_beat_position)):
			var beat_plant = plant_container.get_node("Beat " + str(conductor.closest_beat_position))
			beat_plant.play_hit_success_animation()
			
			tutorial_hit_sucesses += 1
			
			if conductor.tutorial_mode:
				tutorial_progress_label.text = str(tutorial_hit_sucesses) + "/3"
			
	if hit_result == conductor.BEAT_HIT_ZONE.TOO_EARLY or hit_result == conductor.BEAT_HIT_ZONE.TOO_LATE:
		if plant_container.has_node("Beat " + str(conductor.closest_beat_position)):
			var beat_plant = plant_container.get_node("Beat " + str(conductor.closest_beat_position))
			beat_plant.play_hit_miss_animation()

func _process(delta):
	#if ground_anchor.position.x > 3840:
	#	ground_anchor.position.x = 0
	moving_anchor.position.x += GROUND_SPEED * delta
	ground_container.scroll_offset.x += GROUND_SPEED * delta
	background_parallax.scroll_offset.x += GROUND_SPEED * delta / 2
	# print(ground_container.position.x)


