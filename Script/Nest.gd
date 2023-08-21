extends Node2D

@onready var SingleTile = preload("res://Script/Class/Tiles.gd")
var nest_scene = preload("res://Scenes/alien_nest.tscn")

func _on_teren_plase_nest(cord,z):
	var chance_to_appear = randi() % 100 + 1

	if chance_to_appear <= 10:
		var nest_instance = nest_scene.instantiate()
		nest_instance.position.x = cord.x-16
		nest_instance.position.y = cord.y-16
		nest_instance.z_index = z
		add_child(nest_instance)
