extends Node

@export_group("Canvas")
@export var camera_canvas : TextureRect;
#@onready var camera_canvas = $UIRoot/CameraCanvas
@export var overlay_canvas : TextureRect;

@export_group("Input")
@export var threshold_slider : Range;
@export var mode_button : OptionButton;
@export var overlay_button : CheckButton;
@export var toggle_info_button : CheckButton;
@export var play_again_button : Button;
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


# 4169, 4282, 7215, 10571, 12438, 12698, 19941, 21405, 21817
#[4169, 4283, 7332, 12698, 19941, 21405, 21817, 22458, 32523]
var planet_models = [
	{
		"name": "Sun",
		"marker_id": 4169,  #works 4169
		"path": NodePath("SubViewportContainer/SubViewport/Sun_Marker3D/sun_model"),
		"label": sun_label3d,
		"diameter_km": 1392000.0,
		"aabb_size": Vector3(20.0, 20.0, 20.0)
		# Sun: mesh = UnstableStarCore_1_0, AABB = (20.0, 20.0, 20.0)
	},
	{
		"name": "Mercury",
		"marker_id": 4283,   #works 4282
		"path": NodePath("SubViewportContainer/SubViewport/Mercury_Marker3D/mercury_model"),
		"label": mercury_label3d,
		"diameter_km": 4879.4,
		"aabb_size": Vector3(0.004801, 0.004811, 0.004795)
		# Mercury: mesh = Mercury, AABB = (0.004801, 0.004811, 0.004795)
	},
	{
		"name": "Venus",
		"marker_id": 7332, #1680
		"path": NodePath("SubViewportContainer/SubViewport/Venus_Marker3D/venus_model"),
		"label": venus_label3d,
		"diameter_km": 12104.0,
		"aabb_size": Vector3(0.012104, 0.012085, 0.012104)
		# Venus: mesh = Venus, AABB = (0.012104, 0.012085, 0.012104)
	},
	{
		"name": "Earth",
		"marker_id": 22458, #2884
		"path": NodePath("SubViewportContainer/SubViewport/Earth_Marker3D/earth_model"),
		"label": earth_label3d,
		"diameter_km": 12742.0,
		"aabb_size": Vector3(0.063104, 0.063089, 0.063308)
		# Earth: mesh = Earth, AABB = (0.063104, 0.063089, 0.063308)
	},
	{
		"name": "Mars",
		"marker_id": 32523, #12438, #626
		"path": NodePath("SubViewportContainer/SubViewport/Mars_Marker3D/mars_model"),
		"label": mars_label3d,
		"diameter_km": 6779.0,
		"aabb_size": Vector3(1.999998, 1.999997, 2.0)
		# Mars: mesh = Sphere_Material_002_0, AABB = (1.999998, 1.999997, 2.0)
	},
	{
		"name": "Jupiter",
		"marker_id": 12698, #7236  #works
		"path": NodePath("SubViewportContainer/SubViewport/Jupiter_Marker3D/jupiter_model"),
		"label": jupiter_label3d,
		"diameter_km": 139820.0,
		"aabb_size": Vector3(14.3, 14.3, 13.58)
		# Jupiter: mesh = jupiter1_A, AABB = (14.3, 14.3, 13.58)
	},
	{
		"name": "Saturn",
		"marker_id": 19941,  #works
		"path": NodePath("SubViewportContainer/SubViewport/Saturn_Marker3D/saturn_model"),
		"label": saturn_label3d,
		"diameter_km": 116460.0,
		"aabb_size": Vector3(120457.7, 120469.0, 112034.2) #not correct
		# Saturn: mesh = 0, AABB = (120457.7, 120469.0, 112034.2)
	},
	{
		"name": "Uranus",
		"marker_id": 21405, #works
		"path": NodePath("SubViewportContainer/SubViewport/Uranus_Marker3D/uranus_model"),
		"label": uranus_label3d,
		"diameter_km": 50724.0,
		"aabb_size": Vector3(511.2594, 511.2757, 501.3231)
		# Uranus: mesh = uranus1_A, AABB = (511.2594, 511.2757, 501.3231)
	},
	{
		"name": "Neptune",
		"marker_id": 21817, #works
		"path": NodePath("SubViewportContainer/SubViewport/Neptune_Marker3D/neptune_model"),
		"label": neptune_label3d,
		"diameter_km": 49244.0,
		"aabb_size": Vector3(1.999998, 1.999997, 2.0)
		 # Neptune: mesh = Sphere_Material_002_0, AABB = (1.999998, 1.999997, 2.0)
	},
]

const SUN_SCALE = 0.005
const UNIFORM_TARGET_SIZE = 0.00062  # Adjust as needed for visibility

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
var well_done_shown = false;
var show_info := true;

