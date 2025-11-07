class_name NetworkManagerServer
extends Node


const ACTIONS_PATH: String = "res://source/server/network/actions/"

@export var data_manager: DataManager

var network_actions: Dictionary[String, NetworkAction]


func _ready() -> void:
	load_actions()


func load_actions() -> void:
	var actions_file: Array = FileUtils.get_files_at(ACTIONS_PATH, ".gd")

	for file_name: String in actions_file:
		var action: NetworkAction = load(ACTIONS_PATH + file_name).new()
		network_actions[file_name.trim_suffix(".gd")] = action


@rpc("any_peer", "call_local", "reliable")
func do_action(action_name: StringName, args: Dictionary) -> void:
	var peer_id: int = multiplayer.get_remote_sender_id()

	if not network_actions.has(action_name):
		_action_response.rpc_id(peer_id, {})
	
	var result: Dictionary = network_actions[action_name].call(&"action", peer_id, self, args)
	if not result.is_empty():
		_action_response.rpc_id(peer_id, result)


@rpc("authority", "call_remote", "reliable")
func _action_response(_args: Dictionary) -> void:
	pass
