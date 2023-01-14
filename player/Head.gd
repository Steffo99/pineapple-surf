extends Node3D

var xNoise: FastNoiseLite
var yNoise: FastNoiseLite

var targetRot := Vector3.ZERO
var eventRot := Vector2.ZERO
var noiseRot := Vector3.ZERO
var noiseCount := 0
@export var noiseAmp := 10.0
@export var noiseFreq := 100.0
@onready var camera = $Viewport/CameraViewportContainer/GameViewport/Camera

var mouseRot := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xNoise = FastNoiseLite.new()
	yNoise = FastNoiseLite.new()
	xNoise.seed = 0
	yNoise.seed = 1


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseRot = event.relative
		

func _physics_process(_delta):
	camera.global_transform = global_transform
