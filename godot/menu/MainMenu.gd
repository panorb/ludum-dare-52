extends Control

onready var start_button = get_node("%StartButton")
onready var quit_button = get_node("%QuitButton")

signal start_button_pressed

func _ready():
	quit_button.visible = OS.get_name() != "HTML5"
	start_button.connect("pressed", self, "_on_StartButton_pressed")

func _on_StartButton_pressed():
	emit_signal("start_button_pressed")
