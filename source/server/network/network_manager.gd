class_name NetworkManagerServer
extends Node


signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)


const PORT: int = 8088
const MAX_PLAYERS: int = 100
const ACTIONS_PATH: String = "res://source/server/network/actions/"

@export var data_manager: DataManager

var connected_peers: Array[int]
var network_actions: Dictionary[String, NetworkAction]


func start_server() -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var err: Error = peer.create_server(PORT, MAX_PLAYERS)
	
	if err != OK:
		printerr('Failed to create server. Err: %d' % error_string(err))
		return
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	load_actions()

	multiplayer.multiplayer_peer = peer


func _on_peer_connected(peer_id: int) -> void:
	print('Peer %d has connected.' % peer_id)
	connected_peers.append(peer_id)
	player_connected.emit(peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	print('Peer %d has disconnected.' % peer_id)
	connected_peers.erase(peer_id)
	player_disconnected.emit(peer_id)


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


func disconnect_player(peer_id: int) -> void:
	if not peer_id in connected_peers: return
	multiplayer.multiplayer_peer.disconnect_peer(peer_id)