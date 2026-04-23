extends Node

var cursors = {
	"default": preload("res://assets/Mouse/default_mouse.png"),
	"well": preload("res://assets/Mouse/bucket_mouse.png"),
	"noBucket": preload("res://assets/Mouse/bucket_unselected_mouse.png"),
	"water": preload("res://assets/Mouse/water_mouse.png"),
	"noWater": preload("res://assets/Mouse/noWater_mouse.png"),
	"chop": preload("res://assets/Mouse/cut_mouse.png"),
	"noAxe": preload("res://assets/Mouse/noAxe_mouse.png"),
	"dig": preload("res://assets/Mouse/dig_mouse.png"),
	"noShovel": preload("res://assets/Mouse/noShovel_mouse.png")
}

func set_cursor(type: String):
	if cursors.has(type):
		var hotspot = Vector2(0,0)
		hotspot = Vector2(16,16)
		Input.set_custom_mouse_cursor(cursors[type], Input.CURSOR_ARROW)
	else:
		Input.set_custom_mouse_cursor(cursors["default"])
