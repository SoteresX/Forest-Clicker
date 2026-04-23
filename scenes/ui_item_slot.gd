extends Control

@export var item_key: String = ""
@export var icon_texture: Texture2D:
	set(value):
		icon_texture = value
		if is_node_ready():
			update_icon()

@onready var value_label: Label = $Panel/Value
@onready var icon_rect: TextureRect = $Icon

func _ready() -> void:
	update_icon()
	Global.inventory_updated.connect(update_display)
	update_display()
	
func update_icon() -> void:
	if icon_texture and is_instance_valid(icon_rect):
		icon_rect.texture = icon_texture
		
func update_display() -> void:
	if item_key == "":
		return
	if Global.inventory.has(item_key):
		value_label.text = str(Global.inventory[item_key])
