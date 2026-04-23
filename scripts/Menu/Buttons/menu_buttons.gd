extends HBoxContainer

@onready var menuButtons = %MenuButtons
@onready var title: Label = $"../MenuContainer/TitleBg/Title"
@onready var menu_tooltip: Label = $"../MenuTooltip"
var target_menu: Control = null

func _ready() -> void:
	for Button in menuButtons.get_children():
		Button.pressed.connect(_on_menu_pressed.bind(Button.name))
		Button.mouse_entered.connect(_show_tooltip.bind(Button))
		Button.mouse_exited.connect(_hide_tooltip)
		
	%MenuContainer/CloseButton.pressed.connect(_close_menu)
	Global.inventory_updated.connect(refresh_notifications)
	refresh_notifications()

func refresh_notifications() -> void:
	var can_craft = Global.can_afford_any_craft()
	var can_buy = Global.can_afford_any_shop()
	
	if menuButtons.has_node("Craft/Notification"):
		menuButtons.get_node("Craft/Notification").visible = can_craft
	
	if menuButtons.has_node("Shop/Notification"):
		menuButtons.get_node("Shop/Notification").visible = can_buy
	
func _show_tooltip(btn: Button) -> void:
	menu_tooltip.text = btn.name
	menu_tooltip.show()
	
func _hide_tooltip() -> void:
	menu_tooltip.hide()
		
func _on_menu_pressed(menu_name: String) -> void:
	var next_menu = %MenuContainer.get_node_or_null(menu_name)
	
	if next_menu == null:
		return
	
	if %MenuContainer.visible and target_menu == next_menu:
		_close_menu()
		return
	
	for child in %MenuContainer.get_children():
		if child is Control and child.name not in ["Background", "TitleBg", "CloseButton", "Panel"]:
			child.visible= false
	
	target_menu = %MenuContainer.get_node(menu_name)
	title.text = menu_name
	%MenuContainer.visible = true
	target_menu.visible = true
	
	if title: title.text = menu_name

func _close_menu() -> void:
	%MenuContainer.visible = false
	if target_menu != null:
		target_menu.visible = false
		
	for child in %MenuContainer.get_children():
		if child is Control and child.name not in ["Background", "TitleBg", "CloseButton", "Panel"]:
			child.visible = false
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if %MenuContainer.visible:
			var menu_rect = %MenuContainer.get_global_rect()
			if menu_rect.has_point(event.global_position):
				return
			for btn in menuButtons.get_children():
				if btn is Control and btn.get_global_rect().has_point(event.global_position):
					return 
			
			var taskboard = get_tree().root.find_child("TaskBoard", true, false)
			if taskboard and taskboard.get_global_rect().has_point(event.global_position):
				return
				
			_close_menu()
