extends Node

@export_group("Canvas")
@export var camera_canvas : TextureRect;
@export var overlay_canvas : TextureRect;
@export_group("Input")
@export var threshold_slider : Range;
@export var mode_button : OptionButton;
@export var overlay_button : CheckButton;
@export_group("3d Marker Augmentation")
@export var sun_target: Marker3D
@export var sun_label3d: Label3D
@export var sun_info_label: Label3D

@export var mercury_target: Marker3D
@export var mercury_label3d: Label3D
@export var mercury_info_label: Label3D

@export var venus_target: Marker3D
@export var venus_label3d: Label3D
@export var venus_info_label: Label3D

@export var earth_target: Marker3D
@export var earth_label3d: Label3D
@export var earth_info_label: Label3D

@export var mars_target: Marker3D
@export var mars_label3d: Label3D
@export var mars_info_label: Label3D

@export var jupiter_target: Marker3D
@export var jupiter_label3d: Label3D
@export var jupiter_info_label: Label3D

@export var saturn_target: Marker3D
@export var saturn_label3d: Label3D
@export var saturn_info_label: Label3D

@export var uranus_target: Marker3D
@export var uranus_label3d: Label3D
@export var uranus_info_label: Label3D

@export var neptune_target: Marker3D
@export var neptune_label3d: Label3D
@export var neptune_info_label: Label3D

var planet_models = [
	{
		"name": "Sun",
		"marker_id": 90,
		"path": NodePath("SubViewportContainer/SubViewport/Sun_Marker3D/sun_model"),
		"diameter_km": 1392000.0,
		"aabb_size": Vector3(20.0, 20.0, 20.0)
		# Sun: mesh = UnstableStarCore_1_0, AABB = (20.0, 20.0, 20.0)
	},
	{
		"name": "Mercury",
		"marker_id": 4648,
		"path": NodePath("SubViewportContainer/SubViewport/Mercury_Marker3D/mercury_model"),
		"diameter_km": 4879.4,
		"aabb_size": Vector3(0.004801, 0.004811, 0.004795)
		# Mercury: mesh = Mercury, AABB = (0.004801, 0.004811, 0.004795)
	},
	{
		"name": "Venus",
		"marker_id": 1680, #1680
		"path": NodePath("SubViewportContainer/SubViewport/Venus_Marker3D/venus_model"),
		"diameter_km": 12104.0,
		"aabb_size": Vector3(0.012104, 0.012085, 0.012104)
		# Venus: mesh = Venus, AABB = (0.012104, 0.012085, 0.012104)
	},
	{
		"name": "Earth",
		"marker_id": 1, #2884
		"path": NodePath("SubViewportContainer/SubViewport/Earth_Marker3D/earth_model"),
		"diameter_km": 12742.0,
		"aabb_size": Vector3(0.063104, 0.063089, 0.063308)
		# Earth: mesh = Earth, AABB = (0.063104, 0.063089, 0.063308)
	},
	{
		"name": "Mars",
		"marker_id": 1, #626
		"path": NodePath("SubViewportContainer/SubViewport/Mars_Marker3D/mars_model"),
		"diameter_km": 6779.0,
		"aabb_size": Vector3(1.999998, 1.999997, 2.0)
		# Mars: mesh = Sphere_Material_002_0, AABB = (1.999998, 1.999997, 2.0)
	},
	{
		"name": "Jupiter",
		"marker_id": 1, #7236
		"path": NodePath("SubViewportContainer/SubViewport/Jupiter_Marker3D/jupiter_model"),
		"diameter_km": 139820.0,
		"aabb_size": Vector3(14.3, 14.3, 13.58)
		# Jupiter: mesh = jupiter1_A, AABB = (14.3, 14.3, 13.58)
	},
	{
		"name": "Saturn",
		"marker_id": 2884,
		"path": NodePath("SubViewportContainer/SubViewport/Saturn_Marker3D/saturn_model"),
		"diameter_km": 116460.0,
		"aabb_size": Vector3(120457.7, 120469.0, 112034.2)
		# Saturn: mesh = 0, AABB = (120457.7, 120469.0, 112034.2)
	},
	{
		"name": "Uranus",
		"marker_id": 626,
		"path": NodePath("SubViewportContainer/SubViewport/Uranus_Marker3D/uranus_model"),
		"diameter_km": 50724.0,
		"aabb_size": Vector3(511.2594, 511.2757, 501.3231)
		# Uranus: mesh = uranus1_A, AABB = (511.2594, 511.2757, 501.3231)
	},
	{
		"name": "Neptune",
		"marker_id": 7236,
		"path": NodePath("SubViewportContainer/SubViewport/Neptune_Marker3D/neptune_model"),
		"diameter_km": 49244.0,
		"aabb_size": Vector3(1.999998, 1.999997, 2.0)
		 # Neptune: mesh = Sphere_Material_002_0, AABB = (1.999998, 1.999997, 2.0)
	},
]

