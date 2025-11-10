class_name MainServer
extends Node


@export var network_manager: NetworkManagerServer


func _ready() -> void:
	network_manager.start_server()
