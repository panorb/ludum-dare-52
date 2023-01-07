extends Node

# AUTOLOAD SCRIPT
# This script holds all colours from: https://lospec.com/palette-list/sweetie-16
# for short & easy access via code

# ------------------------------------------------------------------------------

# COLOURS
# Gray-scale
const black 	= Color("#1a1c2c")
const charcoal 	= Color("#333c57")
const gray 	 	= Color("#566c86")
const pewter 	= Color("#94b0c2")
const white 	= Color("#f4f4f4")

# Reds
const purple 	= Color("#5d275d")
const red 		= Color("#b13e53")
const orange 	= Color("#ef7d57")
const yellow 	= Color("#ffcd75")

# Greens
const cyan 	 	= Color("#257179")
const green 	= Color("#38b764")
const lime 		= Color("#a7f070")

# Blues
const royal 	= Color("#29366f")
const blue 		= Color("#3b5dc9")
const sky 		= Color("#41a6f6")
const neonblue 	= Color("#73eff7")

# ------------------------------------------------------------------------------

# COLOURS ENUM
enum COLOURS {
	BLACK,
	CHARCOAL,
	GRAY,
	PEWTER,
	WHITE,
	PURPLE,
	RED,
	ORANGE,
	YELLOW,
	CYAN,
	GREEN,
	LIME,
	ROYAL,
	BLUE,
	SKY,
	NEONBLUE
}

# COLOUR ARRAY
const colour_array = [
	black, charcoal, gray, pewter,
	white, purple, red, orange, 
	yellow, cyan, green, lime,
	royal, blue, sky, neonblue
	]

# COLOUR DICTIONARY
const colour_dict := {
	COLOURS.BLACK : black,
	COLOURS.CHARCOAL : charcoal,
	COLOURS.GRAY : gray,
	COLOURS.PEWTER : pewter,
	COLOURS.WHITE : white,
	COLOURS.PURPLE : purple,
	COLOURS.RED : red,
	COLOURS.ORANGE : orange,
	COLOURS.YELLOW : yellow,
	COLOURS.CYAN : cyan,
	COLOURS.GREEN : green,
	COLOURS.LIME : lime,
	COLOURS.ROYAL : royal,
	COLOURS.BLUE : blue,
	COLOURS.SKY : sky,
	COLOURS.NEONBLUE : neonblue
}
