class_name DataManager
extends Node


const ACCOUNT_STORAGE_PATH: String = "res://source/server/data/collections/account_storage.tres"
var account_storage: AccountStorage


func _ready() -> void:
    load_data()


func load_data() -> void:
    if not ResourceLoader.exists(ACCOUNT_STORAGE_PATH): return
    account_storage = load(ACCOUNT_STORAGE_PATH)


func save_data() -> void:
    if not ResourceLoader.exists(ACCOUNT_STORAGE_PATH): return
    ResourceSaver.save(account_storage, ACCOUNT_STORAGE_PATH)