extends Node

onready var music_player : AudioStreamPlayer = get_node("MusicPlayer")

export(int) var bpm := 128
var seconds_per_beat : float = 60.0 / bpm

export(float, 0, 5) var time_until_first_beat := 0

export(float, 0, 1) var seconds_tolerance_hit : float = 0.14
export(float, 0, 1) var seconds_tolerance_close : float = seconds_tolerance_hit + 0.08

var hit_pattern : String = "0010001000100010001000100010001000110010001100110011001000110011001000100010001000100010001000100011001000110011001100100011001100110010001100110011001000110011"

enum BEAT_HIT_ZONE {
	MISS
	TOO_EARLY,
	HIT,
	TOO_LATE
}

func get_beat_hit_zone_string(hit_zone):
	match hit_zone:
		0:
			return "MISS"
		1:
			return "TOO_EARLY"
		2:
			return "HIT"
		3:
			return "TOO_LATE"

func _ready():
	music_player.play()
	print("hit: " + str(seconds_tolerance_hit))
	print("close: " + str(seconds_tolerance_close))

var last_beat_pos := -1
var current_beat_zone : int = BEAT_HIT_ZONE.MISS
var closest_beat_position := 0

signal enter_beat_hit_zone
signal exit_beat_hit_zone
signal enter_beat_close_zone
signal exit_beat_close_zone

signal hit_result(hit_zone)

func _physics_process(delta):
	var track_position_seconds = music_player.get_playback_position()
	track_position_seconds += AudioServer.get_time_since_last_mix()
	track_position_seconds -= AudioServer.get_output_latency()
	track_position_seconds -= time_until_first_beat
	
	var beat_position = int(track_position_seconds / seconds_per_beat)
	
	closest_beat_position = round(track_position_seconds / seconds_per_beat)
	if closest_beat_position > len(hit_pattern) or hit_pattern[closest_beat_position] == "0":
		return
	
	var closest_beat_seconds = (closest_beat_position * seconds_per_beat)
	
	var seconds_to_closest_beat = closest_beat_seconds - track_position_seconds
	
	if abs(seconds_to_closest_beat) < seconds_tolerance_hit:
		if current_beat_zone != BEAT_HIT_ZONE.HIT:
			current_beat_zone = BEAT_HIT_ZONE.HIT
			emit_signal("enter_beat_hit_zone")
	elif abs(seconds_to_closest_beat) < seconds_tolerance_close:
		if seconds_to_closest_beat < 0 and current_beat_zone != BEAT_HIT_ZONE.TOO_LATE:
			current_beat_zone = BEAT_HIT_ZONE.TOO_LATE
			emit_signal("exit_beat_hit_zone")
		elif seconds_to_closest_beat >= 0 and current_beat_zone != BEAT_HIT_ZONE.TOO_EARLY:
			current_beat_zone = BEAT_HIT_ZONE.TOO_EARLY
			emit_signal("enter_beat_close_zone")
	elif current_beat_zone == BEAT_HIT_ZONE.TOO_LATE:
		current_beat_zone = BEAT_HIT_ZONE.MISS
		emit_signal("exit_beat_close_zone")
	
	if beat_position > last_beat_pos:
		# print(beat_position)
		last_beat_pos = beat_position

func _input(event):
	if event.is_action_pressed("beat_hit"):
		print(current_beat_zone)
		emit_signal("hit_result", current_beat_zone)
