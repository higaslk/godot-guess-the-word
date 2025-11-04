class_name MainClient
extends Node


signal connection_changed(is_connected: bool)

const PORT: int = 8088
const ADDRESS: String = '127.0.0.1'

var peer: ENetMultiplayerPeer

var is_connected_to_server: bool = false:
    set(value):
        is_connected_to_server = value
        connection_changed.emit(value)


func _ready() -> void:
    multiplayer.connected_to_server.connect(_on_server_connection)
    multiplayer.connection_failed.connect(_on_server_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)

    connect_to_server()


func _on_server_connection() -> void:
    print('Connected to server as: %d' % multiplayer.get_unique_id())
    is_connected_to_server = true


func _on_server_connection_failed() -> void:
    print('Failed to connect.')
    close_connection()


func _on_server_disconnected() -> void:
    print('Disconnected from server')
    close_connection()


func connect_to_server() -> void:
    peer = ENetMultiplayerPeer.new()
    var err: Error = peer.create_client(ADDRESS, PORT)

    if err != OK:
        printerr('Failed to create client, Err: %d' % error_string(err))
        return
    
    multiplayer.multiplayer_peer = peer


func close_connection() -> void:
    multiplayer.multiplayer_peer = null
    peer.close()
    is_connected_to_server = false