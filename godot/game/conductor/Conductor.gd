extends Node

onready var music_player : AudioStreamPlayer = get_node("MusicPlayer")

export(int) var bpm := 128
var seconds_per_beat : float = 60.0 / bpm

export(float, 0, 5) var time_until_first_beat := 0

export(float, 0, 1) var seconds_tolerance_hit : float = 0.16
export(float, 0, 1) var seconds_tolerance_close : float = seconds_tolerance_hit + 0.15

var tutorial_pattern : String = "0000001000100010"
var song_pattern : String = "00000010001000100010001000100010001000110010001100110011001000110011001000100010001000100010001000100011001000110011001100100011001100110010001100110011001000110011"
var hit_pattern : String = tutorial_pattern 

var beats_input_received = []

var tutorial_mode := true

onready var tutorial_metronome_sound_player = get_node("TutorialMetronomeSoundPlayer")
onready var tutorial_hit_sound_player = get_node("TutorialHitSoundPlayer")


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

func start_music():
	if not tutorial_mode:
		music_player.play()

func start_main_song():
	tutorial_mode = false
	hit_pattern = song_pattern
	beats_input_received = []
	music_player.play()

var last_beat_pos := -1
var current_beat_zone : int = BEAT_HIT_ZONE.MISS
var closest_beat_position := 0

signal enter_beat_hit_zone
signal exit_beat_hit_zone
signal enter_beat_close_zone
signal exit_beat_close_zone

signal hit_result(hit_zone)
signal tutorial_pattern_passed
signal main_song_passed

var passed_seconds_since_start : float = 0
var passed_seconds : float = 0

var passed_signal_sent = false

func _physics_process(delta):
	passed_seconds_since_start += delta
	passed_seconds += delta
	
	if passed_signal_sent:
		return
	
	if tutorial_mode and passed_seconds >= (len(hit_pattern) - 1) * seconds_per_beat:
		passed_seconds -= len(hit_pattern) * seconds_per_beat
		beats_input_received = []
		emit_signal("tutorial_pattern_passed")
	if not tutorial_mode and music_player.get_playback_position() >= (len(hit_pattern) - 1) * seconds_per_beat:
		passed_signal_sent = true
		emit_signal("main_song_passed")
	
	var track_position_seconds := passed_seconds
	if not tutorial_mode:
		track_position_seconds = music_player.get_playback_position()
		track_position_seconds += AudioServer.get_time_since_last_mix()
		track_position_seconds -= AudioServer.get_output_latency()
		track_position_seconds -= time_until_first_beat
	
	var beat_position = int(track_position_seconds / seconds_per_beat)
	closest_beat_position = round(track_position_seconds / seconds_per_beat)
	if closest_beat_position >= len(hit_pattern):
		closest_beat_position = 0
	
	var is_hit_beat : bool = hit_pattern[closest_beat_position] == "1"
	
	var closest_beat_seconds = (closest_beat_position * seconds_per_beat)
	
	var seconds_to_closest_beat = closest_beat_seconds - track_position_seconds
	
	if abs(seconds_to_closest_beat) < seconds_tolerance_hit:
		if current_beat_zone != BEAT_HIT_ZONE.HIT:
			current_beat_zone = BEAT_HIT_ZONE.HIT
			
			tutorial_hit_sound_player.stop()
			tutorial_metronome_sound_player.stop()
			
			if tutorial_mode and passed_seconds_since_start > 0.5:
				if is_hit_beat:
					tutorial_hit_sound_player.play()
				else:
					tutorial_metronome_sound_player.play()
			
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
	if event.is_action_pressed("beat_hit") and not closest_beat_position in beats_input_received:
		beats_input_received.append(closest_beat_position)
		emit_signal("hit_result", current_beat_zone)
