extends Node

var server: UDPServer

@export var webcam_number = 0

@onready var addon_path = "res://addons/udp_opencv/"
@onready var py_env_path = ProjectSettings.globalize_path(addon_path + "/Python/Scripts/python.exe")
@onready var webcam_path = ProjectSettings.globalize_path(addon_path + "/Python/webcam.py")
@onready var webcam_exe_path = (func():
	if OS.has_feature("editor"):
		return ProjectSettings.globalize_path("res://addons/udp_opencv/Python/dist/Webcam/Webcam.exe")
	else:
		return OS.get_executable_path().get_base_dir().path_join("Python/dist/Webcam/Webcam.exe")
	).call()
var webcam_pid : int

signal image_ready(image)

func _ready() -> void:
	server = UDPServer.new()
	server.listen(7486)
	var output = []
	webcam_pid = OS.create_process(
		#"python",
		#[webcam_path]
		webcam_exe_path,
		[1]
#		.start(func():
#		OS.execute(py_env_path, [webcam_path], output, false, false)
		)
	
#	webcam_pid = output[]
	print(webcam_pid)

func _exit_tree() -> void:
	server.stop()
	OS.kill(webcam_pid)
	

func _process(_delta: float) -> void:
	server.poll()
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		var im = Image.new()
		im.load_jpg_from_buffer(packet)
		image_ready.emit(im)
