extends Control

signal play_pressed()

var scores_downloaded := false
var scores := [] as Array[Array]

var score_scene := preload("res://menu/score.tscn")

var is_uploading := false


func _ready() -> void:
	if Singletons.should_upload:
		# do request...
		_upload_score()
	_fetch_scores()


func _upload_score():
	Singletons.should_upload = false
	
	var url = "https://arcade.steffo.eu/score/?board=test&player=%s" % Singletons.username
	
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(result, response_code, headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		# { score, rank }
		print(json)
		self.is_uploading = false
		_fetch_scores(true)
		httpreq.queue_free()
	)
	self.is_uploading = true
	httpreq.request(url, [
		"Content-Type: application/json",
		"Accept: application/json",
		"Authorization: Bearer hahaha-ronaldinho-soccer"
	], true, HTTPClient.METHOD_PUT, str(Singletons.time))

	_fetch_scores(true)


func _fetch_scores(open_after: bool = false):
	const url = "https://arcade.steffo.eu/board/?board=test&offset=0&size=10"
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(result, response_code, headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		self.scores = (json as Array).map(func(element): return [element.name, element.score])
		
		for child in $ScoreboardContainer/Panel/VBoxContainer/ScrollContainer/ScoresVBox.get_children():
			child.queue_free()
		
		for score in self.scores:
			var score_sc = score_scene.instantiate()
			score_sc.get_node("HBoxContainer/Name").text = score[0]
			score_sc.get_node("HBoxContainer/Score").text = "%0.3f s" % score[1]
			$ScoreboardContainer/Panel/VBoxContainer/ScrollContainer/ScoresVBox.add_child(score_sc)
		
		self.scores_downloaded = true
		%ScoresButton.disabled = false
		print(self.scores)
		if open_after:
			$ScoreboardContainer.show_scores()
			
		httpreq.queue_free()
	)
	httpreq.request(url)


func play():
	print("Player ", Singletons.username, " started playing!")
	emit_signal("play_pressed")


func _on_name_input_text_changed():
	Singletons.username = $Content/Inputs/NameInput.text
	%PlayButton.disabled = false
