extends Node2D

onready var progress_bar : AnimatedSprite = get_node("ProgressBar")
onready var button : AnimatedSprite = get_node("Button")

export(bool) var progress_bar_visible : bool setget _set_progress_bar_visible, _get_progress_bar_visible
export(bool) var button_pressed : bool setget _set_button_pressed, _get_button_pressed
export(int, 0, 3) var progress_num : int setget _set_progress_num, _get_progress_num

func _set_progress_bar_visible(new_val : bool) -> void:
	progress_bar.visible = new_val

func _get_progress_bar_visible() -> bool:
	return progress_bar.visible

func _set_button_pressed(new_val : bool) -> void:
	button.frame = int(new_val)

func _get_button_pressed() -> bool:
	return bool(button.frame)

func _set_progress_num(new_val : int) -> void:
	progress_bar.frame = new_val

func _get_progress_num() -> int:
	return progress_bar.frame
