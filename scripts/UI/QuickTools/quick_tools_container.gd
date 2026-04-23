extends HBoxContainer

@onready var tool_container = %QuickToolsContainer
@onready var tool_label: Label = $"../ToolLabel"
var selected_tool : String = ""
var current_tween: Tween

func _ready() -> void:
	
	tool_label.modulate.a = 0
	
	for Button in tool_container.get_children():
		Button.toggled.connect(_on_tool_toggled.bind(Button.name))

func _on_tool_toggled(is_on: bool, tool_name: String) -> void:
	if is_on:
		Global.current_tool = tool_name
		_show_equip_feedback(tool_name)
	else:
		if Global.current_tool == tool_name:
			Global.current_tool = ""

func _show_equip_feedback(tool_name: String) -> void:
	if current_tween:
		current_tween.kill()
	tool_label.text = tool_name.capitalize()
	tool_label.modulate.a = 1.0
	current_tween = create_tween()
	current_tween.tween_interval(1.5)
	current_tween.tween_property(tool_label, "modulate:a", 0.0, 0.5)
