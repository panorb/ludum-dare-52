extends Node

onready var music_player : AudioStreamPlayer = get_node("MusicPlayer")

const BPM = 120
const SECONDS_PER_BEAT = 60.0 / BPM
const TIME_UNTIL_FIRST_BEAT = 0.034

func _ready():
	music_player.play()

var last_beat_pos = -1

func _physics_process(delta):
	var track_position = music_player.get_playback_position()
	track_position += AudioServer.get_time_since_last_mix()
	track_position -= AudioServer.get_output_latency()
	track_position -= TIME_UNTIL_FIRST_BEAT
	var beat_position = int(track_position / SECONDS_PER_BEAT)
	
	if beat_position > last_beat_pos:
		print(beat_position)
		last_beat_pos = beat_position
