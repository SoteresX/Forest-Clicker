extends TextureButton

var fixed_texture = preload("res://assets/trade_panel.png")
var broken_texture = preload("res://assets/broken_trade_panel.png")
var fixed_texture_highlight = preload("res://assets/trade_panel_highlight.png")

func _ready() -> void:
	Global.inventory_updated.connect(refresh_visuals)
	Global.trade_finished.connect(refresh_visuals)
	refresh_visuals()

func refresh_visuals() -> void:
	await get_tree().process_frame
	var is_fixed = Global.inventory.get("task_board", 0) > 0
	if is_fixed:
		texture_normal = fixed_texture
		texture_hover = fixed_texture_highlight 
	else:
		texture_normal = broken_texture
		
	var can_trade = Global.can_afford_any_trade()
	
	if has_node("Notification"):
		$Notification.visible = is_fixed and can_trade
		
func _on_pressed() -> void:
	if Global.inventory.get("task_board", 0) > 0:
		open_trade_menu()
	else:
		print("The board is broken! Craft a fix in the menu.")

func open_trade_menu() -> void:
	var menu_manager = get_tree().root.find_child("MenuButtons", true, false)
	
	if not menu_manager:
		print("Error: Could not find 'MenuButtons' node!")
		return

	if menu_manager.has_method("_on_menu_pressed"):
		print("Success! Opening Trade Menu on: ", menu_manager.name)
		menu_manager._on_menu_pressed("Trade")
	else:
		print("Error: The node ", menu_manager.name, " exists, but I don't see the script on it!")
