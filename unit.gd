extends KinematicBody

var speed = 10

var path = []
var path_node = 0
var begin = Vector3()
var end = Vector3()
var draw_path = true

onready var navmesh = get_parent()

#var m = SpatialMaterial.new()
var mat = preload("unit_material.tres").duplicate(true)


func _ready():
#	m.flags_unshaded = true
#	m.flags_use_point_size = true
#	m.albedo_color = Color.white
	self.connect("mouse_entered", self, "_on_unit_mouse_entered" )
	self.connect("mouse_exited", self, "_on_unit_mouse_exited" )
	
	var mesh = get_node("MeshInstance")
	mesh.set_surface_material(0, mat)
	mat.next_pass.set_shader_param("color", Color(0.0, 1.0, 0.0, 1.0))
	mat.next_pass.set_shader_param("outline_thickness", 0.08)
	mat.next_pass.set_shader_param("enable", false)
	
	
func _physics_process(delta):
	if path_node < path.size():
		var dir = path[path_node] - global_transform.origin
		if dir.length() < 1:
			path_node += 1
		else:
			move_and_slide(dir.normalized() * speed, Vector3.UP)


func move_to(target_pos):
	var begin = navmesh.get_closest_point(get_translation())
	path = navmesh.get_simple_path(global_transform.origin, target_pos)
	path_node = 0
	
#	if draw_path:
#		var im = get_node("../../draw")
#		im.set_material_override(m)
#		im.clear()
#		im.begin(Mesh.PRIMITIVE_POINTS, null)
#		im.add_vertex(begin)
#		im.add_vertex(end)
#		im.end()
#		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
#		for x in path:
#			im.add_vertex(x)
#		im.end()


func _on_unit_mouse_entered():
	get_node("MeshInstance").get_surface_material(0).next_pass.set_shader_param("enable", true)


func _on_unit_mouse_exited():
	get_node("MeshInstance").get_surface_material(0).next_pass.set_shader_param("enable", false)
