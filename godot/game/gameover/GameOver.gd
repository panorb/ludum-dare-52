extends Control


func set_game_over_text(text : String):
	get_node("%GameOverText").text = text

func set_hit_percentage(percentage : int):
	get_node("%PercentageLabel").text = str(percentage) + "% hit"
