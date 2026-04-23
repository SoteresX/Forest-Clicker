extends Control

@onready var exp_bar = $EXP
@onready var level_value: Label = $IconBg/LevelValue

func _ready():
	Global.exp_changed.connect(update_ui)
	Global.leveled_up.connect(on_level_up)
	update_ui(Global.current_exp, Global.target_exp)
	level_value.text = str(Global.current_level)
	
func update_ui(current_exp, target):
	exp_bar.max_value = target
	var tween = create_tween()
	tween.tween_property(exp_bar, "value", current_exp, 0.5)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
	
func on_level_up(new_level):
	level_value.text = str(new_level)
