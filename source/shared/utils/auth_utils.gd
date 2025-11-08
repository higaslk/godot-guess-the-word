class_name AuthUtils
extends RefCounted


static var _password_min_length: int = 6
static var _password_max_length: int = 24

static var _username_min_length: int = 3
static var _username_max_length: int = 10


static func validate_password(password: String) -> Dictionary:
	if password.is_empty(): 
		return _result(false, "Please add a password.")

	if password.length() < _password_min_length: 
		return _result(false, "Password need a minimum of %d characters." % _password_min_length)

	if password.length() > _password_max_length: 
		return _result(false, "Password need a maximum of %d characters." % _password_max_length)

	if " " in password: 
		return _result(false, "Ensure password doens't has any space.")
	
	if not _has_special_char(password):
		return _result(false, "Password need atleast 1 special character.")

	return _result(true, "")


static func validate_username(username: String) -> Dictionary:
	if username.is_empty(): 
		return _result(false, "Please add a username.")

	if username.length() < _username_min_length: 
		return _result(false, "Username need a minimum of %d characters." % _username_min_length)

	if username.length() > _username_max_length: 
		return _result(false, "Username need a maximum of %d characters." % _username_max_length)

	if not username.is_valid_ascii_identifier(): 
		return _result(false, "Username need to have only letters, digits and underscores.")

	return _result(true, "")


static func validate_credentials(username: String, password: String) -> Dictionary:
	var result = validate_username(username)
	if not result["is_valid"]:
		return result
	
	result = validate_password(password)
	if not result["is_valid"]:
		return result

	return {"is_valid": true, "error_msg": ""}


static func _has_special_char(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z\\s]")
	return regex.search(text) != null


static func _result(is_valid: bool, msg: String) -> Dictionary:
	return {'is_valid': is_valid, "error_msg": msg}