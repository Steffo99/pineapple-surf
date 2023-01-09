extends Node3D

enum GUN_STATE {
	ACTIVE,
	SWITCHING,
	INACTIVE
}

var active_weapon: BaseWeapon

signal weapon_switched(weapon: BaseWeapon)

var player: Player:
	get:
		return player
	set(p):
		player = p
		for weapon in weapons:
			weapon.player = player


var weapons: Array = [
	load("res://player/onhand/PeaShooter.tscn").instantiate()
	# load("res://Player/Weapons/Arm.tscn").instantiate(),
	# load("res://Player/Weapons/ak47.tscn").instantiate(),
]


func _ready() -> void:
	self._switch_weapon(BaseWeapon.WeaponSlot.ONE)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("slot1"):
		_switch_weapon(BaseWeapon.WeaponSlot.ONE)
	# elif Input.is_action_just_pressed("slot2"):
	# 	_switch_weapon(BaseWeapon.WeaponSlot.TWO)
	# elif Input.is_action_just_pressed("slot3"):
	# 	_switch_weapon(BaseWeapon.WeaponSlot.THREE)


func _switch_weapon(slot: BaseWeapon.WeaponSlot):
	# TODO: play anim ecc ecc
	# Try to get the correct weapon per the given `slot`
	for weapon in weapons:
		if weapon.weaponSlot == slot:
			# Remove active weapon
			if active_weapon:
				active_weapon.on_switch_out()
				remove_child(active_weapon)
			
			# Add new weapon
			add_child(weapon)
			active_weapon = weapon
			active_weapon.on_switch_in()
			emit_signal("weapon_switched", weapon)
			break
