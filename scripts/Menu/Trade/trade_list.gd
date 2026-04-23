extends Control

@export var trade_scene: PackedScene

func _ready():
	Global.inventory_updated.connect(_fill_missing_tasks)
	_fill_missing_tasks()
	
func _fill_missing_tasks():
	var max_tasks = Global.inventory.get("task", 1)
	var current_slots = get_child_count()
	
	while current_slots < max_tasks:
		create_new_trade()
		current_slots += 1
	
func create_new_trade():
	var new_trade = trade_scene.instantiate()
	add_child(new_trade)
	
func show_tasks():
	visible = true	
