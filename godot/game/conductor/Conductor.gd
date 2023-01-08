extends Node

onready var music_player : AudioStreamPlayer = get_node("MusicPlayer")

const BPM := 128
const SECONDS_PER_BEAT : float = 60.0 / BPM
# const TIME_UNTIL_FIRST_BEAT := 0
const TIME_UNTIL_FIRST_BEAT := 0.0

const SECONDS_TOLERANCE_HIT : float = 0.06
const SECONDS_TOLERANCE_CLOSE : float = SECONDS_TOLERANCE_HIT + 0.08

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
	print("hit: " + str(SECONDS_TOLERANCE_HIT))
	print("close: " + str(SECONDS_TOLERANCE_CLOSE))

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
	track_position_seconds -= TIME_UNTIL_FIRST_BEAT
	
	var beat_position = int(track_position_seconds / SECONDS_PER_BEAT)
	
	closest_beat_position = round(track_position_seconds / SECONDS_PER_BEAT)
	var closest_beat_seconds = TIME_UNTIL_FIRST_BEAT + (closest_beat_position * SECONDS_PER_BEAT)
	
	var seconds_to_closest_beat = closest_beat_seconds - track_position_seconds
	
	if abs(seconds_to_closest_beat) < SECONDS_TOLERANCE_HIT:
		if current_beat_zone != BEAT_HIT_ZONE.HIT:
			current_beat_zone = BEAT_HIT_ZONE.HIT
			emit_signal("enter_beat_hit_zone")
	elif abs(seconds_to_closest_beat) < SECONDS_TOLERANCE_CLOSE:
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
