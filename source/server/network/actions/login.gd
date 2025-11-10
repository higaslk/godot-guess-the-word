extends NetworkAction

func action(
_peer_id: int,
netmanager: NetworkManagerServer,
args: Dictionary
) -> Dictionary:
    var username: String = args["username"]
    var password: String = args["password"]
    var account_storage: AccountStorage = netmanager.data_manager.account_storage
    var result: Dictionary = login(username, password, account_storage)
    
    return result


func login(username: String, password: String, account_storage: AccountStorage) -> Dictionary:
    var account = account_storage.accounts.get(username)
    if not account: return {"is_valid": false, "error_msg": "Could not find a account with this username."}

    var account_password: String = account["password"]
    if password != account_password: return {"is_valid": false, "error_msg": "Password is wrong, please verify the password again."}

    var account_data: Dictionary = account["data"]
    return {"is_valid": true, "data": account_data}