const SUN_SCALE = 0.005
const UNIFORM_TARGET_SIZE = 0.0005  # Adjust as needed for visibility

var sun = get_planet_by_name("Sun")
var mercury = get_planet_by_name("Mercury")
var venus = get_planet_by_name("Venus")
var earth = get_planet_by_name("Earth")
var mars = get_planet_by_name("Mars")
var jupiter = get_planet_by_name("Jupiter")
var saturn = get_planet_by_name("Saturn")
var uranus = get_planet_by_name("Uranus")
var neptune = get_planet_by_name("Neptune")

var camera : CVCamera = CVCamera.new();
#var camera = CVCamera.new()

var texture : ImageTexture;
var overlay_texture : ImageTexture;
var timer_framerate: Timer;

func _ready():
	#camera.open(0, 1920, 1080);
	#camera.open_file("/Users/klaudie/Desktop/Robotics/SoSe25/Augmented Reality/exercises/Solar-System-Augmented-Reality-Project/MarkerMovie.mp4");
	camera.open(1,460,480)

	
	camera.flip(false, false);
	texture = ImageTexture.new();
	overlay_texture = ImageTexture.new();
	
	timer_framerate = Timer.new();
	timer_framerate.one_shot = false;
	timer_framerate.timeout.connect(_on_timer_framerate);
	add_child(timer_framerate);
	var framerate = camera.get_framerate();
	print("framerate: ",  framerate,  ", ticker interval: ", 1 / framerate);
	timer_framerate.start(1 / framerate);
	
	threshold_slider.value_changed.connect(_on_threshold_changed);
	
	#call_deferred("_print_model_size_deferred")
	#marker_target.scale = Vector3(0.045, 0.045, 0.045);
	
	
	
func _process(delta):
	pass
	
