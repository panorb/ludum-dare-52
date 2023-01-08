extends Control

onready var beat_hit_zone_label = get_node("%BeatHitZoneLabel")
onready var beat_num_label = get_node("%BeatNumLabel")

onready var conductor = get_node("%Conductor")
onready var beat_indicator : TextureRect = get_node("%BeatIndicator")
var beat_label_frozen := false
#func _process(delta):
#	beat_hit_zone_label.text = conductor.get_beat_hit_zone_string(conductor.current_beat_zone)

func _process(delta):
	beat_num_label.text = "Beat " + str(conductor.closest_beat_position)

func _on_Conductor_enter_beat_close_zone():
	pass
	# beat_indicator.rect_scale = Vector2(0.42, 0.42)

func _on_Conductor_enter_beat_hit_zone():
	beat_indicator.rect_scale = Vector2(1, 1)

func _on_Conductor_exit_beat_hit_zone():
	beat_indicator.rect_scale = Vector2(0.42, 0.42)

func _on_Conductor_exit_beat_close_zone():
	pass
	# beat_indicator.rect_scale = Vector2(0.4, 0.4)

func _on_Conductor_hit_result(hit_zone):
	# beat_label_frozen = !beat_label_frozen
	print(beat_num_label.text)
	beat_hit_zone_label.text = conductor.get_beat_hit_zone_string(hit_zone)
