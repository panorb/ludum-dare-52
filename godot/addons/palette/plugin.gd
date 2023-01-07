tool
extends EditorPlugin

# Palette plugin
# - Adds palette script to autoload
# - Loads palette colours to editor colour picker


func _enter_tree() -> void:
	# Add palette script to autoloads
	add_autoload_singleton("Palette", "res://addons/palette/Palette.gd")
	
	# Add palette to Editor ColorPicker
	var palette = preload("res://addons/palette/Palette.gd")
	var ep = EditorPlugin.new()
	ep.get_editor_interface() \
		.get_editor_settings() \
		.set_project_metadata("color_picker", "presets", palette.colour_array)
	ep.free()

func _exit_tree() -> void:
	remove_autoload_singleton("Palette")
	
	# Doesn't work for some reason
#	var empty_array = [Color("#FFFFFF")]
#	var ep = EditorPlugin.new()
#	ep.get_editor_interface() \
#		.get_editor_settings() \
#		.set_project_metadata("color_picker", "presets", empty_array)
#	ep.free()
