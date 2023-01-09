extends Control

signal play_pressed()

var scores_downloaded := false
var scores := [] as Array[Array]

var score_scene := preload("res://menu/score.tscn")

var is_uploading := false
var should_open_scores_after_upload := false


func _ready() -> void:
	if Singletons.should_upload:
		# do request...
		_upload_score()
		self.should_open_scores_after_upload = true
	_fetch_scores()


func _upload_score():
	if not (Singletons.should_upload and len(Singletons.name) > 0 and Singletons.time):
		return
	
	var url = "https://arcade.steffo.eu/score/?board=ld52&player=%s" % Singletons.name
	
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(result, response_code, headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		# { score, rank }
		self.is_uploading = false
		_fetch_scores(true)
		httpreq.queue_free()
	)
	self.is_uploading = true
	httpreq.request(url, [
		"Content-Type: application/json"
	], true, HTTPClient.METHOD_PUT, str(Singletons.time))


func _fetch_scores(open_after: bool = false):
	const url = "https://arcade.steffo.eu/board/?board=ld52&offset=0&size=10"
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(result, response_code, headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		self.scores = (json as Array).map(func(element): return [element.name, element.score])
		
		for child in %ScoresVBox.get_children():
			child.queue_free()
		
		for score in self.scores:
			var score_sc = score_scene.instantiate()
			score_sc.get_node("HBoxContainer/Name").text = score[0]
			score_sc.get_node("HBoxContainer/Score").text = "%d" % score[1]
			%ScoresVBox.add_child(score_sc)
		
		self.scores_downloaded = true
		%ScoresButton.disabled = false
		print(self.scores)
		if open_after:
			open_scores()
		httpreq.queue_free()
	)
	httpreq.request(url)


func play():
	print("Play button was pressed.")
	emit_signal("play_pressed")


func open_scores():
	$ScoreboardContainer.visible = true

func close_scores():
	$ScoreboardContainer.visible = false


func _on_text_edit_text_changed():
	Singletons.username = $Content/Inputs/NameInput.text
	%PlayButton.disabled = false
