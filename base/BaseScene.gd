extends Node
class_name BaseScene

## The scene manager is about to change the scene to the Island.
signal moving_to_island()

## The scene manager has changed the scene to the Island.
signal moved_to_island()

## The scene manager is about the change the scene back to the main menu.
signal moving_to_menu()

## The scene manager has changed the scene back to the main menu.
signal moved_to_menu()


## The currently loaded scene.
var current_scene: Node = null:
	get:
		return current_scene
	set(new_scene):
		if current_scene:
			current_scene.queue_free()
		current_scene = new_scene
		add_child(current_scene)


## Change the current scene to the Island.
func move_to_island():
	print("Starting game...")
	emit_signal("moving_to_island")
	current_scene = load("res://island/Island.tscn").instantiate()
	emit_signal("moved_to_island")

## Change the current scene to the main menu.
func move_to_menu():
	print("Going to the menu...")
	emit_signal("moving_to_menu")
	current_scene = load("res://menu/Menu.tscn").instantiate()
	current_scene.connect("play_pressed", move_to_island)
	emit_signal("moved_to_menu")


func _ready():
	# By default, standby in the menu
	move_to_menu()
