extends KinematicBody

var path = []
var path_node = 0
var speed = 10
var begin = Vector3()
var end = Vector3()
var draw_path = true

onready var nav = get_parent()

var m = SpatialMaterial.new()
var outline = SpatialMaterial.new()

func _ready():
	set_process_input(true)
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white
	
	outline.flags_unshaded = true
	outline.params_cull_mode = SpatialMaterial.CULL_FRONT
	outline.params_grow = true
	outline.params_grow_amount = 0.05
	outline.albedo_color = Color.green
	var mesh = get_node("MeshInstance")
	mesh.add_next_pass(outline)

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
	
	if draw_path:
		var im = get_node("../../draw")
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(begin)
		im.add_vertex(end)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in path:
			im.add_vertex(x)
		im.end()

func _unhandled_input(event):

	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var raylength = 200
		var camera = get_node("../../CameraBase/Camera")
		var rayfrom = camera.project_ray_origin(event.position)
		var raydir = rayfrom + camera.project_ray_normal(event.position) * raylength
		var p = nav.get_closest_point_to_segment(rayfrom, raydir)
		
		begin = nav.get_closest_point(get_translation())
		end = p
		move_to(p)
		print("Walking to: ", end)
