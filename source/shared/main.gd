extends Node


func _ready() -> void:
    var features: Dictionary[String, Callable] = {
        'client': start_as_client,
        'server': start_as_server
    }

    for feature: String in features:
        if OS.has_feature(feature):
            features[feature].call()
            return
    
    printerr('No feature has found.')


func start_as_client() -> void:
    get_tree().change_scene_to_file.call_deferred("res://source/client/main_client.tscn")


func start_as_server() -> void:
    get_tree().change_scene_to_file.call_deferred("res://source/server/main_server.tscn")