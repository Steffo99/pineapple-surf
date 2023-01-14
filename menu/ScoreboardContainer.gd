extends Control



var scores_downloaded := false
var scores := [] as Array[Array]

var score_scene := preload("res://menu/ScoreBox.tscn")

var is_uploading := false
var prev_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE


signal fetched_scores()


func upload_score(score: float):	
	var url = "https://arcade.steffo.eu/score/?board=ld52&player=%s" % Singletons.username
	
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(_result, _response_code, _headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		# { score, rank }
		print(json)
		self.is_uploading = false
		httpreq.queue_free()
		await get_tree().create_timer(1.75).timeout
		fetch_scores(true)
	)
	self.is_uploading = true
	httpreq.request(url, [
		"Content-Type: application/json",
		"Accept: application/json",
		"Authorization: Bearer pineapples-everywhere"
	], true, HTTPClient.METHOD_PUT, str(score))


func fetch_scores(open_after: bool = false):
	const url = "https://arcade.steffo.eu/board/?board=ld52&offset=0&size=10"
	var httpreq = HTTPRequest.new()
	add_child(httpreq)
	httpreq.connect("request_completed", func(_result, _response_code, _headers, body):
		var json = JSON.parse_string(body.get_string_from_utf8())
		self.scores = (json as Array).map(func(element): return [element.name, element.score])
		
		for child in $Panel/VBoxContainer/ScrollContainer/ScoresVBox.get_children():
			child.queue_free()
		
		for score in self.scores:
			var score_sc: ScoreBox = score_scene.instantiate()
			$Panel/VBoxContainer/ScrollContainer/ScoresVBox.add_child(score_sc)
			score_sc.username = score[0]
			score_sc.score = score[1]
		
		self.scores_downloaded = true
		emit_signal("fetched_scores")
		if open_after:
			show_scores()
			
		httpreq.queue_free()
	)
	httpreq.request(url)


func show_scores():
	print("Displaying scores...")
	prev_mouse_mode = Input.mouse_mode as Input.MouseMode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true


func hide_scores():
	print("Hiding scores...")
	Input.set_mouse_mode(prev_mouse_mode)
	visible = false