# Pose socket 通信
var pose_server := TCPServer.new()
var pose_stream : StreamPeerTCP = null

var planet_labels = {}

func _ready():
	## 初始化与 SLAM 通信的 socket
	camera.init_slam_socket("127.0.0.1", 5555) 
	
	# 添加这一段监听 Camera Pose
	var pose_port = 5566
	var err = pose_server.listen(pose_port, "127.0.0.1")
	if err == OK:
		print("✅ Listening for camera pose on 127.0.0.1:", pose_port)
	else:
		print("❌ Failed to listen for pose:", err)
		
	set_process(true)  # 需要开启 _process() 循环
	
	planet_labels = {
		"Sun": sun_label3d,
		"Mercury": mercury_label3d,
		"Venus": venus_label3d,
		"Earth": earth_label3d,
		"Mars": mars_label3d,
		"Jupiter": jupiter_label3d,
		"Saturn": saturn_label3d,
		"Uranus": uranus_label3d,
		"Neptune": neptune_label3d
	}
	
	## Live Feed Version
	#camera.open(0, 640, 480);
	# camera.open(0, 1900, 820);
	
	## Video Versions
	#camera.open_file("/Users/philippwiese/Documents/Uni/Master/2.Semester/Erweiterte Realität/Solar System Project/Solar_System_Test.mp4");
	camera.open_file("/Users/philippwiese/Documents/Uni/Master/2.Semester/Erweiterte Realität/Solar System Project/Play_again_Test_video.mp4");
	#camera.open_file("/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/Solar_System_Test.mp4");
	#camera.open_file("/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/game_demo.mp4");
	#camera.open_file("/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/game_victory.mp4");
	#camera.open_file("/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/env_scan.mp4");
	#camera.open_file("/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/MarkerMovie.mp4");
	#camera.open_file("C:/Users/Garrulus/Downloads/TUM/1.Semester/Solar-System-Augmented-Reality-Project/game_victory.mp4");
	
	await get_tree().process_frame  # einmal warten
	## 🔁 Wait until an image has been loaded (max. 1 second)
	## 🕒 Wait until camera delivers a non-empty image
	var timeout_frames := 60  # max. 1 second at 60 FPS
	while timeout_frames > 0:
		var img := camera.get_image()
		if img and not img.is_empty():
			break
		await get_tree().process_frame
		timeout_frames -= 1

	if timeout_frames == 0:
		push_error("❌ Camera does not deliver a picture!")
		return
		
	var cam_width = camera.get_width()
	var cam_height = camera.get_height()
	
	print("📷 Camera Resolution:", cam_width, "x", cam_height)
	# Scaling Viewport & Canvas
	$UIRoot/SubViewportContainer/SubViewport.size = Vector2(cam_width, cam_height)
	camera_canvas.size = Vector2(cam_width, cam_height)
	overlay_canvas.size = Vector2(cam_width, cam_height)
	
	# Setting FOV of the virtual Camera
	var godot_camera_3d = $UIRoot/SubViewportContainer/SubViewport/Camera3D as Camera3D
	var fov_y = camera.get_calculated_fov(godot_camera_3d)
	print("Berechnete FOV:", fov_y)
	print("Previous Godot-Camera FOV:", godot_camera_3d.fov)
	godot_camera_3d.fov = fov_y
	print("Current Godot-Camera FOV:", godot_camera_3d.fov)
	
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
	
	toggle_info_button.pressed.connect(_on_ToggleInfoButton_pressed);
	_update_info_visibility();
	toggle_info_button.text = "Hide Info" if show_info else "Show Info";
	
	play_again_button.pressed.connect(_on_PlayAgainButton_pressed);
	play_again_button.text = "Play Again"; 
	
	#call_deferred("_print_model_size_deferred")
	#marker_target.scale = Vector3(0.045, 0.045, 0.045);
	
	
func _process(delta):
	pass
	
