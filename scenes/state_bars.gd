extends Control

#For Bar progress animation
var water_tween: Tween
var growth_tween: Tween
var cut_tween: Tween

@onready var water_bar = $WaterBar/Bar
@onready var growth_bar = $GrowthBar/Bar
@onready var cutting_bar = $CutBar/Bar

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
		var next_water_val = tree.water_in_tree % water_per_stage
		
		if water_tween: water_tween.kill()
		water_tween = create_tween()
		water_tween.tween_property(water_bar, "value", next_water_val, 0.3).set_trans(Tween.TRANS_SINE)
		
		growth_bar.max_value = 3
		var next_growth_val = _get_growth_value(state)
		if state == tree.TreeState.PLANTED:
			growth_bar.value = 0
		
		if growth_tween: growth_tween.kill()
		growth_tween = create_tween()
		growth_tween.tween_property(growth_bar, "value", next_growth_val, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	if is_cuttable:
		var fert_level = Global.inventory["fertilizer"]
		cutting_bar.max_value = 10 + fert_level
		
		if cut_tween: cut_tween.kill()
		cut_tween = create_tween()
		# We use EASE_OUT so the bar "drops" satisfyingly when you chop
		cut_tween.tween_property(cutting_bar, "value", tree.tree_cuts_left, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
func _get_growth_value(state) -> int:
	match state:
		tree.TreeState.PLANTED: return 0
		tree.TreeState.GROWING: return 1
		tree.TreeState.GROWN: return 2
		_: return 0
