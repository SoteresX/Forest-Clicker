extends Button

var empty_icon = preload("res://assets/Tools/bucket.png")
var lil_full_icon = preload("res://assets/Tools/bucket_lil_filled.png")
var full_icon = preload("res://assets/Tools/bucket_filled.png")

func _ready() -> void:
	Global.inventory_updated.connect(update_icon)
	update_icon()

func update_icon():
	if not is_inside_tree(): return
	if Global.inventory["water"] == 0:
		icon = empty_icon
	elif Global.inventory["water"] <= (Global.get_max_water() / 2):
		icon = lil_full_icon
	else:
		icon = full_icon