func _on_timer_framerate():
	# Check for new connection
	if pose_server.is_connection_available() and pose_stream == null:
		pose_stream = pose_server.take_connection()
		print("✅ Pose socket connected.")

	# Check if any pose data has been received
	if pose_stream and pose_stream.get_available_bytes() > 0:
		var pose_data := pose_stream.get_utf8_string(pose_stream.get_available_bytes())
		#print("📨 Received pose data:")
		_parse_and_apply_pose(pose_data)
	#else:
		#print("📭 No pose data received.")

	# Keep original Logic
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
	
	update_planet_marker(sun, sun_target, sun_label3d, sun_info_label)
	update_planet_marker(mercury, mercury_target, mercury_label3d, mercury_info_label)
	update_planet_marker(venus, venus_target, venus_label3d, venus_info_label)
	update_planet_marker(earth, earth_target, earth_label3d, earth_info_label)
	update_planet_marker(mars, mars_target, mars_label3d, mars_info_label)
	update_planet_marker(jupiter, jupiter_target, jupiter_label3d, jupiter_info_label)
	update_planet_marker(saturn, saturn_target, saturn_label3d, saturn_info_label)
	update_planet_marker(uranus, uranus_target, uranus_label3d, uranus_info_label)
	update_planet_marker(neptune, neptune_target, neptune_label3d, neptune_info_label)
	
	var current_order = sort_planets_by_distance_to_sun()
	if current_order != null:
		var expected_order = ["Sun","Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
		color_planet_labels(current_order, expected_order)
		var is_correct: bool = current_order == expected_order
		if is_correct and not well_done_shown:
			show_well_done()
			well_done_shown = true
	
		
	##
	##
	## ==== Sun ====
	#if camera.has_marker_transform(sun["marker_id"]):
		## Sun
		#var transform_sun = camera.get_marker_transform(sun["marker_id"])
		#var scale_factor_sun = get_planet_scale(
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_sun)
		#scale_factor_sun = scale_factor_sun * 100 
		#transform_sun.basis.x *= scale_factor_sun
		#transform_sun.basis.y *= scale_factor_sun
		#transform_sun.basis.z *= scale_factor_sun
		#sun_target.transform = transform_sun
		#
		#sun_target.visible = true;
		#if not well_done_shown:
			#show_well_done()
			#well_done_shown = true
		#
		## Label 3D
		## Customize for label only:
		#transform_sun.basis = Basis()  # Neutralize Rotation 
		#transform_sun.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#sun_label3d.transform = transform_sun  # ✅ Corrected transform is set
		#sun_label3d.text = "Sun"
		#sun_label3d.visible = true
		#
		#
		#sun_info_label.transform = transform_sun.translated(Vector3(-0.04, -0.1, 0)) 
		#sun_info_label.text = "• type: star\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: contains ~99.8%% of all the mass\n    in the solar system" % sun["diameter_km"]
#
		#sun_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#sun_info_label.visible = true
#
	#else:
		## Sun
		#sun_target.visible = false
		#
		##Label 3D
		#sun_label3d.visible = false
		#
		#sun_info_label.visible = false
#
	#
	## ==== Mercury ====
	#if camera.has_marker_transform(mercury["marker_id"]):
		## Mercury
		#var transform_mercury = camera.get_marker_transform(mercury["marker_id"])
		#var scale_factor_mercury = get_planet_scale(
			#mercury["diameter_km"],
			#max(mercury["aabb_size"].x, mercury["aabb_size"].y, mercury["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_mercury)
		#transform_mercury.basis.x *= scale_factor_mercury
		#transform_mercury.basis.y *= scale_factor_mercury
		#transform_mercury.basis.z *= scale_factor_mercury
		#mercury_target.transform = transform_mercury
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#mercury_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_mercury.basis = Basis()  # Neutralize Rotation 
		#transform_mercury.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#mercury_label3d.transform = transform_mercury  # ✅ Corrected transform is set
		#mercury_label3d.text = "Mercury"
		#mercury_label3d.visible = true
		#
		#mercury_info_label.transform = transform_mercury.translated(Vector3(-0.04, -0.1, 0)) 
		#mercury_info_label.text = "• type: rocky planet\n• surface: cratered, with extreme temperature shifts \n• diameter: %.0f km\n• fun fact: the smallest and fastest planet" % mercury["diameter_km"]
#
		#mercury_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#mercury_info_label.visible = true
	#else:
		## Mercury
		#mercury_target.visible = false
		#
		##Label 3D
		#mercury_label3d.visible = false
		#
		#mercury_info_label.visible = false
	#
	## ==== Venus ====
	#if camera.has_marker_transform(venus["marker_id"]):
		## Mercury
		#var transform_venus = camera.get_marker_transform(venus["marker_id"])
		#var scale_factor_venus = get_planet_scale(
			#venus["diameter_km"],
			#max(venus["aabb_size"].x, venus["aabb_size"].y, venus["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_venus)
		##var scale_factor_venus = 0.05
		#transform_venus.basis.x *= scale_factor_venus
		#transform_venus.basis.y *= scale_factor_venus
		#transform_venus.basis.z *= scale_factor_venus
		#venus_target.transform = transform_venus
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#venus_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_venus.basis = Basis()  # Neutralize Rotation 
		#transform_venus.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#venus_label3d.transform = transform_venus  # ✅ Corrected transform is set
		#venus_label3d.text = "Venus"
		#venus_label3d.visible = true
		#
		#venus_info_label.transform = transform_venus.translated(Vector3(-0.04, -0.1, 0)) 
		#venus_info_label.text = "• type: rocky planet\n• surface: volcanic plains and mountains \n• diameter: %.0f km\n• fun fact: a day on this planet lasts longer than its year" % venus["diameter_km"]
