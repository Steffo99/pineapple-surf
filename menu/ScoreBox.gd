extends MarginContainer
class_name ScoreBox


@onready var name_label: Label = $HBoxContainer/Name
@onready var score_label: Label = $HBoxContainer/Score


var username: String:
	get: 
		return username
	set(value):
		username = value
		name_label.text = value
		if value == Singletons.username:
			name_label.add_theme_color_override("font_color", Color.YELLOW)
			score_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			name_label.remove_theme_color_override("font_color")
			score_label.remove_theme_color_override("font_color")


var score: float: 
	get:
		return score
	set(value):
		score = value
		score_label.text = "%0.3f s" % value
