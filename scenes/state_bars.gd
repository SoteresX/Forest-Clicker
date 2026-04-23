extends Control

@onready var water_bar = $WaterBar/Border/Bar
@onready var growth_bar = $GrowthBar/Border/Bar
@onready var cutting_bar = $CutBar/Border/Bar

@onready var water_row = $WaterBar
@onready var growth_row = $GrowthBar
@onready var cut_row = $CutBar

@onready var tree: TextureButton = $"../Plot/Tree"

var water_per_stage: int = 10

func _ready() -> void:
	if tree == null: return
	Global.inventory_updated.connect(_on_inventory_changed)
	tree.tree_updated.connect(_update_ui)
	_on_inventory_changed()
	_update_ui()
	
func _on_inventory_changed() -> void:
	var soil_level = Global.inventory["soil"]
	water_per_stage = clamp(11 - soil_level, 5, 11)
	_update_ui()
		
func _update_ui() -> void:
	var state = tree.tree_state
	
	var is_growing = state in [tree.TreeState.PLANTED, tree.TreeState.GROWING, tree.TreeState.GROWN]
	var is_cuttable = state in [tree.TreeState.FULL, tree.TreeState.CUTTING]
	
	water_row.visible = is_growing
	growth_row.visible = is_growing
	cut_row.visible = is_cuttable
	
	if  is_growing:
		var soil_level = Global.inventory["soil"]
		var water_per_stage = clamp(11 - soil_level, 5, 11)
		water_bar.max_value = water_per_stage
		water_bar.value = tree.water_in_tree % water_per_stage
		
		growth_bar.max_value = 3
		growth_bar.value = _get_growth_value(state)
		
	if is_cuttable:
		var fert_level = Global.inventory["fertilizer"]
		cutting_bar.max_value = 10 + fert_level
		cutting_bar.value = tree.tree_cuts_left
		
func _get_growth_value(state) -> int:
	match state:
		tree.TreeState.PLANTED: return 0
		tree.TreeState.GROWING: return 1
		tree.TreeState.GROWN: return 2
		_: return 0
