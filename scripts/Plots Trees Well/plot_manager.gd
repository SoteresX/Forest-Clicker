extends Control

@export var tree: PackedScene = preload("res://scenes/Tree.tscn")

@onready var spawn_points = [$Pos1, $Pos2, $Pos3]

func _ready() -> void:
	Global.inventory_updated.connect(refresh_plots)
	refresh_plots()
	
func refresh_plots() -> void:
	var owned_plots = 0 + Global.inventory.get("plot", 0)
	var current_plots = get_tree().get_nodes_in_group("plots")
	
	for i in range(current_plots.size(), owned_plots):
		if i < spawn_points.size():
			spawn_plot(i)

func spawn_plot(index: int) -> void:
	var new_plot = tree.instantiate()
	add_child(new_plot)
	new_plot.add_to_group("plots")
	new_plot.global_position = spawn_points[index].global_position
