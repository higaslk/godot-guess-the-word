class_name MainClient
extends Node


@export var network_manager: NetworkManagerClient
@export var game_manager: GameManager

var client_data: Dictionary
var users_data: Dictionary[String, Dictionary]


func _ready() -> void:
    network_manager.connect_to_server()