func _on_timer_framerate():
	var threshold_image = camera.get_threshold_image();
	match mode_button.selected:
		0: # Color
			texture.set_image(camera.get_image());
		1: # Grey
			texture.set_image(camera.get_gray_image());
		2: # Threshold
			texture.set_image(threshold_image);
	camera_canvas.texture = texture;
	
	camera.find_rectangles(overlay_button.button_pressed);
	overlay_canvas.visible = overlay_button.button_pressed;
	if overlay_button.button_pressed:
		overlay_canvas.texture = overlay_texture;
		overlay_texture.set_image(camera.get_overlay_image());
		
	# ALl marker IDS: 90 626 1680 2884 4648 7236 for the current video
	#0. Sun      ✅
	#1.	Mercury  ✅
	#2.	Venus    ✅
	#3.	Earth    ✅
	#4.	Mars     ✅
	#5.	Jupiter  ✅
	#6.	Saturn   ✅
	#7.	Uranus   ✅
	#8.	Neptune  ✅
	
	# ==== Sun ====
	if camera.has_marker_transform(sun["marker_id"]):
		# Sun
		var transform_sun = camera.get_marker_transform(sun["marker_id"])
		var scale_factor_sun = get_planet_scale(
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_sun)
		scale_factor_sun = scale_factor_sun * 100 
		transform_sun.basis.x *= scale_factor_sun
		transform_sun.basis.y *= scale_factor_sun
		transform_sun.basis.z *= scale_factor_sun
		sun_target.transform = transform_sun
		
		sun_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_sun.basis = Basis()  # Neutralize Rotation 
		transform_sun.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		sun_label3d.transform = transform_sun  # ✅ Corrected transform is set
		sun_label3d.text = "Sun"
		sun_label3d.visible = true
		
		
		sun_info_label.transform = transform_sun.translated(Vector3(-0.04, -0.1, 0)) 
		sun_info_label.text = "• type: star\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: contains ~99.8%% of all the mass\n    in the solar system" % sun["diameter_km"]

		sun_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		sun_info_label.visible = true

	else:
		# Sun
		sun_target.visible = false
		
		#Label 3D
		sun_label3d.visible = false
		
		sun_info_label.visible = false

	
	# ==== Mercury ====
	if camera.has_marker_transform(mercury["marker_id"]):
		# Mercury
		var transform_mercury = camera.get_marker_transform(mercury["marker_id"])
		var scale_factor_mercury = get_planet_scale(
			mercury["diameter_km"],
			max(mercury["aabb_size"].x, mercury["aabb_size"].y, mercury["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_mercury)
		transform_mercury.basis.x *= scale_factor_mercury
		transform_mercury.basis.y *= scale_factor_mercury
		transform_mercury.basis.z *= scale_factor_mercury
		mercury_target.transform = transform_mercury
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		mercury_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_mercury.basis = Basis()  # Neutralize Rotation 
		transform_mercury.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		mercury_label3d.transform = transform_mercury  # ✅ Corrected transform is set
		mercury_label3d.text = "Mercury"
		mercury_label3d.visible = true
		
		mercury_info_label.transform = transform_mercury.translated(Vector3(-0.04, -0.1, 0)) 
		mercury_info_label.text = "• type: rocky planet\n• surface: cratered, with extreme temperature shifts \n• diameter: %.0f km\n• fun fact: the smallest and fastest planet" % mercury["diameter_km"]

		mercury_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		mercury_info_label.visible = true
	else:
		# Mercury
		mercury_target.visible = false
		
		#Label 3D
		mercury_label3d.visible = false
		
		mercury_info_label.visible = false
	
	# ==== Venus ====
	if camera.has_marker_transform(venus["marker_id"]):
		# Mercury
		var transform_venus = camera.get_marker_transform(venus["marker_id"])
		var scale_factor_venus = get_planet_scale(
			venus["diameter_km"],
			max(venus["aabb_size"].x, venus["aabb_size"].y, venus["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_venus)
		#var scale_factor_venus = 0.05
		transform_venus.basis.x *= scale_factor_venus
		transform_venus.basis.y *= scale_factor_venus
		transform_venus.basis.z *= scale_factor_venus
		venus_target.transform = transform_venus
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		venus_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_venus.basis = Basis()  # Neutralize Rotation 
		transform_venus.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		venus_label3d.transform = transform_venus  # ✅ Corrected transform is set
		venus_label3d.text = "Venus"
		venus_label3d.visible = true
		
		venus_info_label.transform = transform_venus.translated(Vector3(-0.04, -0.1, 0)) 
		venus_info_label.text = "• type: rocky planet\n• surface: volcanic plains and mountains \n• diameter: %.0f km\n• fun fact: a day on this planet lasts longer than its year" % venus["diameter_km"]

		venus_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		venus_info_label.visible = true
	else:
		# Venus
		venus_target.visible = false
		
		#Label 3D
		venus_label3d.visible = false
		
		venus_info_label.visible = false
	
	# ==== Earth ====
	if camera.has_marker_transform(earth["marker_id"]):
		# Mercury
		var transform_earth = camera.get_marker_transform(earth["marker_id"])
		var scale_factor_earth = get_planet_scale(
			earth["diameter_km"],
			max(earth["aabb_size"].x, earth["aabb_size"].y, earth["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_earth)
		#var scale_factor_earth = 0.009
		transform_earth.basis.x *= scale_factor_earth
		transform_earth.basis.y *= scale_factor_earth
		transform_earth.basis.z *= scale_factor_earth
		earth_target.transform = transform_earth
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		earth_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_earth.basis = Basis()  # Neutralize Rotation 
		transform_earth.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		earth_label3d.transform = transform_earth  # ✅ Corrected transform is set
		earth_label3d.text = "Earth"
		earth_label3d.visible = true
		
		earth_info_label.transform = transform_earth.translated(Vector3(-0.04, -0.1, 0)) 
		earth_info_label.text = "• type: rocky planet\n• surface: mountains, valleys, volcanoes, liquid water \n• diameter: %.0f km\n• fun fact: the only known planet that supports life" % earth["diameter_km"]

		earth_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		earth_info_label.visible = true
	else:
		# Earth
		earth_target.visible = false
		
		#Label 3D
		earth_label3d.visible = false
		
		earth_info_label.visible = false
	
	# ==== Mars ====
	if camera.has_marker_transform(mars["marker_id"]):
		# mars
		var transform_mars = camera.get_marker_transform(mars["marker_id"])
		var scale_factor_mars = get_planet_scale(
			mars["diameter_km"],
			max(mars["aabb_size"].x, mars["aabb_size"].y, mars["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_mars)
		#var scale_factor_mars = 0.0005
		transform_mars.basis.x *= scale_factor_mars
		transform_mars.basis.y *= scale_factor_mars
		transform_mars.basis.z *= scale_factor_mars
		mars_target.transform = transform_mars
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		mars_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_mars.basis = Basis()  # Neutralize Rotation 
		transform_mars.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		mars_label3d.transform = transform_mars  # ✅ Corrected transform is set
		mars_label3d.text = "Mars"
		mars_label3d.visible = true
		
		mars_info_label.transform = transform_mars.translated(Vector3(-0.04, -0.1, 0)) 
		mars_info_label.text = "• type: rocky planet\n• surface: dusty, cold, desert world \n• diameter: %.0f km\n• fun fact: once had flowing rivers and lakes" % mars["diameter_km"]

		mars_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		mars_info_label.visible = true
	else:
		# Mars
		mars_target.visible = false
		
		#Label 3D
		mars_label3d.visible = false
		
		mars_info_label.visible = false
	
	# ==== Jupiter ====
	if camera.has_marker_transform(jupiter["marker_id"]):
		# Jupiter
		var transform_jupiter = camera.get_marker_transform(jupiter["marker_id"])
		var scale_factor_jupiter = get_planet_scale(
			jupiter["diameter_km"],
			max(jupiter["aabb_size"].x, jupiter["aabb_size"].y, jupiter["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_jupiter)
		scale_factor_jupiter = scale_factor_jupiter * 50 #0.0009
		transform_jupiter.basis.x *= scale_factor_jupiter
		transform_jupiter.basis.y *= scale_factor_jupiter
		transform_jupiter.basis.z *= scale_factor_jupiter
		jupiter_target.transform = transform_jupiter
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		jupiter_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_jupiter.basis = Basis()  # Neutralize Rotation 
		transform_jupiter.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		jupiter_label3d.transform = transform_jupiter  # ✅ Corrected transform is set
		jupiter_label3d.text = "Jupiter"
		jupiter_label3d.visible = true
		
		jupiter_info_label.transform = transform_jupiter.translated(Vector3(-0.04, -0.1, 0)) 
		jupiter_info_label.text = "• type: gas giant\n• composition: hydrogen, helium \n• diameter: %.0f km\n• fun fact: has a storm larger than Earth, raging for at least 350 years" % jupiter["diameter_km"]

		jupiter_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		jupiter_info_label.visible = true
	else:
		# Jupiter
		jupiter_target.visible = false
		
		#Label 3D
		jupiter_label3d.visible = false
		
		jupiter_info_label.visible = false
	
	# ==== Saturn ====
	if camera.has_marker_transform(saturn["marker_id"]):
		# Saturn
		var transform_saturn = camera.get_marker_transform(saturn["marker_id"])
		var scale_factor_saturn = get_planet_scale(
			saturn["diameter_km"],
			max(saturn["aabb_size"].x, saturn["aabb_size"].y, saturn["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_saturn)
		scale_factor_saturn = 0.00005
		transform_saturn.basis.x *= scale_factor_saturn
		transform_saturn.basis.y *= scale_factor_saturn
		transform_saturn.basis.z *= scale_factor_saturn
		saturn_target.transform = transform_saturn
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		saturn_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_saturn.basis = Basis()  # Neutralize Rotation 
		transform_saturn.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		saturn_label3d.transform = transform_saturn  # ✅ Corrected transform is set
		saturn_label3d.text = "Saturn"
		saturn_label3d.visible = true
		
		saturn_info_label.transform = transform_saturn.translated(Vector3(-0.04, -0.1, 0)) 
		saturn_info_label.text = "• type: gas giant\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: farthest planet from Earth discovered by the unaided human eye" % saturn["diameter_km"]

		saturn_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		saturn_info_label.visible = true
	else:
		# Saturn
		saturn_target.visible = false
		
		#Label 3D
		saturn_label3d.visible = false
		
		saturn_info_label.visible = false
			
	# ==== Uranus ====
	if camera.has_marker_transform(uranus["marker_id"]):
		# Uranus
		var transform_uranus = camera.get_marker_transform(uranus["marker_id"])
		#print("Marker Target", transform);
		#print("Transform X: ", transform.basis.x)
		#print("Transform Y: ", transform.basis.y)
		#print("Transform Z: ", transform.basis.z)
		#print("Origin: ", transform.origin)
		
		var scale_factor_uranus = get_planet_scale(
			uranus["diameter_km"],
			max(uranus["aabb_size"].x, uranus["aabb_size"].y, uranus["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_uranus)
		scale_factor_uranus = 0.0001
		transform_uranus.basis.x *= scale_factor_uranus
		transform_uranus.basis.y *= scale_factor_uranus
		transform_uranus.basis.z *= scale_factor_uranus
		uranus_target.transform = transform_uranus
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		uranus_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_uranus.basis = Basis()  # Neutralize Rotation
		transform_uranus.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		uranus_label3d.transform = transform_uranus  # ✅ Corrected transform is set
		uranus_label3d.text = "Uranus"
		uranus_label3d.visible = true
		
		uranus_info_label.transform = transform_uranus.translated(Vector3(-0.04, -0.1, 0)) 
		uranus_info_label.text = "• type: ice giant\n• composition: hydrogen, helium, methane (which gives its blue color) \n• diameter: %.0f km\n• fun fact: has an extreme axial tilt of about 98 degrees, causing it to rotate nearly on its side" % uranus["diameter_km"]

		uranus_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		uranus_info_label.visible = true
	else:
		# Uranus
		uranus_target.visible = false
		
		#Label 3D
		uranus_label3d.visible = false
		
		uranus_info_label.visible = false
	
	# ==== Neptune ====
	if camera.has_marker_transform(neptune["marker_id"]):
		# Neptune
		var transform_neptune = camera.get_marker_transform(neptune["marker_id"])
		var scale_factor_neptune = get_planet_scale(
			neptune["diameter_km"],
			max(neptune["aabb_size"].x, neptune["aabb_size"].y, neptune["aabb_size"].z),
			sun["diameter_km"],
			max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		#print(scale_factor_neptune)
		#var scale_factor_neptune = 0.0002
		transform_neptune.basis.x *= scale_factor_neptune
		transform_neptune.basis.y *= scale_factor_neptune
		transform_neptune.basis.z *= scale_factor_neptune
		neptune_target.transform = transform_neptune
		#marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		neptune_target.visible = true;
		
		# Label 3D
		# Customize for label only:
		transform_neptune.basis = Basis()  # Neutralize Rotation
		transform_neptune.origin += Vector3.UP * 0.05  # optional: Raise text slightly

		neptune_label3d.transform = transform_neptune  # ✅ Corrected transform is set
		neptune_label3d.text = "Neptune"
		neptune_label3d.visible = true
		
		neptune_info_label.transform = transform_neptune.translated(Vector3(-0.04, -0.1, 0)) 
		neptune_info_label.text = "• type: ice giant\n• composition: hydrogen, helium, methane \n• diameter: %.0f km\n• fun fact: the windiest planet in our solar system\n    in the solar system" % neptune["diameter_km"]

		neptune_info_label.scale = Vector3(0.05, 0.05, 0.05) 

		neptune_info_label.visible = true
	else:
		# Neptune
		neptune_target.visible = false
		
		#Label 3D
		neptune_label3d.visible = false
		
		neptune_info_label.visible = false
			
	var marker = camera.get_all_marker_ids();
	#print(marker) #90 626 1680 2884 4648 7236
	
func _on_threshold_changed(value : float):
	camera.set_threshold(value);
	
func _find_node_with_mesh(node: Node) -> Node3D:
	if node is Node3D and "mesh" in node:
		if node.mesh:
			return node
	for child in node.get_children():
		var result = _find_node_with_mesh(child)
		if result:
			return result
	return null

func _print_model_size_deferred():
	for i in range(planet_models.size()):
		var planet = planet_models[i]
		var model_root = get_node_or_null(planet["path"])
		if model_root == null:
			print("❌ Node not found: ", planet["name"])
			continue

		var mesh_holder = _find_node_with_mesh(model_root)
		if mesh_holder:
			var aabb = mesh_holder.get_aabb()
			print("🌍 ", planet["name"], ": mesh = ", mesh_holder.name, ", AABB = ", aabb.size)

			# ✅ AABB-Wert in Liste aktualisieren
			planet["aabb_size"] = aabb.size
			planet_models[i] = planet  # notwendig, um geändertes Dict zurück in die Liste zu schreiben
		else:
			print("❌ ", planet["name"], ": No mesh found")

#const SUN_SCALE = 0.005  # beliebiger Sichtbarkeitsfaktor
#
#func get_planet_scale(
	#planet_diameter_km: float, planet_aabb: float,
	#sun_diameter_km: float, sun_aabb: float
#) -> float:
	#if planet_diameter_km == sun_diameter_km:
		#return SUN_SCALE  # Sichtbarkeitsboost für Sonne
	#
	#var diameter_ratio = planet_diameter_km / sun_diameter_km
	#var visual_ratio = pow(diameter_ratio, 0.4)
	#var mesh_correction = sun_aabb / planet_aabb
	#
	#return min(visual_ratio * mesh_correction * SUN_SCALE, SUN_SCALE)

func get_planet_scale(
	planet_diameter_km: float, planet_aabb: float,
	sun_diameter_km: float, sun_aabb: float
) -> float:
	#if planet_diameter_km == sun_diameter_km:
		#return SUN_SCALE
#
	#var diameter_ratio = planet_diameter_km / sun_diameter_km
	#var visual_ratio = boosted_ratio(diameter_ratio)
	#var mesh_correction = clamp(sun_aabb / planet_aabb, 0.1, 10.0)  # capped!
#
	#var scale = visual_ratio * mesh_correction * SUN_SCALE
	#return clamp(scale, SUN_SCALE * 0.25, SUN_SCALE * 0.99)
	return UNIFORM_TARGET_SIZE / planet_aabb

func boosted_ratio(d: float) -> float:
	return 1.0 - exp(-d * 1000.0)
	
func get_planet_by_name(name: String) -> Dictionary:
	for planet in planet_models:
		if planet["name"] == name:
			return planet
	return {}
