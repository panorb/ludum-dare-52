extends Node

onready var music_player : AudioStreamPlayer = get_node("MusicPlayer")

const BPM := 120
const SECONDS_PER_BEAT : float = 60.0 / BPM
const TIME_UNTIL_FIRST_BEAT := 0
# const TIME_UNTIL_FIRST_BEAT := 0.034

const SECONDS_TOLERANCE_HIT : float = (SECONDS_PER_BEAT / 5) * 1
const SECONDS_TOLERANCE_CLOSE : float = SECONDS_TOLERANCE_HIT * 2

enum BEAT_HIT_ZONE {
	MISS
	TOO_EARLY,
	HIT,
	TOO_LATE
}

func _ready():
	music_player.play()
	print("hit: " + str(SECONDS_TOLERANCE_HIT))
	print("close: " + str(SECONDS_TOLERANCE_CLOSE))

var last_beat_pos := -1
var current_beat_zone : int = BEAT_HIT_ZONE.MISS

signal enter_beat_hit_zone
signal exit_beat_hit_zone
signal enter_beat_close_zone
signal exit_beat_close_zone

func _physics_process(delta):
	var track_position_seconds = music_player.get_playback_position()
	track_position_seconds += AudioServer.get_time_since_last_mix()
	track_position_seconds -= AudioServer.get_output_latency()
	track_position_seconds -= TIME_UNTIL_FIRST_BEAT
	
	var beat_position = int(track_position_seconds / SECONDS_PER_BEAT)
	
	var closest_beat_position = round(track_position_seconds / SECONDS_PER_BEAT)
	var closest_beat_seconds = TIME_UNTIL_FIRST_BEAT + (closest_beat_position * SECONDS_PER_BEAT)
	
	var seconds_to_closest_beat = closest_beat_seconds - track_position_seconds
	
	if abs(seconds_to_closest_beat) < SECONDS_TOLERANCE_HIT:
		if current_beat_zone != BEAT_HIT_ZONE.HIT:
			emit_signal("enter_beat_hit_zone")
			current_beat_zone = BEAT_HIT_ZONE.HIT
	elif abs(seconds_to_closest_beat) < SECONDS_TOLERANCE_CLOSE:
		if current_beat_zone == BEAT_HIT_ZONE.MISS:
			emit_signal("enter_beat_close_zone")
			current_beat_zone = BEAT_HIT_ZONE.TOO_EARLY
		if current_beat_zone == BEAT_HIT_ZONE.HIT:
			emit_signal("exit_beat_hit_zone")
			current_beat_zone = BEAT_HIT_ZONE.TOO_LATE
	elif current_beat_zone == BEAT_HIT_ZONE.TOO_LATE:
		emit_signal("exit_beat_close_zone")
		current_beat_zone = BEAT_HIT_ZONE.MISS
	
	if beat_position > last_beat_pos:
		# print(beat_position)
		last_beat_pos = beat_position
