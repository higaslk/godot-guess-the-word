extends NetworkAction


var _password_min_length: int = 6
var _password_max_length: int = 24

var _username_min_length: int = 3
var _username_max_length: int = 10


func action(_peer_id: int, netmanager: NetworkManagerServer, args: Dictionary) -> Dictionary:
	if args.is_empty(): return {}

	var account_storage: AccountStorage = netmanager.data_manager.account_storage
	var username: String = args["username"]
	var password: String = args["password"]
	var result: Dictionary = create_account(username, password, account_storage)

	netmanager.data_manager.save_data()
	return result


func create_account(username: String, password: String, account_storage: AccountStorage) -> Dictionary:
	var auth_validate = AuthUtils.validate_username(username, _username_min_length, _username_max_length)
	if not auth_validate.is_valid:
		return auth_validate
	
	auth_validate = AuthUtils.validate_password(password, _password_min_length, _password_max_length)
	if not auth_validate.is_valid:
		return auth_validate
	
	if account_storage.accounts.has(username):
		return {"is_valid": false, "error_msg": "A account with this username already exists."}
	
	var new_account: Dictionary = {"username": username, "password": password, "data": {}}
	account_storage.accounts[username] = new_account
	
	return {"is_valid": true}
