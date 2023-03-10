extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 5 # 2.25

const MAX_AIR_WISH_SPEED = 20
const AIR_ACCELERATE = 100		# Hu/39.97

@export var viewport_resolution: Vector2 = Vector2(852, 420)

@onready var head: Node3D = $Head
@onready var camera: Camera3D = head.get_node("Viewport/CameraViewportContainer/GameViewport/Camera")
@onready var vport: SubViewport = head.get_node("Viewport/CameraViewportContainer/GameViewport")
@onready var gun_vport: SubViewport = $HUD/SubViewportContainer/SubViewport
@onready var aim_raycast: RayCast3D = head.get_node("RayCast3D")
@onready var initial_position: Vector3 = position
@onready var initial_rotation: Vector3 = rotation

@onready var OnHand = head.get_node("OnHand")
@onready var active_weapon: BaseWeapon:
	get: return OnHand.active_weapon

@onready var ammo_label: Label = $HUD/AmmoLabel
@onready var fruit_label: Label = $HUD/PineappleLabel
@onready var speed_label: Label = $HUD/SpeedLabel
@onready var timer_label: Label = $HUD/TimerLabel

@onready var temple: Temple = $"/root/BaseScene/Island/Temple"

var collected_fruit: int = 0:
	get:
		return collected_fruit
	set(value):
		collected_fruit = value
		fruit_label.text = "%d harvested" % collected_fruit

var last_frame_input_data: PlayerInputData = PlayerInputData.new()
var input_data: PlayerInputData = PlayerInputData.new()

var mouse_movement: Vector2 = Vector2.ZERO
var mouse_enabled: bool = true

var last_ground_velocity: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# ===== UTILS =====
func _get_2d_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OnHand.player = self
	Singletons.player = self
	vport.size = viewport_resolution
	gun_vport.size = viewport_resolution

func _physics_process(delta):
	last_frame_input_data = input_data
	input_data = PlayerInputData.new()
	
	if mouse_movement:
		self.rotate_y(self.mouse_movement.y * -1 * delta * MOUSE_SENSITIVITY)
		var x_rotation = self.mouse_movement.x * -1 * delta * MOUSE_SENSITIVITY
		head.rotation.x = clamp(head.rotation.x + x_rotation, deg_to_rad(-90), deg_to_rad(90))
	self.mouse_movement = Vector2.ZERO
	
	var jumping = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		last_ground_velocity = Vector2(velocity.x, velocity.z)

	# Handle Jump
	if Input.is_action_pressed("jump") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var based = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var direction = based.normalized()
	if is_on_floor() and not jumping:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		_air_accelerate(direction, based.length(), AIR_ACCELERATE, delta)
	
	if active_weapon and active_weapon.ammoType != BaseWeapon.AmmoType.NONE:
		ammo_label.show()
		if active_weapon is PeaShooter:
			ammo_label.text = "%d seeds" % active_weapon.remaining
	else:
		ammo_label.hide()
	
	move_and_slide()


func _air_accelerate(wish_dir: Vector3, wish_speed: float, airaccelerate: float, delta_time: float):
	var addspeed: float = 0
	var accelspeed: float = 0
	var currentspeed: float = 0
	
	if wish_speed > MAX_AIR_WISH_SPEED:
		wish_speed = MAX_AIR_WISH_SPEED
	
	currentspeed = velocity.dot(wish_dir)
	
	addspeed = wish_speed - currentspeed
	if addspeed <= 0:
		return
	
	accelspeed = airaccelerate * delta_time * wish_speed
	
	if accelspeed > addspeed:
		accelspeed = addspeed
	
	velocity += accelspeed * wish_dir


func _process(_delta: float) -> void:
	speed_label.text = "%0.2f km/h" % velocity.length()
	if temple != null:
		timer_label.text = "%0.3f s" % temple.time
	else:
		timer_label.text = ""


func _input(event):
	if event.is_action_pressed("respawn"):
		respawn()

	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		$"/root/BaseScene".move_to_menu()
	
	if event is InputEventMouseMotion:
		var vec = event.relative
		self.mouse_movement = Vector2(vec.y / 10, vec.x / 10)


func respawn():
	position = initial_position
	rotation = initial_rotation
	velocity = Vector3.ZERO
