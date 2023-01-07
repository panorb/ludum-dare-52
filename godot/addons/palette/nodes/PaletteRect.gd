tool
class_name PaletteRect
extends ColorRect

# A ColorRect with extra functionality
# Exports all palette colours

# ------------------------------------------------------------------------------

export(Palette.COLOURS) var colour setget colour_changed


func colour_changed(new_colour):
	self.color = Palette.colour_dict[new_colour]
	
	colour = new_colour