#
		#venus_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#venus_info_label.visible = true
	#else:
		## Venus
		#venus_target.visible = false
		#
		##Label 3D
		#venus_label3d.visible = false
		#
		#venus_info_label.visible = false
	#
	## ==== Earth ====
	#if camera.has_marker_transform(earth["marker_id"]):
		## Mercury
		#var transform_earth = camera.get_marker_transform(earth["marker_id"])
		#var scale_factor_earth = get_planet_scale(
			#earth["diameter_km"],
			#max(earth["aabb_size"].x, earth["aabb_size"].y, earth["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_earth)
		##var scale_factor_earth = 0.009
		#transform_earth.basis.x *= scale_factor_earth
		#transform_earth.basis.y *= scale_factor_earth
		#transform_earth.basis.z *= scale_factor_earth
		#earth_target.transform = transform_earth
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#earth_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_earth.basis = Basis()  # Neutralize Rotation 
		#transform_earth.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#earth_label3d.transform = transform_earth  # ✅ Corrected transform is set
		#earth_label3d.text = "Earth"
		#earth_label3d.visible = true
		#
		#earth_info_label.transform = transform_earth.translated(Vector3(-0.04, -0.1, 0)) 
		#earth_info_label.text = "• type: rocky planet\n• surface: mountains, valleys, volcanoes, liquid water \n• diameter: %.0f km\n• fun fact: the only known planet that supports life" % earth["diameter_km"]
#
		#earth_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#earth_info_label.visible = true
	#else:
		## Earth
		#earth_target.visible = false
		#
		##Label 3D
		#earth_label3d.visible = false
		#
		#earth_info_label.visible = false
	#
	## ==== Mars ====
	#if camera.has_marker_transform(mars["marker_id"]):
		## mars
		#var transform_mars = camera.get_marker_transform(mars["marker_id"])
		#var scale_factor_mars = get_planet_scale(
			#mars["diameter_km"],
			#max(mars["aabb_size"].x, mars["aabb_size"].y, mars["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_mars)
		##var scale_factor_mars = 0.0005
		#transform_mars.basis.x *= scale_factor_mars
		#transform_mars.basis.y *= scale_factor_mars
		#transform_mars.basis.z *= scale_factor_mars
		#
		#mars_target.transform = transform_mars
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#mars_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_mars.basis = Basis()  # Neutralize Rotation 
		#transform_mars.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#mars_label3d.transform = transform_mars  # ✅ Corrected transform is set
		#mars_label3d.text = "Mars"
		#mars_label3d.visible = true
		#
		#mars_info_label.transform = transform_mars.translated(Vector3(-0.04, -0.1, 0)) 
		#mars_info_label.text = "• type: rocky planet\n• surface: dusty, cold, desert world \n• diameter: %.0f km\n• fun fact: once had flowing rivers and lakes" % mars["diameter_km"]
#
		#mars_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#mars_info_label.visible = true
	#else:
		## Mars
		#mars_target.visible = false
		#
		##Label 3D
		#mars_label3d.visible = false
		#
		#mars_info_label.visible = false
	#
	## ==== Jupiter ====
	#if camera.has_marker_transform(jupiter["marker_id"]):
		## Jupiter
		#var transform_jupiter = camera.get_marker_transform(jupiter["marker_id"])
		#var scale_factor_jupiter = get_planet_scale(
			#jupiter["diameter_km"],
			#max(jupiter["aabb_size"].x, jupiter["aabb_size"].y, jupiter["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_jupiter)
		#scale_factor_jupiter = scale_factor_jupiter * 50 #0.0009
		#transform_jupiter.basis.x *= scale_factor_jupiter
		#transform_jupiter.basis.y *= scale_factor_jupiter
		#transform_jupiter.basis.z *= scale_factor_jupiter
		#jupiter_target.transform = transform_jupiter
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#jupiter_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_jupiter.basis = Basis()  # Neutralize Rotation 
		#transform_jupiter.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#jupiter_label3d.transform = transform_jupiter  # ✅ Corrected transform is set
		#jupiter_label3d.text = "Jupiter"
		#jupiter_label3d.visible = true
		#
		#jupiter_info_label.transform = transform_jupiter.translated(Vector3(-0.04, -0.1, 0)) 
		#jupiter_info_label.text = "• type: gas giant\n• composition: hydrogen, helium \n• diameter: %.0f km\n• fun fact: has a storm larger than Earth, raging for at least 350 years" % jupiter["diameter_km"]
