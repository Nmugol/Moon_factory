extends Node2D

var tree_scene = preload("res://Scenes/tree.tscn")

func _on_teren_plase_tree(cord:Vector2i, zIndex:int):
	var chance_to_appear:int = randi() % 100 + 1
	if chance_to_appear <= 5:
		var tree_instance = tree_scene.instantiate()

		tree_instance.position.x = cord.x
		tree_instance.position.y = cord.y - GlobaData.tree_offset

		tree_instance.z_index = zIndex

		add_child(tree_instance)