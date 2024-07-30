extends Node

var server: UDPServer

@onready var addon_path = "res://addons/udp_opencv/"
@onready var py_env_path = ProjectSettings.globalize_path(addon_path + "/Python/Scripts/python.exe")
@onready var webcam_path = ProjectSettings.globalize_path(addon_path + "/Python/webcam.py")

var webcam_pid : int

signal image_ready(image)

func _ready() -> void:
	server = UDPServer.new()
	server.listen(4242)
	var output = []
	webcam_pid = OS.create_process(
		py_env_path,
		[webcam_path]
#		.start(func():
#		OS.execute(py_env_path, [webcam_path], output, false, false)
		)
	
#	webcam_pid = output[]
	print(output)

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
