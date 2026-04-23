extends Control

@export var inventorySlot_scene: PackedScene
@export var icon_map: Dictionary = {
	#Items
	"water": preload("res://assets/Items/water_drop.png"),
	"wood": preload("res://assets/Items/log.png"),
	"money": preload("res://assets/Items/money.png"),
	"seed": preload("res://assets/Trees/tree_planted.png"),
	"soil": preload("res://assets/Items/enriched_soil.png"),
	"fertilizer": preload("res://assets/Items/fertilizer.png"),
	#Tools
	"axe": preload("res://assets/Tools/wood_axe.png"),
	"bucket": preload("res://assets/Tools/bucket.png"),
	"shovel": preload("res://assets/Tools/shovel.png")
}

@onready var items_grid = $Categories/Items
@onready var tools_grid = $Categories/Tools

func _ready() -> void:
	Global.inventory_updated.connect(build_inventory_ui)
	build_inventory_ui()
	
func build_inventory_ui() -> void:
	for child in items_grid.get_children(): child.queue_free()
	for child in tools_grid.get_children(): child.queue_free()
	
	for key in Global.inventory.keys():
		var actual_amount = Global.inventory[key]
		var data = Global.item_data.get(key, {})
		var min_required = data.get("min_show_amount", 0)
		var category = data.get("category", "Items")
		var display_offset = data.get("display_offset", 0)
		
		if actual_amount < min_required:
			continue
		if min_required == -1:
			continue
		var new_slot = inventorySlot_scene.instantiate()
		new_slot.item_key = key
		
		var visual_amount = actual_amount
		new_slot.item_amount = actual_amount - display_offset
		
		if icon_map.has(key):
			new_slot.item_icon = icon_map[key]
		
		if category == "Items":
			items_grid.add_child(new_slot)
		elif category == "Tools":
			tools_grid.add_child(new_slot)
