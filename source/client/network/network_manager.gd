class_name NetworkManagerClient
extends Node


signal response_received(args: Dictionary)
signal login_changed(is_logged: bool)


const PORT: int = 8088
const ADDRESS: String = '127.0.0.1'

@export var client: MainClient

var peer: ENetMultiplayerPeer
var logged_to_server: bool = false:
    set(value):
        logged_to_server = value
        login_changed.emit(value)


func connect_to_server() -> void:
    peer = ENetMultiplayerPeer.new()
    var err: Error = peer.create_client(ADDRESS, PORT)

    if err != OK:
        printerr('Failed to create client, Err: %d' % error_string(err))
        return
    
    multiplayer.connected_to_server.connect(_on_server_connection)
    multiplayer.connection_failed.connect(_on_server_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)

    multiplayer.multiplayer_peer = peer


func _on_server_connection() -> void:
    print('Connected to server as: %d' % multiplayer.get_unique_id())


func _on_server_connection_failed() -> void:
    print('Failed to connect.')
    close_connection()


func _on_server_disconnected() -> void:
    print('Disconnected from server')
    close_connection()


func close_connection() -> void:
    multiplayer.multiplayer_peer = null
    peer.close()
    logged_to_server = false


@rpc("authority", "call_remote", "reliable")
func do_action(_action_name: StringName, _args: Dictionary) -> void:
    pass


@rpc("any_peer", "call_local", "reliable")
func _action_response(args: Dictionary) -> void:
    response_received.emit(args)