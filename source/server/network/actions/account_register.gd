extends NetworkAction


func action(_peer_id: int, netmanager: NetworkManagerServer, args: Dictionary) -> Dictionary:
	if args.is_empty(): return {}

	var account_storage: AccountStorage = netmanager.data_manager.account_storage
	var username: String = args["username"]
	var password: String = args["password"]
	var result: Dictionary = create_account(username, password, account_storage)

	netmanager.data_manager.save_data()
	return result


func create_account(username: String, password: String, account_storage: AccountStorage) -> Dictionary:
	var result: Dictionary = AuthUtils.validate_credentials(username, password)
	if not result["is_valid"]:
		return result
	
	if account_storage.accounts.has(username):
		return {"is_valid": false, "error_msg": "A account with this username already exists."}
	
	var new_account: Dictionary = {"username": username, "password": password, "data": {}}
	account_storage.accounts[username] = new_account
	
	return {"is_valid": true}