#
		#jupiter_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#jupiter_info_label.visible = true
	#else:
		## Jupiter
		#jupiter_target.visible = false
		#
		##Label 3D
		#jupiter_label3d.visible = false
		#
		#jupiter_info_label.visible = false
	#
	## ==== Saturn ====
	#if camera.has_marker_transform(saturn["marker_id"]):
		## Saturn
		#var transform_saturn = camera.get_marker_transform(saturn["marker_id"])
		#var scale_factor_saturn = get_planet_scale(
			#saturn["diameter_km"],
			#max(saturn["aabb_size"].x, saturn["aabb_size"].y, saturn["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_saturn)
		#scale_factor_saturn = 0.00005
		#transform_saturn.basis.x *= scale_factor_saturn
		#transform_saturn.basis.y *= scale_factor_saturn
		#transform_saturn.basis.z *= scale_factor_saturn
		#saturn_target.transform = transform_saturn
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#saturn_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_saturn.basis = Basis()  # Neutralize Rotation 
		#transform_saturn.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#saturn_label3d.transform = transform_saturn  # ✅ Corrected transform is set
		#saturn_label3d.text = "Saturn"
		#saturn_label3d.visible = true
		#
		#saturn_info_label.transform = transform_saturn.translated(Vector3(-0.04, -0.1, 0)) 
		#saturn_info_label.text = "• type: gas giant\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: farthest planet from Earth discovered by the unaided human eye" % saturn["diameter_km"]
#
		#saturn_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#saturn_info_label.visible = true
	#else:
		## Saturn
		#saturn_target.visible = false
		#
		##Label 3D
		#saturn_label3d.visible = false
		#
		#saturn_info_label.visible = false
			#
	## ==== Uranus ====
	#if camera.has_marker_transform(uranus["marker_id"]):
		## Uranus
		#var transform_uranus = camera.get_marker_transform(uranus["marker_id"])
		##print("Marker Target", transform);
		##print("Transform X: ", transform.basis.x)
		##print("Transform Y: ", transform.basis.y)
		##print("Transform Z: ", transform.basis.z)
		##print("Origin: ", transform.origin)
		#
		#var scale_factor_uranus = get_planet_scale(
			#uranus["diameter_km"],
			#max(uranus["aabb_size"].x, uranus["aabb_size"].y, uranus["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_uranus)
		#scale_factor_uranus = 0.0001
		#transform_uranus.basis.x *= scale_factor_uranus
		#transform_uranus.basis.y *= scale_factor_uranus
		#transform_uranus.basis.z *= scale_factor_uranus
		#uranus_target.transform = transform_uranus
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#uranus_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_uranus.basis = Basis()  # Neutralize Rotation
		#transform_uranus.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#uranus_label3d.transform = transform_uranus  # ✅ Corrected transform is set
		#uranus_label3d.text = "Uranus"
		#uranus_label3d.visible = true
		#
		#uranus_info_label.transform = transform_uranus.translated(Vector3(-0.04, -0.1, 0)) 
		#uranus_info_label.text = "• type: ice giant\n• composition: hydrogen, helium, methane (which gives its blue color) \n• diameter: %.0f km\n• fun fact: has an extreme axial tilt of about 98 degrees, causing it to rotate nearly on its side" % uranus["diameter_km"]
#
		#uranus_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#uranus_info_label.visible = true
	#else:
		## Uranus
		#uranus_target.visible = false
		#
		##Label 3D
		#uranus_label3d.visible = false
		#
		#uranus_info_label.visible = false
	#
	## ==== Neptune ====
	#if camera.has_marker_transform(neptune["marker_id"]):
		## Neptune
		#var transform_neptune = camera.get_marker_transform(neptune["marker_id"])
		#var scale_factor_neptune = get_planet_scale(
			#neptune["diameter_km"],
			#max(neptune["aabb_size"].x, neptune["aabb_size"].y, neptune["aabb_size"].z),
			#sun["diameter_km"],
			#max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z))
		##print(scale_factor_neptune)
		##var scale_factor_neptune = 0.0002
		#transform_neptune.basis.x *= scale_factor_neptune
		#transform_neptune.basis.y *= scale_factor_neptune
		#transform_neptune.basis.z *= scale_factor_neptune
		#neptune_target.transform = transform_neptune
		##marker_target.transform = Transform3D(Basis(), transform.origin * 1.0) # Skaliere evtl.
		#neptune_target.visible = true;
		#
		## Label 3D
		## Customize for label only:
		#transform_neptune.basis = Basis()  # Neutralize Rotation
		#transform_neptune.origin += Vector3.UP * 0.05  # optional: Raise text slightly
