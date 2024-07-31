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
		copy_directory_contents("res://addons/udp_opencv/Python/dist", path.get_base_dir()+"/Python/dist")

	func copy_directory_contents(src_dir_path: String, dest_dir_path: String) -> void:
		var files = DirAccess.get_files_at(src_dir_path)
		for file in files:
			DirAccess.copy_absolute(src_dir_path.path_join(file), dest_dir_path.path_join(file))
		var dirs = DirAccess.get_directories_at(src_dir_path)
		for dir in dirs:
			var new_dir = dest_dir_path.path_join(dir)
			if not DirAccess.dir_exists_absolute(new_dir):
				DirAccess.make_dir_absolute(new_dir)
			copy_directory_contents(src_dir_path.path_join(dir), new_dir) 

		
