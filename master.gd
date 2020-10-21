extends Spatial

var selected_units = []

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_units.append(get_node("Navigation/unit"))
	selected_units.append(get_node("Navigation/unit2"))
	selected_units[1].get_node("MeshInstance").get_surface_material(0).albedo_color = Color.blue


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		if selected_units.size() > 0:
			var center = Vector3(0.0, 0.0, 0.0)
			for unit in selected_units:
				center += unit.get_translation()
			center /= selected_units.size()
			for i in range(selected_units.size()):
				# Cast a ray from the camera to determine the target location on the navmesh
				var raylength = 200
				var camera = get_node("CameraBase/Camera")
				var rayfrom = camera.project_ray_origin(event.position)
				var rayto = rayfrom + camera.project_ray_normal(event.position) * raylength
				var nav = get_node("Navigation")
				var tgt = nav.get_closest_point_to_segment(rayfrom, rayto)
				tgt = nav.get_closest_point(tgt + (selected_units[i].get_translation() - center))
				selected_units[i].move_to(tgt)
