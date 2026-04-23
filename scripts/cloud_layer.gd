extends Control

@export var cloud_scene: PackedScene
@export var cloud_count: int = 5

func _ready():
	spawn_clouds()

func spawn_clouds():
	for i in range(cloud_count):
		var new_cloud = cloud_scene.instantiate()
		add_child(new_cloud)
		
