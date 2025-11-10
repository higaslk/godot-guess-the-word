extends Control


@onready var menu_container: MarginContainer = $MainMenuContainer
@onready var login_container: MarginContainer = $LoginMenuContainer
@onready var signup_container: MarginContainer = $SignupMenuContainer
@onready var back_button: Button = $BackButton

@export var client: MainClient

var _current_menu: MarginContainer


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

	$LoginMenuContainer/MenuContainer/LoginButton.pressed.connect(_on_login_login_button_pressed)


func _on_menu_sign_button_pressed() -> void:
	swap_menu(signup_container)
	toggle_visibility(back_button)

	$SignupMenuContainer/MenuContainer/SignButton.pressed.connect(_on_signup_signin_button_pressed)


func _on_menu_guest_button_pressed() -> void:
	connect_guest()


func _on_login_login_button_pressed() -> void:
	var username: String = $LoginMenuContainer/MenuContainer/UsernameLoginBox.text
	var password: String = $LoginMenuContainer/MenuContainer/PasswordLoginBox.text

	login(username, password)


func _on_signup_signin_button_pressed() -> void:
	var username: String = $SignupMenuContainer/MenuContainer/UsernameInput.text
	var password: String = $SignupMenuContainer/MenuContainer/PasswordInput.text
	var password_repeat: String = $SignupMenuContainer/MenuContainer/PasswordRepeatInput.text

	if password != password_repeat:
		popup("Password is not equal. Ensure both password box are the same.")
		return

	create_account(username, password)


func create_account(username: String, password: String) -> void:
	var result: Dictionary = AuthUtils.validate_credentials(username, password)

	if not result["is_valid"]:
		popup(result["error_msg"])
		return
	
	client.network_manager.do_action.rpc_id(
		1,
		&"account_register",
		{"username": username, "password": password}
	)
	result = await client.network_manager.response_received
	
	if not result["is_valid"]:
		popup(result["error_msg"])
		return
	
	swap_menu(login_container)


func login(username: String, password: String) -> void:
	if username.is_empty():
		popup("Please fill the username box.")
		return
	
	if password.is_empty():
		popup("Please fill the password box.")
		return

	client.network_manager.do_action.rpc_id(
		1,
		&"login",
		{"username": username, "password": password}
	)
	var result: Dictionary = await client.network_manager.response_received
	
	if not result["is_valid"]:
		popup(result["error_msg"])
		return
	
	client.client_data[username] = result["data"]
	client.logged_to_server = true


func connect_guest() -> void:
	client.network_manager.do_action.rpc_id(
		1,
		&"login_guest",
		{}
	)

	var result: Dictionary = await client.network_manager.response_received
	var account_data = result["account_data"]

	client.client_data[account_data["username"]] = account_data["data"]
	client.logged_to_server = true


func popup(msg: String):
	var popup_panel: PanelContainer = $Popup
	var popup_text: Label = $Popup/WarnText

	if popup_panel.visible: return

	toggle_visibility(popup_panel)
	popup_text.text = msg

	await get_tree().create_timer(2).timeout
	toggle_visibility(popup_panel)


func toggle_visibility(object: Control) -> void:
	object.visible = not object.visible


func swap_menu(menu: MarginContainer) -> void:
	if menu == _current_menu: return

	toggle_visibility(_current_menu)
	toggle_visibility(menu)

	_current_menu = menu
