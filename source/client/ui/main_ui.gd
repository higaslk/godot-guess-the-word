extends Control


@onready var menu_container: MarginContainer = $MainMenuContainer
@onready var login_container: MarginContainer = $LoginMenuContainer
@onready var signup_container: MarginContainer = $SignupMenuContainer
@onready var back_button: Button = $BackButton

@export var client: MainClient

var _current_menu: MarginContainer

var _password_min_length: int = 6
var _password_max_length: int = 24

var _username_min_length: int = 3
var _username_max_length: int = 10


func _ready() -> void:
	_current_menu = menu_container

	$MainMenuContainer/MenuContainer/ButtonsContainer/LoginButton.pressed.connect(_on_menu_login_button_pressed)
	$MainMenuContainer/MenuContainer/ButtonsContainer/SignButton.pressed.connect(_on_menu_sign_button_pressed)
	$MainMenuContainer/MenuContainer/ButtonsContainer/GuestButton.pressed.connect(_on_menu_guest_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)


func _on_back_button_pressed() -> void:
	swap_menu(menu_container)
	toggle_visibility(back_button)


func _on_menu_login_button_pressed() -> void:
	swap_menu(login_container)
	toggle_visibility(back_button)


func _on_menu_sign_button_pressed() -> void:
	swap_menu(signup_container)
	toggle_visibility(back_button)

	$SignupMenuContainer/MenuContainer/SignButton.pressed.connect(_on_signup_signin_button_pressed)


func _on_menu_guest_button_pressed() -> void:
	pass


func _on_login_login_button_pressed() -> void:
	pass


func _on_signup_signin_button_pressed() -> void:
	var username: String = $SignupMenuContainer/MenuContainer/UsernameInput.text
	var password: String = $SignupMenuContainer/MenuContainer/PasswordInput.text
	var password_repeat: String = $SignupMenuContainer/MenuContainer/PasswordRepeatInput.text

	if password != password_repeat:
		popup_error("Password is not equal. Ensure both password box are the same.")
		return

	var auth_validate = AuthUtils.validate_username(username, _username_min_length, _username_max_length)
	if not auth_validate["is_valid"]:
		popup_error(auth_validate.error_msg)
		return
	
	auth_validate = AuthUtils.validate_password(password, _password_min_length, _password_max_length)
	if not auth_validate["is_valid"]:
		popup_error(auth_validate.error_msg)
		return
	
	create_account(username, password)
	var result: Dictionary = await client.network_manager.response_received
	
	if not result["is_valid"]:
		popup_error(result["error_msg"])
		return
	
	print("created account")


func create_account(username: String, password: String) -> void:
	client.network_manager.do_action.rpc_id(
		1,
		&"account_register", 
		{"username": username, "password": password}
	)


func login() -> void:
	pass


func connect_guest() -> void:
	pass


func popup_error(msg: String):
	var popup_panel: PanelContainer = $Popup
	var popup_text: Label = $Popup/WarnText

	toggle_visibility(popup_panel)
	popup_text.text = msg
	await get_tree().create_timer(4).timeout
	toggle_visibility(popup_panel)


func toggle_visibility(object: Control) -> void:
	object.visible = not object.visible


func swap_menu(menu: MarginContainer) -> void:
	if menu == _current_menu: return

	toggle_visibility(_current_menu)
	toggle_visibility(menu)

	_current_menu = menu
