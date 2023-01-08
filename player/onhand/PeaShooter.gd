extends BaseWeapon
class_name PeaShooter

const FIRE_RATE  := 0.15
var   last_fired := 0
var   remaining  := 10

@onready var ray = $RayCast3D


func _init() -> void:
	self.weaponSlot = WeaponSlot.ONE
	self.ammoType   = AmmoType.SINGLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	
	if Input.is_action_just_pressed("fire") and current_time > (last_fired + FIRE_RATE*1000):
		if remaining > 0:
			shoot()


func shoot() -> void:
	last_fired = Time.get_ticks_msec()
#	audio_player.play()
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("shoot")
	
	if ray.is_colliding():
		var normal = ray.get_collision_normal() as Vector3
		var point = ray.get_collision_point() as Vector3
		var object = ray.get_collider() as Node3D
#		decalInstance.position = point
#		object.add_child(decalInstance)
	else:
		# We should show a particle fx where the seed bouced off
		pass
	
	remaining -= 1
