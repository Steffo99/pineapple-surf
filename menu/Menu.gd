extends Control

signal play_pressed()


func play():
	print("Player ", Singletons.username, " started playing!")
	emit_signal("play_pressed")


func _on_name_input_text_changed():
	Singletons.username = $Content/Inputs/NameInput.text
	%PlayButton.disabled = false


func _on_fetched_scores():
	$Content/Buttons/HBoxContainer/ScoresButton.disabled = false
	$Content/Buttons/HBoxContainer/ScoresButton.connect("pressed", $"/root/BaseScene/ScoreboardContainer".show_scores)


func _ready():
	print("Connecting fetched_scores to the Scores button")
	$"/root/BaseScene/ScoreboardContainer".connect("fetched_scores", _on_fetched_scores)
	$"/root/BaseScene/ScoreboardContainer".fetch_scores(false)
