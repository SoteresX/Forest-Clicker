extends TextureButton

@onready var tree_node = $Tree

enum State {DIRT, HOLE, GROWING}
var current_state = State.DIRT

var dirt_icon = preload("res://assets/Trees/dirt.png")
var hole_icon = preload("res://assets/Trees/dirt_hole.png")
var dirt_h = preload("res://assets/Trees/dirt_highlight.png")
var hole_h = preload("res://assets/Trees/dirt_hole_highlight.png")

func _ready():
	texture_normal = dirt_icon
	texture_hover = dirt_h
	tree_node.visible = false
	
func _on_pressed() -> void:
	match current_state:
		State.DIRT:
			if Global.current_tool == "Shovel":
				texture_normal = hole_icon
				texture_hover = hole_h
				current_state = State.HOLE
		State.HOLE:
			if Global.inventory["seed"] > 0:
				Global.update_item("seed", -1)
				tree_node.plant_tree()
				current_state = State.GROWING
				texture_hover = null
		State.GROWING:
			tree_node.check_tree_state()
			if tree_node.tree_state == tree_node.TreeState.READY_TO_RESET:
				reset_plot()
				
func reset_plot():
	texture_normal = dirt_icon
	texture_hover = dirt_h
	current_state = State.DIRT
	tree_node.visible = false
	tree_node.reset_tree()
	
func _on_mouse_entered() -> void:
	if Global.current_tool == "Shovel":
		MouseManager.set_cursor("dig")
	else:
		MouseManager.set_cursor("noShovel")
	
func _on_mouse_exited() -> void:
	MouseManager.set_cursor("default")
