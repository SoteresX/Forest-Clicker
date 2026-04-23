extends Button

var main
func _ready():
	main = get_parent()

func _on_pressed() -> void:
	if Global.current_tool == "Bucket":
		main.refill_water(5)

func _on_mouse_entered() -> void:
	if Global.current_tool == "Bucket":
		MouseManager.set_cursor("well")
	else:
		MouseManager.set_cursor("noBucket")
		
func _on_mouse_exited() -> void:
	MouseManager.set_cursor("default")
