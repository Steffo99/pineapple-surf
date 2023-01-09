extends Control



var scores_downloaded := false
var scores := [] as Array[Array]

var score_scene := preload("res://menu/score.tscn")

var is_uploading := false
var prev_mouse_mode := Input.MOUSE_MODE_VISIBLE


signal fetched_scores()


func _ready() -> void:
	_fetch_scores()


func upload_score(score: float):	
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
	], true, HTTPClient.METHOD_PUT, str(score))

	_fetch_scores(true)


func _fetch_scores(open_after: bool = false):
	const url = "https://arcade.steffo.eu/board/?board=test&offset=0&size=10"
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(result, response_code, headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		self.scores = (json as Array).map(func(element): return [element.name, element.score])
		
		for child in $Panel/VBoxContainer/ScrollContainer/ScoresVBox.get_children():
			child.queue_free()
		
		for score in self.scores:
			var score_sc = score_scene.instantiate()
			score_sc.get_node("HBoxContainer/Name").text = score[0]
			score_sc.get_node("HBoxContainer/Score").text = "%0.3f s" % score[1]
			$Panel/VBoxContainer/ScrollContainer/ScoresVBox.add_child(score_sc)
		
		self.scores_downloaded = true
		print(self.scores)
		emit_signal("fetched_scores")
		if open_after:
			show_scores()
			
		httpreq.queue_free()
	)
	httpreq.request(url)


func show_scores():
	prev_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true


func hide_scores():
	Input.set_mouse_mode(prev_mouse_mode)
	visible = false
