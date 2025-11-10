extends NetworkAction


func action(
    _peer_id: int,
    netmanager: NetworkManagerServer,
    _args: Dictionary
) -> Dictionary:
    var account_storage: AccountStorage = netmanager.data_manager.account_storage
    var new_username: String = "guest-" + AuthUtils.get_unique_string()
    var new_password: String = AuthUtils.get_unique_string()

    account_storage.accounts[new_username] = {
        "username": new_username, 
        "password": new_password, 
        "data": {}
    }
    netmanager.data_manager.save_data()

    return {"is_valid": true, "account_data": {"username": new_username, "data": {}}}

