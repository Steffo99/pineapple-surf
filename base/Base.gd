extends Node


var current_scn: Node = null
func change_scene(path: String):
	var res: Resource = load(path)
	var scn: Node = res.instantiate()
	add_child(scn)
	if current_scn:
		current_scn.queue_free()
	current_scn = scn


func start_game():
	print("Starting game...")
	Singletons.score = 0
	change_scene("res://island/Island.tscn")


func goto_menu():
	print("Going to the menu...")
	change_scene("res://menu/Menu.tscn")
	current_scn.connect("play_pressed", start_game)


func _ready():
	goto_menu()
