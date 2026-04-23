extends PanelContainer

signal trade_completed

@export var avatars: Array[Texture2D]
@export var items: Array[ItemData]

@onready var trade: Button = $MarginContainer/Content/VBoxContainer/Trade
@onready var content: VBoxContainer = $MarginContainer/Content
@onready var timer: Timer = $Timer
@onready var disabled: Panel = $Disabled
@onready var countdown: Label = $Countdown

const avatar_names = [
	"Silas", "Elowen", "Baron", "Mira", "Finnian", 
	"Garrick", "Lyra", "Thistle", "Bramble", "Cinder",
	"Kael", "Oakhart", "Rowan", "Saffron", "Ivy", "Klabo", 
	"Klaboni", "Santouits", "Tony"
]

var required_item: String = "wood"
var required_amount: int
var money_reward: int

var is_on_cooldown: bool = false

func _ready():
	timer.timeout.connect(_on_cooldown_finished)
	generate_random_trade()
	Global.inventory_updated.connect(update_affordability_visual)
	update_affordability_visual()
	
func _process(_delta):
	if not timer.is_stopped():
		countdown.text = str(int(timer.time_left)) + "s"
	
func update_affordability_visual():
	if not content.visible: return
	if is_on_cooldown: return
	
	var current_style = trade.get_theme_stylebox("normal").duplicate()
	if can_afford():
		current_style.bg_color = Color(0.314, 0.933, 0.0, 0.4) 
	else:
		current_style.bg_color = Color(0.10, 0.10, 0.10, 0.60)
	trade.add_theme_stylebox_override("normal", current_style)
	
func generate_random_trade():
	if avatars.size() > 0:
		$MarginContainer/Content/AvatarWrapper/AvatarBorder/Avatar.texture = avatars.pick_random()
	
	var random_name = avatar_names.pick_random()
	$MarginContainer/Content/AvatarWrapper/AvatarName/LabelCenter/Name.text = random_name
	
	for i in items:
		if i.reward_type == "wood":
			%ItemNeeded.texture = i.icon 
			break
	
	required_amount = randi_range(15, 50)
	var calculation = (required_amount / 2.0) * randi_range(1.1, 1.3)
	money_reward = int(calculation)
	$MarginContainer/Content/VBoxContainer/Requirement/Amount.text = str(required_amount)
	$MarginContainer/Content/VBoxContainer/Reward/Amount.text = str(money_reward)

func _on_trade_pressed() -> void:
	if Global.inventory.get(required_item, 0) >= required_amount:
		Global.update_item(required_item, -required_amount)
		Global.update_item("money", money_reward)
		Global.trade_finished.emit()
		
		start_cooldown()

func start_cooldown():
	is_on_cooldown = true
	disabled.visible = true
	countdown.visible = true
	trade.disabled = true
	var cooldown_time = randf_range(20.0, 30.0)
	timer.start(cooldown_time)

func _on_cooldown_finished():
	is_on_cooldown = false
	generate_random_trade()
	
	disabled.visible = false
	countdown.visible = false
	
	content.visible = true
	trade.disabled = false
	update_affordability_visual()
	Global.trade_finished.emit()

func can_afford() -> bool:
	if is_on_cooldown:
		return false
	return Global.inventory.get(required_item, 0) >= required_amount
