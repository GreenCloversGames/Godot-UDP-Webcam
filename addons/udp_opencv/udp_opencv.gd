@tool
extends EditorPlugin
var windows_export_plugin = WindowsExportPlugin.new()

var thread:Thread

func _enter_tree() -> void:
	add_export_plugin(windows_export_plugin)
	pass


func _exit_tree() -> void:
	remove_export_plugin(windows_export_plugin)
	# Clean-up of the plugin goes here.
	pass

class WindowsExportPlugin extends EditorExportPlugin:
	func _get_name() -> String:
		return "WindowsExportPlugin"
	func _export_begin(_features: PackedStringArray, _is_debug: bool, path: String, _flags: int) -> void:
		copy_directory_contents("res://addons/udp_opencv/Python/", path.get_base_dir()+"/Python")

	func copy_directory_contents(src_dir_path: String, dest_dir_path: String) -> void:
		print("Starting the copy!")
		var src_dir = DirAccess.open(src_dir_path)
		var dest_dir = DirAccess.open(dest_dir_path)
		
		if src_dir == null:
			print("Failed to open source directory: " + src_dir_path)
			return

		if dest_dir == null:
			# Try to create the destination directory if it doesn't exist
			var create_dir = DirAccess.open("res://")
			if create_dir.make_dir(dest_dir_path) != OK:
				print("Failed to create destination directory: " + dest_dir_path)
				return
			dest_dir = DirAccess.open(dest_dir_path)

		var file_name = src_dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				var src_file_path = src_dir_path.path_join(file_name)
				var dest_file_path = dest_dir_path.path_join(file_name)

				if src_dir.current_is_dir():
					copy_directory_contents(src_file_path, dest_file_path)
				else:
					copy_file(ProjectSettings.globalize_path(src_file_path), ProjectSettings.globalize_path(dest_file_path))

	func copy_file(src_file_path: String, dest_file_path: String) -> void:
		DirAccess.copy_absolute(src_file_path, dest_file_path)
		return
