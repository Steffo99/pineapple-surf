extends Control

signal play_pressed()


var username_regex


var username: String:
	get:
		return Singletons.username
	set(value):
		value = value.strip_escapes()
		value = value.to_lower()
		value = username_regex.sub(value, "-", true)
		Singletons.username = value
		var caret = $Content/Inputs/NameInput.caret_column
		$Content/Inputs/NameInput.text = value
		$Content/Inputs/NameInput.caret_column = caret
		%PlayButton.disabled = len(value) <= 0


func play():
	print("Player ", Singletons.username, " started playing!")
	emit_signal("play_pressed")


func _on_name_input_text_changed(new_text):
	if username != $Content/Inputs/NameInput.text:
		username = $Content/Inputs/NameInput.text


func _on_fetched_scores():
	$Content/Buttons/HBoxContainer/ScoresButton.disabled = false
	$Content/Buttons/HBoxContainer/ScoresButton.connect("pressed", $"/root/BaseScene/ScoreboardContainer".show_scores)


func _ready():
	username_regex = RegEx.new()
	username_regex.compile("[^a-z0-9]")
	$"/root/BaseScene/ScoreboardContainer".connect("fetched_scores", _on_fetched_scores)
	$"/root/BaseScene/ScoreboardContainer".fetch_scores(false)
