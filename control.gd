class_name PrototypeClicker
extends Control

func _ready() -> void:
	for tree in get_tree().get_nodes_in_group("Trees"):
		tree.water_used.connect(used_water)
		tree.wood_earned.connect(add_wood)

func add_wood(amount : int) -> void:
	Global.update_item("wood", amount)
	
func used_water(amount : int) -> void:
	Global.update_item("water", -amount)
	
func refill_water(amount: int) -> void:
	var max_water = Global.get_max_water()
	var current_water = Global.inventory["water"]
	
	if current_water >= max_water: return
		
	var final_water = min(current_water + amount, max_water)
	Global.set_item("water", final_water)
