class_name NetworkManagerClient
extends Node

signal response_received(args: Dictionary)


@rpc("authority", "call_remote", "reliable")
func do_action(_action_name: StringName, _args: Dictionary) -> void:
    pass


@rpc("any_peer", "call_local", "reliable")
func _action_response(args: Dictionary) -> void:
    response_received.emit(args)