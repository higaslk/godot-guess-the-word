class_name FileUtils
extends RefCounted


static func get_files_at(dir_path: String, extension: String) -> Array:
    var dir: DirAccess = DirAccess.open(dir_path)
    if not dir: return []

    var dir_files: PackedStringArray = dir.get_files()
    var files: Array = []

    for file_name: String in dir_files:
        if files.has(file_name): continue
        if not file_name.ends_with(extension): continue

        files.append(file_name)
        
    return files
