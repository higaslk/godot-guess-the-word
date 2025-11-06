class_name AuthUtils
extends RefCounted


func validate_password(password: String, min_length: int, max_length: int) -> Dictionary:
    if password.is_empty(): 
        return _result(false, "Please add a password.")

    if password.length() < min_length: 
        return _result(false, "Password need a minimum of %d characters." % min_length)

    if password.length() > max_length: 
        return _result(false, "Password need a maximum of %d characters." % max_length)

    if " " in password: 
        return _result(false, "Ensure password doens't has any space.")
    
    if not _has_special_char(password):
        return _result(false, "Password need atleast 1 special character.")

    return _result(true, "")


func validate_username(username: String, min_length: int, max_length: int) -> Dictionary:
    if username.is_empty(): 
        return _result(false, "Please add a username.")

    if username.length() < min_length: 
        return _result(false, "Username need a minimum of %d characters." % min_length)

    if username.length() > max_length: 
        return _result(false, "Username need a maximum of %d characters." % max_length)

    if not username.is_valid_ascii_identifier(): 
        return _result(false, "Username need to have only letters, digits and underscores.")

    return _result(true, "")


func _has_special_char(text: String) -> bool:
    var regex = RegEx.new()
    regex.compile("[^a-zA-Z\\s]")
    return regex.search(text) != null


func _result(is_valid: bool, msg: String) -> Dictionary:
    return {'is_valid': is_valid, "error_msg": msg}