extends BaseWeapon
class_name PeaShooter

const FIRE_RATE  := 0.15
var   last_fired := 0
var   remaining  := 10

@onready var ray = $RayCast3D
@onready var audio_player := $AudioStreamPlayer3D
# FIXME: use singleton class here as well
@onready var croptiles_container: Node3D = get_tree().root.find_child("CropTiles", true, false)
var croptile = preload("res://island/CropTile.tscn")


func _init() -> void:
	self.weaponSlot = WeaponSlot.ONE
	self.ammoType   = AmmoType.SINGLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	
	if Input.is_action_just_pressed("fire") and current_time > (last_fired + FIRE_RATE*1000):
		if remaining > 0:
			shoot()


func shoot() -> void:
	last_fired = Time.get_ticks_msec()
	audio_player.play()
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("shoot")
	
	if ray.is_colliding():
		var _normal = ray.get_collision_normal() as Vector3
		var _point = ray.get_collision_point() as Vector3
		var _object = ray.get_collider() as Node3D
		try_placing_seed(ray)
#		decalInstance.position = point
#		object.add_child(decalInstance)
	else:
		# We should show a particle fx where the seed bouced off
		pass
	
	remaining -= 1


func try_placing_seed(ray: RayCast3D) -> bool:
	var point = ray.get_collision_point() as Vector3
	var normal = ray.get_collision_normal() as Vector3
	var coll = ray.get_collider() as CollisionObject3D
	if normal != Vector3(0,1,0):
		print("Not horizontal, no plant for you :<")
		return false
		
	if coll.collision_layer == 0b10000:
		print("Colliding with planted seed, not planting again")
		return false
	
	var correct_point = point.floor()
	var crop = croptile.instantiate() as CropTile
	crop.position = correct_point
	croptiles_container.add_child(crop)
	crop.plant()
	
	return true
