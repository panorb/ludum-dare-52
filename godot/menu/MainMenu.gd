extends Control


onready var quit_button = get_node("%QuitButton")

func _ready():
	quit_button.visible = OS.get_name() != "HTML5"
