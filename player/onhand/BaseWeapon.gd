extends Node3D
class_name BaseWeapon

enum WeaponSlot {
	ONE,
	TWO,
	THREE
}

enum AmmoType {
	NONE,
	SINGLE
}

@export_range(0,0.002) var MOUSE_MOVEMENT_BOB_AMOUNT := 0.002

var player: Player
var weaponSlot: WeaponSlot = WeaponSlot.ONE
var ammoType: AmmoType = AmmoType.NONE
var last_mouse_movement := Vector2.ZERO
var mouse_movements := [Vector2.ZERO] as Array[Vector2]

func on_switch_in():
	pass

func on_switch_out():
	pass

func bob_weapon(node: Node3D, delta: float):
	if len(self.mouse_movements) >= 5:
		self.mouse_movements.pop_front()
	self.mouse_movements.push_back(Vector2(
		self.last_mouse_movement.y * 0.05,
		self.last_mouse_movement.x * 0.05
	))
	
	var avg_mvmt = self.mouse_movements \
		.reduce(func(accum, number): return accum + number) \
		/ len(self.mouse_movements) as Vector2
	node.position = Vector3.ZERO.lerp(Vector3(
		-avg_mvmt.y,
		avg_mvmt.x,
		0,
	), MOUSE_MOVEMENT_BOB_AMOUNT / delta)
	
	self.last_mouse_movement = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.last_mouse_movement = event.relative
		
