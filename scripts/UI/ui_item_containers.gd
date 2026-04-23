extends HBoxContainer

@export var slot_scene: PackedScene
@export var displayed_items: Array[String] = ["water", "wood", "seed", "money"]
@export var icon_map: Dictionary[String, Texture2D] = {
	"water": null,
	"wood": null,
	"seed": null,
	"money": null,
}

func _ready() -> void:
	setup_ui_slots()
	
func setup_ui_slots() -> void:
	for child in get_children():
		child.queue_free()
		
	for key in displayed_items:
		create_slot(key)
			
func create_slot(key: String) -> void:
	var new_slot = slot_scene.instantiate()
	new_slot.item_key = key
	if icon_map.has(key):
		new_slot.icon_texture = icon_map[key]
		
	add_child(new_slot)
		
		
