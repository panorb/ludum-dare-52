extends Control

# HTML Focus Capture & Platform Warnings
# Stops the player from loading the game if unsupported platforms are used
# If supported platforms are used: Set to fullscreen, start loading in Startup.gd

# ------------------------------------------------------------------------------

signal valid # Platform is valid, Master.gd loads logo_animation
signal clicked # Button is clicked

const fade_out_animation = 0.2

const MESSAGE = {
	"FirefoxLinux" : 
		"This game does not behave as intended when you use " + \
		"Firefox on Linux. \nTo play this game on Linux, " + \
		"please use a chromium-based browser.",
	
	"Mobile" : 
		"This game is not designed for mobile devices, please use a " + \
		"desktop machine instead."
}

onready var message: Label = $CenterContainer/VBoxContainer/Message
onready var warning: Label = $CenterContainer/VBoxContainer/Warning
onready var background: ColorRect = $Background
onready var continue_button: Button = $ContinueButton
onready var mouse_icon: TextureRect = $MouseIcon


# ------------------------------------------------------------------------------

func _ready() -> void:
	# Hide messages
	message.hide()
	warning.hide()
	continue_button.hide()
	mouse_icon.hide()
	
	# Stupid stuff (Platform checks)
	if OS.has_feature('JavaScript'):
		var browser : String = JavaScript.eval("""navigator.userAgent;""", true)
		if "Firefox" in browser and "X11" in browser:
			show_warning("FirefoxLinux")
			return
		
		if "Android" in browser or "iOS" in browser:
			show_warning("Mobile")
			return
	
	continue_button.show()
	mouse_icon.show()

	emit_signal("valid")

# ------------------------------------------------------------------------------

# Show warning. Called if a platform is unsupported
func show_warning(err : String):
	message.show()
	warning.show()
	message.text = MESSAGE[err]
	
	var tween = create_tween()
	tween.tween_property(background, "color", Palette.red, 1.5)

# Continue Button pressed, emit "clicked" signal, animate fade out
# and queue free.
func _on_ContinueButton_pressed() -> void:
	emit_signal("clicked")
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_out_animation)
	
	yield(get_tree().create_timer(fade_out_animation), "timeout")
	self.queue_free()
