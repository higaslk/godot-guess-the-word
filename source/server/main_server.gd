class_name MainServer
extends Node


signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)

const PORT: int = 8088
const MAX_PLAYERS: int = 100

var connected_peers: Array[int]


func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

    start_server()


func start_server() -> void:
    var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
    var err: Error = peer.create_server(PORT, MAX_PLAYERS)
    
    if err != OK:
        printerr('Failed to create server. Err: %d' % error_string(err))
        return
    
    multiplayer.multiplayer_peer = peer

    if OS.is_debug_build():
        DisplayServer.window_set_title("Server Debug")


func _on_peer_connected(peer_id: int) -> void:
    print('Peer %d has connected.' % peer_id)
    connected_peers.append(peer_id)
    player_connected.emit(peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
    print('Peer %d has disconnected.' % peer_id)
    connected_peers.erase(peer_id)
    player_disconnected.emit(peer_id)


func disconnect_player(peer_id: int) -> void:
    if not peer_id in connected_peers: return
    multiplayer.multiplayer_peer.disconnect_peer(peer_id)