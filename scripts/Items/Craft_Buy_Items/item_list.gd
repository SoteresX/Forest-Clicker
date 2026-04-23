extends VBoxContainer

@export var is_shop: bool = false
@export var item_resources: Array[ItemData] = []

func _ready():
	visibility_changed.connect(_on_visibility_changed)
	for data in item_resources:
		var item_ui = preload("res://scenes/Craft_ItemEntry.tscn").instantiate()
		add_child(item_ui)
		
		item_ui.craft_requested.connect(_on_craft_attempt)
		item_ui.setup(data, is_shop)
		
func _on_craft_attempt(data: ItemData):
	var material = data.cost_type
	var cost = data.price
	
	if Global.inventory.get(material,0) >= cost:
		Global.update_item(material, -cost)
		
		if data.reward_type != "":
			Global.update_item(data.reward_type, data.reward_amount)
			
		if data.reward_type != "seed":
			data.price = int(data.price * 1.5)
		refresh_all_items()
	else:
		print("Not enough")
		
func refresh_all_items():
	for child in get_children():
		var data = child.itemEntry_data
		
		if data.max_level > 0:
			var current_level = Global.inventory.get(data.reward_type, 0)
		
			if current_level >= data.max_level:
				child.visible = false
				continue
				
		if child.has_method("setup"):
			child.setup(data, is_shop)
			child.visible = true

func _on_visibility_changed():
	if visible:
		refresh_all_items()
