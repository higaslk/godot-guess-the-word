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


func _on_menu_sign_button_pressed() -> void:
	swap_menu(signup_container)
	toggle_visibility(back_button)


func _on_menu_guest_button_pressed() -> void:
	pass


func _on_login_login_button_pressed() -> void:
	pass


func _on_signup_signin_button_pressed() -> void:
	pass


func toggle_visibility(object: Control) -> void:
	object.visible = not object.visible


func swap_menu(menu: MarginContainer) -> void:
	if menu == _current_menu: return

	toggle_visibility(_current_menu)
	toggle_visibility(menu)

	_current_menu = menu
