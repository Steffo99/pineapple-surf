extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 2.25

const MAX_AIR_WISH_SPEED = 20
const AIR_ACCELERATE = 100		# Hu/39.97

@export var viewport_resolution: Vector2 = Vector2(852, 420)

@onready var head: Node3D = $Head
@onready var camera: Camera3D = head.get_node("Viewport/CameraViewportContainer/GameViewport/Camera")
@onready var vport: SubViewport = head.get_node("Viewport/CameraViewportContainer/GameViewport")
@onready var aim_raycast: RayCast3D = head.get_node("RayCast3D")
@onready var torch: SpotLight3D = head.get_node("Torch")

@onready var OnHand = head.get_node("OnHand")
@onready var active_weapon: BaseWeapon:
	get: return OnHand.active_weapon

# DEBUG NODES
@onready var debug_speed_label = $HUD/Speed_Label

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
	vport.size = viewport_resolution

func _process(delta):
	pass

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

	
	# Apply camera effects
	var camera_yaw := 0
	var current_speed := _get_2d_velocity().length()
	if is_on_floor() and current_speed > 0:
		camera_yaw = -clamp(_get_2d_velocity().length() * input_dir.x, -25, 25)
	else:
		camera_yaw = 0
	
	self.camera.global_transform = self.head.global_transform
	
#	camera.rotation.z = move_toward(
#		0,
#		camera_yaw, 
#		delta
#	) * 2.5
	
	debug_speed_label.text = "%0.2f" % current_speed
	
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


func wall_running() -> bool:
	if is_on_wall_only():
		if Input.is_action_pressed("jump"):
			var wall_normal := get_wall_normal()
			var bas = transform.basis * velocity
			velocity.y /= 2
			return true
	return false


func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
	
	if Input.is_action_just_pressed("toggle_torch"):
		torch.visible = !torch.visible
	
	if event is InputEventMouseMotion:
		var vec = event.relative
		self.mouse_movement = Vector2(vec.y / 10, vec.x / 10)
