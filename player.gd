extends KinematicBody

var path = []
var path_node = 0
var speed = 10
var begin = Vector3()
var end = Vector3()

onready var nav = get_parent()

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if path_node < path.size():
		var dir = path[path_node] - global_transform.origin
		if dir.length() < 1:
			path_node += 1
		else:
			move_and_slide(dir.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _unhandled_input(event):

	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		print("FOO")
		var raylength = 200
		var camera = get_node("../../CameraBase/Camera")
		var rayfrom = camera.project_ray_origin(event.position)
		var rayto = rayfrom + camera.project_ray_normal(event.position) * raylength
		var p = nav.get_closest_point_to_segment(rayfrom, rayto)
		
		begin = nav.get_closest_point(get_translation())
		end = p
		move_to(p)
