extends KinematicBody

export var move_speed = 10
export var halo_size = 1.7

var path = []
var path_node = 0
var begin = Vector3()
var end = Vector3()
var draw_path = true

onready var navmesh = get_parent()

#var m = SpatialMaterial.new()
var mat = preload("unit_material.tres").duplicate(true)
var halo_mat = preload("selection_halo.tres")

#signal unit_clicked(event, unit_pos)

func _ready():
#	m.flags_unshaded = true
#	m.flags_use_point_size = true
#	m.albedo_color = Color.white
	self.connect("mouse_entered", self, "_on_unit_mouse_entered" )
	self.connect("mouse_exited", self, "_on_unit_mouse_exited" )
	self.connect("input_event", self, "_on_unit_mouse_clicked")
	
	var mesh = get_node("MeshInstance")
	mesh.set_surface_material(0, mat)
	mat.next_pass.set_shader_param("color", Color(0.0, 1.0, 0.0, 1.0))
	mat.next_pass.set_shader_param("outline_thickness", 0.08)
	mat.next_pass.set_shader_param("enable", false)
	
	draw_selection_halo(halo_size)
	
	
func _physics_process(delta):
	if path_node < path.size():
		var dir = path[path_node] - global_transform.origin
		if dir.length() < 1:
			path_node += 1
		else:
			move_and_slide(dir.normalized() * move_speed, Vector3.UP)


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


func draw_selection_halo(circle_radius):
	var UP = Vector3(0,1,0)
	$"SelectionHalo".clear()
	$"SelectionHalo".begin(Mesh.PRIMITIVE_LINE_LOOP)
	for i in range(32):
		var rotation = float(i) / 32 * TAU
		$"SelectionHalo".add_vertex( Vector3(cos(rotation), -1, sin(rotation))*circle_radius )
	$"SelectionHalo".end()


func _on_unit_mouse_entered():
	get_node("MeshInstance").get_surface_material(0).next_pass.set_shader_param("enable", true)


func _on_unit_mouse_exited():
	get_node("MeshInstance").get_surface_material(0).next_pass.set_shader_param("enable", false)


func _on_unit_mouse_clicked(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if Input.is_key_pressed(KEY_SHIFT):
			if self in get_node("/root/Spatial").selected_units:
				get_node("/root/Spatial").selected_units.erase(self)
				$"SelectionHalo".visible = false
			else:
				get_node("/root/Spatial").selected_units.append(self)
				$"SelectionHalo".visible = true
		else:
			for u in get_node("/root/Spatial").selected_units:
				u.get_node("SelectionHalo").visible = false
			get_node("/root/Spatial").selected_units = [self]
			$"SelectionHalo".visible = true
