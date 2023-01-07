extends Node

enum TERNARY {
  TRUE,
  FALSE,
  NONE
}

static func bool_to_sign(b: bool):
	return 1 if b else -1

static func map(v: float, i_start: float, i_end: float, f_start: float, f_end: float, clamped := false) -> float:
	var output := remap(v, i_start, i_end, f_start, f_end)
	return clamp(output, f_start, f_end) if clamped else output

static func vec3_horizontal(v: Vector3) -> Vector2:
	return vec3_remove_axis(v, Vector3.AXIS_Y)

static func vec3_remove_axis(v: Vector3, axis : int = Vector3.AXIS_Y) -> Vector2:
	match axis:
		Vector3.AXIS_X: return Vector2(v.y, v.z)
		Vector3.AXIS_Y: return Vector2(v.x, v.z)
		Vector3.AXIS_Z: return Vector2(v.x, v.y)
	return Vector2.ZERO

static func vec3_deg2rad(v: Vector3):
	return Vector3(deg_to_rad(v.x), deg_to_rad(v.y), deg_to_rad(v.z))

static func vec2_deg2rad(v: Vector2):
	return Vector2(deg_to_rad(v.x), deg_to_rad(v.y))
  
#static func round_vec2(v : Vector2, digits : int = 3):
#	return Vector2(stepify(v.x, pow(10, -digits)), stepify(v.y, pow(10, -digits)))
  
static func get_global_pos(obj: Node3D) -> Vector3:
	return obj.global_transform.origin
  
static func get_dir_vector(obj: Node3D, axis := Vector3.AXIS_Z) -> Vector3:
	match axis:
		Vector3.AXIS_X: return obj.transform.basis.x
		Vector3.AXIS_Y: return obj.transform.basis.y
		Vector3.AXIS_Z: return obj.transform.basis.z
	return Vector3.ZERO
  
static func delete_children(node):
	for n in node.get_children():
		n.queue_free()

static func log_line(obj: Node, msg: String):
	var time = Time.get_time_dict_from_system()
	var time_str = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	print("@%s [%s]: %s" % [time_str, obj.name, msg])