#
		#neptune_label3d.transform = transform_neptune  # ✅ Corrected transform is set
		#neptune_label3d.text = "Neptune"
		#neptune_label3d.visible = true
		#
		#neptune_info_label.transform = transform_neptune.translated(Vector3(-0.04, -0.1, 0)) 
		#neptune_info_label.text = "• type: ice giant\n• composition: hydrogen, helium, methane \n• diameter: %.0f km\n• fun fact: the windiest planet in our solar system\n    in the solar system" % neptune["diameter_km"]
#
		#neptune_info_label.scale = Vector3(0.05, 0.05, 0.05) 
#
		#neptune_info_label.visible = true
	#else:
		## Neptune
		#neptune_target.visible = false
		#
		##Label 3D
		#neptune_label3d.visible = false
		#
		#neptune_info_label.visible = false
			
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

func get_planet_scale(
	planet_diameter_km: float, planet_aabb: float,
	sun_diameter_km: float, sun_aabb: float
) -> float:
	if planet_diameter_km == sun_diameter_km:
		return 0.0031  # or 0.02, boost for visibility
	if planet_diameter_km == neptune["diameter_km"]:
		return 0.00031
	if planet_diameter_km == uranus["diameter_km"]:
		return 0.0001
	if planet_diameter_km == jupiter["diameter_km"]:
		return 0.002
	if planet_diameter_km == saturn["diameter_km"]:
		return 0.00031
	var scale = UNIFORM_TARGET_SIZE / planet_aabb
	return max(scale, 0.00005)  # tweak this if needed

func boosted_ratio(d: float) -> float:
	return 1.0 - exp(-d * 1000.0)
	
func get_planet_by_name(name: String) -> Dictionary:
	for planet in planet_models:
		if planet["name"] == name:
			return planet
	return {}

func show_well_done():
	var sprite = $UIRoot/CameraCanvas/WellDoneAnimation
	print("sprite:", sprite)
	sprite.visible = true
	sprite.modulate.a = 1.0
	sprite.position = camera_canvas.get_size() / 2
	sprite.frame = 0
	sprite.play("welldone")
	await sprite.animation_finished
	await get_tree().create_timer(1.0).timeout
	
	var fade_time := 1.0  # 秒
	var timer := 0.0
	while timer < fade_time:
		var alpha: float = lerp(1.0, 0.0, timer / fade_time)
		sprite.modulate.a = alpha
		await get_tree().process_frame  
		timer += get_process_delta_time()
	
	sprite.modulate.a = 0.0

	sprite.visible = false

func _on_PlayAgainButton_pressed():
	well_done_shown = false

func _parse_and_apply_pose(data: String):
	# 把接收到的字符串按空格切开，得到一个 17 个元素的列表（1 个时间戳 + 12 个旋转矩阵元素 + 3 个平移向量）。
	var parts = data.strip_edges().split(" ")
	if parts.size() != 17:
		push_warning("⚠️ Invalid pose data received")
		return
		
	var timestamp = parts[0].to_float()
	var basis := Basis()  # 构造 Basis 对象（3x3 旋转矩阵）
	var origin := Vector3()  # 平移向量 origin 的构造
	for i in range(3):
		for j in range(3):
			basis[j][i] = parts[1 + i * 4 + j].to_float()
		origin[i] = parts[1 + i * 4 + 3].to_float()
	
	print("🕒 Timestamp:", timestamp)
	#print("📈 Basis:", basis)
	#print("📍 Origin:", origin)
	
	# 创建出一个完整的 4x4 位姿矩阵，表示相机的位置和朝向。
	var T := Transform3D(basis, origin)
	# 把这个变换 应用到 Godot 场景中的 Camera3D 节点，使得 Godot 中的虚拟摄像机位置同步到 SLAM 实际估算的位置。
	var cam_node := $UIRoot/SubViewportContainer/SubViewport/Camera3D
	if cam_node:
		cam_node.transform = T

func get_marker_world_transform(marker_id: int) -> Transform3D:
	if not camera.has_marker_transform(marker_id):
		return Transform3D.IDENTITY
		
	var flip := Basis(Vector3(1,0,0), Vector3(0,-1,0), Vector3(0,0,-1))

	var T_marker_cam: Transform3D = camera.get_marker_transform(marker_id)

	var camera_node = $UIRoot/SubViewportContainer/SubViewport/Camera3D
	if camera_node == null or not camera_node is Camera3D:
		print("Warning: Camera3D node not found, using IDENTITY transform.")
		return T_marker_cam  # fallback: assume world = camera
		
	var T_cam_world_opencv: Transform3D = camera_node.transform
	#var T_cam_world_godot := Transform3D(flip) * T_cam_world_opencv * Transform3D(flip).affine_inverse()
	#print("📷 T_cam_world_opencv:",T_cam_world_opencv)
	#print("📷 T_cam_world_godot:",T_cam_world_godot)
	
	#return T_marker_cam
	return T_cam_world_opencv * T_marker_cam
	
