extends Node

signal inventory_updated
signal trade_finished

signal request_exp(amount: float)
signal leveled_up(new_level)
signal exp_changed(current_exp, target_exp)

#Level values
var current_level: int = 1
var current_exp: float = 0.0
var target_exp: float = 100.0
var level_multiplier: float = 1.5

var wood_timer: Timer

var current_tool: String = ""
var crafting_recipes: Array = []
var shop_items: Array = []

var item_data = {
	"water": {"category": "Items", "min_show_amount": 0},
	"seed": {"category": "Items", "min_show_amount": 0},
	"wood": {"category": "Items", "min_show_amount": 0},
	"money": {"category": "Items", "min_show_amount": 0},
	"soil": {"category": "Items", "min_show_amount": 2, "display_offset": 1},
	"fertilizer": {"category": "Items", "min_show_amount": 1},
	"plot": {"category": "Items", "min_show_amount": -1},
	"bucket": {"category": "Tools", "min_show_amount": 0},
	"axe": {"category": "Tools", "min_show_amount": 0},
	"shovel": {"category": "Tools", "min_show_amount": 0},
	"task_board": {"category": "Tools", "min_show_amount": -1},
	"task": {"category": "Items", "min_show_amount": -1}
}

##Player inventory
var inventory = {
	"water": 0,
	"seed": 10,
	"wood": 999,
	"money": 999,
	"axe": 1,
	"shovel": 1,
	"bucket": 1,
	"soil": 1,
	"fertilizer": 0,
	"plot": 1,
	"task_board": 0,
	"task": 1
}

#Initialize Resources for Crafting and Shopping menus
func _ready() -> void:
	request_exp.connect(gain_exp)
	crafting_recipes = load_resources_from_folder("res://scripts/resources/Craft/")
	shop_items = load_resources_from_folder("res://scripts/resources/Shop/")
	
func load_resources_from_folder(path: String) -> Array:
	var items = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				items.append(load(path + file_name))
			file_name = dir.get_next()
	return items

#Update a value of an inventory item
func update_item(name: String, amount: int):
	inventory[name] += amount		
	inventory_updated.emit()

#Set a value of an inventory item
func set_item(name: String, amount: int):
	inventory[name] = amount
	inventory_updated.emit()

#Calculate max water
func get_max_water() -> int:
	var base_water = 15
	var level = inventory["bucket"]
	var gain_per_level = 5

	return base_water + (level * gain_per_level)

#Check if the player can afford something to complete a transaction of any kind
func can_afford(recipe: Dictionary) -> bool:
	for material in recipe.keys():
		if inventory.get(material, 0) < recipe[material]:
			return false
	return true

#Check if the player can afford any item from the Crafting menu
func can_afford_any_craft() -> bool:
	for item in crafting_recipes:
		
		var mat = item.cost_type
		var cost = item.price
		if inventory.get(mat, 0) >= cost:
			return true
	return false

#Check if the player can afford any item from the Shop menu
func can_afford_any_shop() -> bool:
	for item in shop_items:
		if inventory.get("money", 0) >= item.price: 
			return true
	return false

#Check if the player can afford anything to display notifier
func can_afford_any_trade() -> bool:
	var trade_menu = get_tree().root.find_child("Trade", true, false)
	if not trade_menu: 
		return false
	
	for slot in trade_menu.get_children():
		# This calls the can_afford() function inside trade_item_entry.gd
		# Because we added 'if is_on_cooldown: return false' there,
		# this will correctly skip slots that are counting down.
		if slot.has_method("can_afford") and slot.can_afford():
			return true
	
	var all_children = trade_menu.find_children("*", "", true, false)
	for child in all_children:
		if child.has_method("can_afford"):
			if child.can_afford():
				return true
	return false

func gain_exp(amount: float):
	current_exp += amount
	
	while current_exp >= target_exp:
		level_up()
		
	exp_changed.emit(current_exp, target_exp)
	
func level_up():
	current_exp -= target_exp
	current_level +=1
	
	target_exp = target_exp * level_multiplier
	leveled_up.emit(current_level)
