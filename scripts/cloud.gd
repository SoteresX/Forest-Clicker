extends TextureRect

@export var speed_min: float = 15.0
@export var speed_max: float = 40.0
@export var cloud_textures: Array[Texture2D]

var current_speed: float

func _ready() -> void:
	randomize_cloud(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= current_speed * delta
	
	if position.x < -size.x * scale.x:
		randomize_cloud(false)
		
func randomize_cloud(start_random_x: bool):
	if cloud_textures.size() > 0:
		texture = cloud_textures.pick_random()
	
	current_speed = randf_range(speed_min, speed_max)
	
	var parent_rect = get_parent_control().get_rect().size
	position.y = randf_range(10, parent_rect.y * 0.3)
	
	if start_random_x:
		position.x = randf_range(0, parent_rect.x)
	else:
		position.x = parent_rect.x + 10
	
	var s = randf_range(0.6, 1.2)
	scale = Vector2(s,s)
	modulate.a = randf_range(0.3,0.7)
