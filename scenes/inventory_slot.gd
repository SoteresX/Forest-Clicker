extends PanelContainer

@onready var icon_rect = $Margin/Content/Icon
@onready var count_label = $Margin/Content/Amount
@export var item_key: String = "water"
@export var item_icon: Texture2D
@export var item_amount: int

func _ready():
	if item_icon and icon_rect:
		icon_rect.texture = item_icon
	Global.inventory_updated.connect(refresh)
	refresh()
	
func set_slot_data(key: String,icon_text: Texture2D):
	item_key= key
	item_icon = icon_text
	if is_inside_tree():
		icon_rect.texture = item_icon
		refresh()

func refresh():
	if Global.inventory.has(item_key):
		var amount = Global.inventory[item_key]
		if item_key == "soil":
			amount -= 1
		count_label.text = str(amount)
