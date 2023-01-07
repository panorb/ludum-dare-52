tool
class_name PaletteLabel
extends Label

# A Label with with palette functionality

# ------------------------------------------------------------------------------

export(Palette.COLOURS) var colour setget colour_changed


func colour_changed(new_colour):
	self.set("custom_colors/font_color", Palette.colour_dict[new_colour])

	colour = new_colour
