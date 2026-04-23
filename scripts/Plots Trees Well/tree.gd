extends TextureButton

enum TreeState {
	NONE,
	PLANTED,
	GROWING,
	GROWN,
	FULL,
	CUTTING,
	READY_TO_RESET
}
signal water_used(amount: int)
signal wood_earned(amount: int)
signal tree_updated

var planted_icon = preload("res://assets/Trees/tree_planted.png")
var growing_icon = preload("res://assets/Trees/tree_growing.png")
var grown_icon = preload("res://assets/Trees/tree_grown.png")
var full_icon = preload("res://assets/Trees/tree_full.png")

var planted_h = preload("res://assets/Trees/tree_planted_highlight.png")
var growing_h = preload("res://assets/Trees/tree_growing_highlight.png")
var grown_h = preload("res://assets/Trees/tree_grown_highlight.png")
var full_h = preload("res://assets/Trees/tree_full_highlight.png")

var current_highlight: Texture2D

var water_in_tree: int
var tree_cuts_left = 10
var tree_state = TreeState.NONE:
	set(value):
		tree_state = value
		tree_updated.emit()
		update_tree_icon()
		if is_hovered():
			_on_mouse_entered()

func _ready():
	update_tree_icon()
	pivot_offset = Vector2(size.x / 2, size.y)
	
	self.water_used.connect(func(amt): Global.update_item("water", -amt))
	self.wood_earned.connect(func(amt): Global.update_item("wood", amt))
	
func plant_tree():
	visible = true
	water_in_tree = 0
	var fertilizer_level = Global.inventory["fertilizer"]
	tree_cuts_left = 10 + fertilizer_level
	
	tree_state = TreeState.PLANTED
	update_tree_icon()
	tree_updated.emit()	

func reset_tree():
	visible = false
	water_in_tree = 0
	tree_cuts_left = 10 + Global.inventory["fertilizer"]
	tree_state = TreeState.NONE
	tree_updated.emit()

func check_tree_state() -> void:
	match tree_state:
		TreeState.PLANTED, TreeState.GROWING, TreeState.GROWN:
			water_tree()
			
		TreeState.FULL:
			if Global.current_tool == "Axe":
				start_cutting()

		TreeState.CUTTING:
			cut_tree()

func water_tree() -> void:
	var soil_level = Global.inventory["soil"]
	var water_per_stage = clamp(11 - soil_level, 5 ,11)
	
	if Global.inventory["water"] > 0 and Global.current_tool == "Bucket":
		water_in_tree += 1
		water_used.emit(1)
		Global.request_exp.emit(1.0)

	if water_in_tree >= water_per_stage and tree_state == TreeState.PLANTED:
		tree_state = TreeState.GROWING

	elif water_in_tree >= (water_per_stage * 2) and tree_state == TreeState.GROWING:
		tree_state = TreeState.GROWN
		
	elif water_in_tree >= (water_per_stage * 3) and tree_state == TreeState.GROWN:
		tree_state = TreeState.FULL
		
	tree_updated.emit()

func start_cutting() -> void:
	tree_state = TreeState.CUTTING
	cut_tree()

func cut_tree() -> void:
	if tree_cuts_left > 0:
		tree_cuts_left -= 1
		wood_earned.emit(Global.inventory["axe"])
		Global.request_exp.emit(1.0)
	else:
		tree_state = TreeState.READY_TO_RESET
		Global.request_exp.emit(5.0)
		
	tree_updated.emit()

func update_tree_icon() -> void:
	match tree_state:
		TreeState.NONE:
			texture_normal = null
			scale = Vector2(1.0, 1.0)
		TreeState.PLANTED:
			texture_normal = planted_icon
			texture_hover = planted_h
			scale = Vector2(1.0, 1.0)
		TreeState.GROWING:
			texture_normal = growing_icon
			texture_hover = growing_h
			scale = Vector2(1.2, 1.2)
		TreeState.GROWN:
			texture_normal = grown_icon
			texture_hover = grown_h
			scale = Vector2(1.5, 1.5)
		TreeState.FULL:
			texture_normal = full_icon
			texture_hover = full_h
			scale = Vector2(1.7, 1.7)
		TreeState.CUTTING:
			texture_normal = full_icon
			texture_hover = full_h

func _on_mouse_entered() -> void:
	if tree_state == TreeState.NONE: return
	
	if (tree_state == TreeState.FULL or tree_state == TreeState.CUTTING):
		if Global.current_tool == "Axe":
			MouseManager.set_cursor("chop")
		else:
			MouseManager.set_cursor("noAxe")
			
	elif tree_state != TreeState.FULL:
		if Global.current_tool == "Bucket":
			if Global.inventory["water"] > 0:
				MouseManager.set_cursor("water")
			else:
				MouseManager.set_cursor("noWater")
		else:
			MouseManager.set_cursor("noBucket")
	else:
		MouseManager.set_cursor("default")
		
func _on_mouse_exited() -> void:
	MouseManager.set_cursor("default")
