extends HBoxContainer

var itemEntry_data : ItemData
signal craft_requested(item_data: ItemData)

@onready var action_button: Button = $BuyReq/Craft


func setup(data: ItemData, is_shop: bool = false):
	itemEntry_data = data
	
	get_node("Text/ItemName").text = data.name
	get_node("Text/ItemDescription").text = data.description
	get_node("ItemBorder/ItemIcon").texture = data.icon
	get_node("BuyReq/Item_Requirement/AmountNeeded").text = str(data.price)
	get_node("BuyReq/Item_Requirement/ItemNeeded").texture = data.requirement_icon
	if is_shop:
		get_node("BuyReq/Craft").text = "Buy"
	else:
		get_node("BuyReq/Craft").text = "Craft"
		
	if not Global.inventory_updated.is_connected(update_affordability_visual):
		Global.inventory_updated.connect(update_affordability_visual)
		
	update_affordability_visual()
	
func update_affordability_visual():
	if not itemEntry_data: return
	
	var can_afford = false
	var mat = itemEntry_data.cost_type
	var cost = itemEntry_data.price
	
	if Global.inventory.get(mat, 0) >= cost:
		can_afford = true
	
	# Apply Visuals to the Button
	var current_style = action_button.get_theme_stylebox("normal").duplicate()
	var current_hover = action_button.get_theme_stylebox("hover").duplicate()
	
	if can_afford:
		current_style.bg_color = Color(0.314, 0.933, 0.0, 0.3) # Green
		current_hover.bg_color = Color(0.0, 3.092, 0.156, 0.831)
	else:
		current_style.bg_color = Color(0.10, 0.10, 0.10, 0.60) # Dark Grey
		current_hover.bg_color = Color(0.432, 0.159, 0.002, 0.6)
		
	action_button.add_theme_stylebox_override("normal", current_style)
	action_button.add_theme_stylebox_override("hover", current_hover)

func _on_craft_pressed() -> void:
	craft_requested.emit(itemEntry_data)