func update_planet_marker(planet: Dictionary, target: Marker3D, label3d: Label3D, info_label: Label3D):
	var visible_now := camera.has_marker_transform(planet["marker_id"])
	var T_world: Transform3D  # ✅ 提前声明
	# ✅ 使用 SLAM 获取当前世界坐标
	if visible_now:
		T_world = get_marker_world_transform(planet["marker_id"])
		planet["last_world_transform"] = T_world  # 🧠 缓存
	else:
		T_world = planet.get("last_world_transform", Transform3D.IDENTITY)
		# T_world = Transform3D.IDENTITY
		if T_world == Transform3D.IDENTITY:
			target.visible = false
			label3d.visible = false
			info_label.visible = false
			return

	var scale = get_planet_scale(
		planet["diameter_km"],
		max(planet["aabb_size"].x, planet["aabb_size"].y, planet["aabb_size"].z),
		sun["diameter_km"],
		max(sun["aabb_size"].x, sun["aabb_size"].y, sun["aabb_size"].z)
	)

	# ✅ 逐轴缩放 Basis
	T_world.basis.x *= scale
	T_world.basis.y *= scale
	T_world.basis.z *= scale
	target.transform = T_world

	# ===== Label 3D =====
	var label_transform = T_world
	var camera_node = $UIRoot/SubViewportContainer/SubViewport/Camera3D
	#print("%s position in world: %s" % [planet["name"], T_world.origin])
	label_transform.basis = camera_node.transform.basis
	#label_transform.origin += Vector3.UP * 0.05
	label_transform.origin += camera_node.transform.basis.y * 0.05
	label3d.transform = label_transform
	label3d.text = planet["name"]
	label3d.visible = true
	label3d.modulate = Color(0,1,1)   # Cyan

	# ===== Info Label =====
	#var info_transform = label_transform.translated(Vector3(-0.04, -0.1, 0))
	var info_transform = label_transform
	info_transform = info_transform.translated(Vector3(0, -0.15, 0))
	#info_transform.origin += (
		#camera_node.transform.basis.x * -0.04 +
		#camera_node.transform.basis.y * -0.1
	#)
	info_label.transform = info_transform
	info_label.scale = Vector3(0.08, 0.08, 0.08)
	info_label.visible = show_info
	
	# ===== 根据visible_now决定显示, 覆盖之前的设置 =====
	target.visible = visible_now
	label3d.visible = visible_now
	info_label.visible = visible_now and show_info

	# ✅ 文本匹配信息（按名称匹配）
	match planet["name"]:
		"Sun":
			info_label.text = ("• type: star\n"
				+ "• composition: hydrogen,\n"
				+ "  helium, traces of gases\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: contains ~99.8%%\n"
				+ "  of the mass in the solar\n"
				+ "  system") % sun["diameter_km"] #"• type: star\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: contains ~99.8%% of all the mass\n    in the solar system" % planet["diameter_km"]
		"Mercury":
			info_label.text = ("• type: rocky planet\n"
				+ "• surface: cratered, with\n"
				+ "  extreme temp. variations\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: smallest and\n"
				+ "  fastest planet") % mercury["diameter_km"] # "• type: rocky planet\n• surface: cratered, with extreme temperature shifts \n• diameter: %.0f km\n• fun fact: the smallest and fastest planet" % planet["diameter_km"]
		"Venus":
			info_label.text = ("• type: rocky planet\n"
				+ "• surface: volcanic plains\n"
				+ "  and highlands\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: a day lasts\n"
				+ "  longer than a year") % venus["diameter_km"] #"• type: rocky planet\n• surface: volcanic plains and mountains \n• diameter: %.0f km\n• fun fact: a day on this planet lasts longer than its year" % planet["diameter_km"]
		"Earth":
			info_label.text = ("• type: rocky planet\n"
				+ "• surface: oceans, valleys,\n"
				+ "  mountains, volcanoes\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: only known\n"
				+ "  planet with life") % earth["diameter_km"] #"• type: rocky planet\n• surface: mountains, valleys, volcanoes, liquid water \n• diameter: %.0f km\n• fun fact: the only known planet that supports life" % planet["diameter_km"]
		"Mars":
			info_label.text =  ("• type: rocky planet\n"
				+ "• surface: dusty desert with\n"
				+ "  cold temperatures\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: once had rivers\n"
				+ "  and lakes") % mars["diameter_km"]#"• type: rocky planet\n• surface: dusty, cold, desert world \n• diameter: %.0f km\n• fun fact: once had flowing rivers and lakes" % planet["diameter_km"]
		"Jupiter":
			info_label.text = ("• type: gas giant\n"
				+ "• composition: hydrogen,\n"
				+ "  helium\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: hosts a storm\n"
				+ "  bigger than Earth") % jupiter["diameter_km"] #"• type: gas giant\n• composition: hydrogen, helium \n• diameter: %.0f km\n• fun fact: has a storm larger than Earth, raging for at least 350 years" % planet["diameter_km"]
		"Saturn":
			info_label.text = ("• type: gas giant\n"
				+ "• composition: hydrogen,\n"
				+ "  helium, trace gases\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: farthest planet\n"
				+ "  visible to naked eye") % saturn["diameter_km"] #"• type: gas giant\n• composition: hydrogen, helium, traces of other gases \n• diameter: %.0f km\n• fun fact: farthest planet from Earth discovered by the unaided human eye" % planet["diameter_km"]
		"Uranus":
			info_label.text = ("• type: ice giant\n"
				+ "• composition: hydrogen,\n"
				+ "  helium, methane\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: tilted ~98°,\n"
				+ "  it rolls on its side") % uranus["diameter_km"] # "• type: ice giant\n• composition: hydrogen, helium, methane (blue color) \n• diameter: %.0f km\n• fun fact: axial tilt ~98°, it rolls on its side!" % planet["diameter_km"]
		"Neptune":
			info_label.text = ("• type: ice giant\n"
				+ "• composition: hydrogen,\n"
				+ "  helium, methane\n"
				+ "• diameter: %.0f km\n"
				+ "• fun fact: has the fastest\n"
				+ "  winds in the solar system") % neptune["diameter_km"] #"• type: ice giant\n• composition: hydrogen, helium, methane \n• diameter: %.0f km\n• fun fact: the windiest planet in the solar system" % planet["diameter_km"]
		_:
			info_label.text = "• type: unknown\n• diameter: %.0f km\n• info not available" % planet["diameter_km"]

