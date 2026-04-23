extends Resource
class_name ItemData

@export var icon: Texture2D
@export var name: String = "Item Name"
@export var description: String = "Item Description"
@export var cost_type: String = "E.X Wood, Money"
@export var price: int = 30
@export var requirement_icon: Texture2D
@export var reward_type: String = "E.X Axe, Pickaxe"
@export var reward_amount: int = 1
#Maximum level 0 = infinite
@export var max_level: int = 0