func sort_planets_by_distance_to_sun():
	var sun_transform: Transform3D = Transform3D.IDENTITY

	# 先找Sun的坐标
	for planet_entry in planet_models:
		if planet_entry["name"] == "Sun":
			sun_transform = planet_entry.get("last_world_transform", Transform3D.IDENTITY)
			break

	if sun_transform == Transform3D.IDENTITY:
		push_warning("Sun transform not found!")
		return

	var distances = []
	for planet_entry in planet_models:
		var planet = planet_entry
		var last_transform: Transform3D = planet.get("last_world_transform", Transform3D.IDENTITY)
		if last_transform == Transform3D.IDENTITY:
			continue

		var distance = sun_transform.origin.distance_to(last_transform.origin)
		distances.append({"name": planet["name"], "distance": distance})

	# 按距离排序
	distances.sort_custom(func(a, b): return a["distance"] < b["distance"])
	
	# Print Distances
	#for d in distances:
		#print("%s: %.3f" % [d["name"], d["distance"]])

	return distances.map(func(d): return d["name"])
	
	
func color_planet_labels(current_order: Array, expected_order: Array):
	#print("current_order:", current_order)
	for planet_entry in planet_models:
		var planet_name = planet_entry["name"]

		#var label3d = planet_entry["label"]
		var label3d = planet_labels[planet_name]
		if label3d == null:
			print("No Label")
			continue

		# 期望的位置
		var expected_index = expected_order.find(planet_name)
		# 当前的位置
		var current_index = current_order.find(planet_name)
		#print("index compare: expected: ", expected_index, ", current: ", current_index)
		
		if expected_index == current_index:
			label3d.modulate = Color(0, 1, 1)  # 蓝色: 正确
		else:
			label3d.modulate = Color(1, 0, 0)  # 红色: 错误
			
func _on_ToggleInfoButton_pressed():
	show_info = !show_info
	_update_info_visibility()
	if show_info:
		toggle_info_button.text = "Hide Info"
	else:
		toggle_info_button.text = "Show Info"

func _update_info_visibility():
	sun_info_label.visible = show_info
	mercury_info_label.visible = show_info
	venus_info_label.visible = show_info
	earth_info_label.visible = show_info
	mars_info_label.visible = show_info
	jupiter_info_label.visible = show_info
	saturn_info_label.visible = show_info
	uranus_info_label.visible = show_info
	neptune_info_label.visible = show_info
